//
//  HCPullDownView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCPullDownView.h"
#import "HCSegmentedView.h"
#import "HCDoubleTableView.h"
#import "HCFilterConfig.h"
#import "HCFilterCollectionView.h"

#define TABLE_VIEW_HEIGHT_MAX ((SCREEN_HEIGHT - 2 * FILTER_VIEW_HEIGHT - 64) * 3 / 4.0)

@interface HCPullDownView()

/** 分节view */
@property(nonatomic, strong) HCSegmentedView *segmentedView;

/** 双列tableview */
@property(nonatomic, strong) HCDoubleTableView *doubleTableView;
/** 单列collectionview */
@property(nonatomic, strong) HCFilterCollectionView *singleCollectionView;

/** more collection view */
@property(nonatomic, strong) HCFilterCollectionView *moreCollectionView;

@end

@implementation HCPullDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    if (titles.count > 0) {
        if (!self.segmentedView) {
            HCSegmentedView *segmentedView = [[HCSegmentedView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,FILTER_VIEW_HEIGHT} themes:titles];
            self.segmentedView = segmentedView;
            [self addSubview:self.segmentedView];
        }
        if (titles != self.segmentedView.themes) {
            self.segmentedView.themes = titles;
        }
        WEAK_SELF(weakSelf, self);
        [self.segmentedView setSelectSegmentedButtonBlock:^(NSInteger index) {
            [weakSelf buildTableViewAtIndex:index];
        }];
    }
}

- (void)setTitleModel:(HCFilterTitleModel *)titleModel {
    _titleModel = titleModel;
    [self buildTableViewAtIndex:0];
}

// 如果没有二级菜单，直接展示数据，否则，默认展示第一个二级菜单的数据
- (void)buildTableViewAtIndex:(NSInteger)index {
    NSString *key = _titleModel.name;
    NSArray *objects = _titleModel.segment;
    
    NSArray *titles = titlesFromTitleModels(objects);
    [self setTitles:titles];
    HCFilterListType type = pullDownViewTypeByKey(key);
    switch (type) {
        case HCFilterListTypeDouble:
            if ([objects isKindOfClass:[NSArray class]] && objects.count >= index) {
                [self addDoubleTableViewWithTitleModel:[objects objectAtIndex:index]];
            }
            break;
        case HCFilterListTypeSingle:
            [self addSingleCollectionViewWithTitleModels:_titleModel];
            break;
        case HCFilterListTypeMore:
            if ([objects isKindOfClass:[NSArray class]] && objects.count >= index) {
                [self addMoreCollectionViewWithTitleModels:[objects objectAtIndex:index]];
            }
            break;
        default:
            break;
    }
}

// 双列 view
- (void)addDoubleTableViewWithTitleModel:(HCFilterTitleModel *)titleModel {
    if (![titleModel isKindOfClass:[HCFilterTitleModel class]]) {
        return;
    }
    self.view_height = FILTER_VIEW_HEIGHT + TABLE_VIEW_HEIGHT_MAX;
    self.doubleTableView.listModels = titleModel;
    self.doubleTableView.showIndex = self.showIndex;
}

// 单列 view
- (void)addSingleCollectionViewWithTitleModels:(HCFilterTitleModel *)titleModels {
    HCCollectionType collectionType = HCCollectionTypeNone;
    if ([fillingCustomArray() containsObject:titleModels.name]) {
        NSInteger count = ceilf(([titleModels.lists count] - 1) / 2.0);
        collectionType = HCCollectionTypeCustom;
        self.view_height = FILLING_VIEW_HEIGHT + COLLECTION_VIEW_LEADING * (count + 1) + COLLECTION_VIEW_CELL_HEIGHT * count;
    }else {
        NSInteger count = ceilf([titleModels.lists count] / 2.0);
        collectionType = HCCollectionTypeNone;
        self.view_height = COLLECTION_VIEW_LEADING * (count + 1) + COLLECTION_VIEW_CELL_HEIGHT * count;
    }
    
    self.singleCollectionView.frame = (CGRect){0,0,SCREEN_WIDTH,self.view_height};
    self.singleCollectionView.type = collectionType;
    
    self.singleCollectionView.modelList = titleModels.lists;
    self.singleCollectionView.showIndex = self.showIndex;
}

- (void)addMoreCollectionViewWithTitleModels:(HCFilterTitleModel *)titleModels {
    if (![titleModels isKindOfClass:[HCFilterTitleModel class]]) {
        return;
    }
    self.view_height = TABLE_VIEW_HEIGHT_MAX + COLLECTION_COMMIT_VIEW_HEIGHT;
    
    self.moreCollectionView.frame = (CGRect){0,FILTER_VIEW_HEIGHT,SCREEN_WIDTH,self.view_height - FILTER_VIEW_HEIGHT};
    self.moreCollectionView.type = HCCollectionTypeMore;
    
    NSArray *array = titleModels.segment;
    self.moreCollectionView.modelList = array;
    self.moreCollectionView.showIndex = self.showIndex;
} 

- (HCDoubleTableView *)doubleTableView {
    if (!_doubleTableView) {
        _doubleTableView = [[HCDoubleTableView alloc] initWithFrame:(CGRect){0,FILTER_VIEW_HEIGHT,SCREEN_WIDTH,TABLE_VIEW_HEIGHT_MAX}];
        [self addSubview:_doubleTableView];
    }
    return _doubleTableView;
}

- (HCFilterCollectionView *)singleCollectionView {
    if (!_singleCollectionView) {
        _singleCollectionView = [[HCFilterCollectionView alloc] initWithFrame:CGRectZero];
        [self addSubview:_singleCollectionView];
    }
    return _singleCollectionView;
}

- (HCFilterCollectionView *)moreCollectionView {
    if (!_moreCollectionView) {
        _moreCollectionView = [[HCFilterCollectionView alloc] initWithFrame:CGRectZero];
        [self addSubview:_moreCollectionView];
    }
    return _moreCollectionView;
}

@end
