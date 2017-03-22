//
//  HCSingleCollectionView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/17.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterCollectionView.h"
#import "HCFilterFillingView.h"
#import "HCFilterResultModel.h"
#import "HCFilterConfig.h"

#define COMMIT_VIEW_BUTTON_HEIGHT 42

// collectionview cell
@interface HCCollectionViewCell : UICollectionViewCell

/** model */
@property(nonatomic, strong) HCFilterCodeModel *model;

/** 内容 */
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation HCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.0;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = LAYER_BORDER_COLOR.CGColor;
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.textColor = SEPARATE_VIEW_BACKGROUND_COLOR;
            label.font = UIFont(13);
            label.textAlignment = NSTextAlignmentCenter;
            
            label;
        });
        
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setModel:(HCFilterCodeModel *)model {
    _model = model;
    self.contentLabel.text = model.name;
    
    if (model.selected) {
        self.layer.borderColor = ENABLE_BUTTON_BACKGROUND_COLOR.CGColor;
        self.contentLabel.textColor = ENABLE_BUTTON_BACKGROUND_COLOR;
    }else {
        self.layer.borderColor = LAYER_BORDER_COLOR.CGColor;
        self.contentLabel.textColor = SEPARATE_VIEW_BACKGROUND_COLOR;
    }
}

@end

// collectionview header
@interface HCMoreCollectionViewHeader : UICollectionReusableView

/** text label */
@property(nonatomic, strong) UILabel *textLabel;

@end

@implementation HCMoreCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLLECTION_HEADER_BACKGROUND_COLOR;
        self.textLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){SUB_VIEW_LEADING,0,frame.size.width - SUB_VIEW_LEADING,frame.size.height}];
            label.font = UIFont(12);
            
            label;
        });
        [self addSubview:self.textLabel];
    }
    return self;
}

@end

// collection commit view
@interface HCCollectionCommitView : UIView

/** 清空 */
@property(nonatomic, strong) UIButton *clearButton;
/** 确定 */
@property(nonatomic, strong) UIButton *commitButton;

/** 点击清空 **/
@property(nonatomic,copy) void (^clickClearActionBlock)();
/** 点击完成 **/
@property(nonatomic,copy) void (^clickCommitActionBolck)();

@end

@implementation HCCollectionCommitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = (frame.size.width - SUB_VIEW_LEADING * 3) / 2;
        self.clearButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = (CGRect){SUB_VIEW_LEADING,10,width,frame.size.height};
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"清空" forState:UIControlStateNormal];
            [button setTitleColor:ENABLE_BUTTON_BACKGROUND_COLOR forState:UIControlStateNormal];
            button.titleLabel.font    = UIFont(18);
            button.layer.borderColor  = ENABLE_BUTTON_BACKGROUND_COLOR.CGColor;
            button.layer.borderWidth  = 1;
            button.layer.cornerRadius = 3;
            [button addTarget:self action:@selector(didTapClearButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        
        self.commitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = (CGRect){SUB_VIEW_LEADING * 2 + width,10,width,frame.size.height};
            button.backgroundColor = ENABLE_BUTTON_BACKGROUND_COLOR;
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor  = [UIColor whiteColor].CGColor;
            button.titleLabel.font    = UIFont(18);
            button.layer.borderWidth  = 1;
            button.layer.cornerRadius = 3;
            [button addTarget:self action:@selector(didTapCommitButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        [self addSubview:self.clearButton];
        [self addSubview:self.commitButton];
    }
    return self;
}

- (void)didTapClearButton:(UIButton *)button {
    if (self.clickClearActionBlock) {
        self.clickClearActionBlock();
    }
}

- (void)didTapCommitButton:(UIButton *)button {
    if (self.clickCommitActionBolck) {
        self.clickCommitActionBolck();
    }
}

@end

// collection view
@interface HCFilterCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

/** collection view */
@property(nonatomic, strong) UICollectionView *collectionView;

/** fill in view */
@property(nonatomic, strong) HCFilterFillingView *fillingView;

/** commit view */
@property(nonatomic, strong) HCCollectionCommitView *commitView;
/** single code **/
@property(nonatomic,copy) NSString *singleCode;
@end

@implementation HCFilterCollectionView

- (void)setType:(HCCollectionType)type {
    _type = type;
    switch (type) {
        case HCCollectionTypeNone: {
            self.collectionView.frame = self.bounds;
        }
            break;
        case HCCollectionTypeCustom: {
            self.fillingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, FILLING_VIEW_HEIGHT);
            self.collectionView.frame = CGRectMake(0, FILLING_VIEW_HEIGHT, SCREEN_WIDTH, self.leju_height - FILLING_VIEW_HEIGHT);
        }
            break;
        case HCCollectionTypeMore: {
            self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.leju_height - COLLECTION_COMMIT_VIEW_HEIGHT);
            self.commitView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_WIDTH, COMMIT_VIEW_BUTTON_HEIGHT);
        }
            break;
        default:
            break;
    }
}

- (void)setModelList:(NSArray *)modelList {
    _modelList = modelList;
    [self.collectionView reloadData];
}

//=================================================================
//                           collection view delegate
//=================================================================
#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.type == HCCollectionTypeNone || self.type == HCCollectionTypeCustom) {
        return 1;
    }
    return _modelList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == HCCollectionTypeNone) {
        return _modelList.count;
    }else if (self.type == HCCollectionTypeCustom) {
        return _modelList.count - 1;
    }
    HCFilterTitleModel *titleModel = [_modelList objectAtIndex:section];
    NSArray *array = titleModel.lists;
    return array.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == HCCollectionTypeNone || self.type == HCCollectionTypeCustom) {
        return (CGSize){(SCREEN_WIDTH - 30 - 11 ) / 2, COLLECTION_VIEW_CELL_HEIGHT};
    }
    return (CGSize){(SCREEN_WIDTH - 30 - 11 ) / 4, COLLECTION_VIEW_CELL_HEIGHT};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.type == HCCollectionTypeMore) {
        return CGSizeMake(SCREEN_WIDTH, 28);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HCMoreCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HCMoreCollectionViewHeader class]) forIndexPath:indexPath];
    HCFilterTitleModel *titleModel = [_modelList objectAtIndex:indexPath.section];
    NSString *key = titleModel.name;
    header.textLabel.text = key;
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HCCollectionViewCell class]) forIndexPath:indexPath];
    if (self.type == HCCollectionTypeNone || self.type == HCCollectionTypeCustom) {
        HCFilterCodeModel *model = [_modelList objectAtIndex:indexPath.row];
        cell.model = model;
        [self findSingleCodeInModel:model];
        
    }else if (self.type == HCCollectionTypeMore) {
        HCFilterTitleModel *titleModel = [_modelList objectAtIndex:indexPath.section];
        NSArray *array = titleModel.lists;
        HCFilterCodeModel *model = [array objectAtIndex:indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == HCCollectionTypeNone || self.type == HCCollectionTypeCustom) {
        [_modelList enumerateObjectsUsingBlock:^(HCFilterTitleModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        HCFilterCodeModel *model = [_modelList objectAtIndex:indexPath.row];
        model.selected = YES;
        [self didSelectFilterModel:model codes:@[model.code]];
    }else if (self.type == HCCollectionTypeMore) {
        HCFilterTitleModel *titleModel = [_modelList objectAtIndex:indexPath.section];
        [titleModel.lists enumerateObjectsUsingBlock:^(HCFilterCodeModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.selected = NO;
        }];
        HCFilterCodeModel *model = [titleModel.lists objectAtIndex:indexPath.row];
        model.selected = YES;
    }
    
    [self.collectionView reloadData];
}

- (void)didClearFilterCodesAction {
    [_modelList enumerateObjectsUsingBlock:^(HCFilterTitleModel  *_Nonnull titleModel, NSUInteger idx, BOOL * _Nonnull stop) {
        titleModel.selected = NO;
        [titleModel.lists enumerateObjectsUsingBlock:^(HCFilterCodeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                obj.selected = NO;
            }
        }];
    }];
    [self.collectionView reloadData]; 
}

- (void)didCommitFilterCodesAction {
    __block HCFilterCodeModel *model = nil;
    __block NSMutableArray *codes = [NSMutableArray arrayWithCapacity:4];
    [_modelList enumerateObjectsUsingBlock:^(HCFilterTitleModel  *_Nonnull titleModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleModel.lists enumerateObjectsUsingBlock:^(HCFilterCodeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                model = obj;
                [codes addObject:obj.code];
            }
        }];
    }];
    [self didSelectFilterModel:model codes:codes];
}

- (void)didSelectFilterModel:(HCFilterCodeModel *)model codes:(NSArray *)codes{
    NSMutableDictionary *object = [@{
                                     kNotificationSelectTitleIndex : @(self.showIndex),
                                     } mutableCopy];
    if (model.code && model.code.length > 0) {
        [object addEntriesFromDictionary:@{kNotificationSelectFilterModel : model}];
    }
    if (codes) {
        [object addEntriesFromDictionary:@{kNotificationSelectFilterCodes : codes}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPullDownViewDismissKey object:object];
}

// 插入自定义数据
- (void)didFillingCustomDataFromValue:(NSString *)fromValue toValue:(NSString *)toValue unit:(NSString *)unit {
    for (HCFilterCodeModel *codeModel in _modelList) {
        if (codeModel.isCustomed) {
            NSString *value = [[fromValue stringByAppendingString:@"-"] stringByAppendingString:toValue];
            codeModel.name = [value stringByAppendingString:unit];
            codeModel.code = [self.singleCode stringByAppendingString:value];
        }
    }
}

// 找到这个菜单下专属的code
- (void)findSingleCodeInModel:(HCFilterCodeModel *)model {
    if (model.code.length > 0) {
        if (!self.singleCode) {
            self.singleCode = model.code;
        }else {
            for (int i = 0; i < self.singleCode.length; i++) {
                unichar ch = [model.code characterAtIndex:i];
                unichar cha = [self.singleCode characterAtIndex:i];
                if (ch != cha) {
                    NSString *chaString = [NSString stringWithCharacters:&cha length:1];
                    self.singleCode = [[self.singleCode componentsSeparatedByString:chaString] firstObject];
                }
            }
        }
    }
}

//=================================================================
//                           lazy loading
//=================================================================
#pragma mark - lazy loading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 11;
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HCCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HCCollectionViewCell class])];
        [_collectionView registerClass:[HCMoreCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HCMoreCollectionViewHeader class])];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (HCFilterFillingView *)fillingView {
    if (!_fillingView) {
        _fillingView = [[HCFilterFillingView alloc] initWithFrame:CGRectZero];
        [self addSubview:_fillingView];
        WEAK_SELF(__weakSelf, self);
        [_fillingView setResultFromValueToValueBlock:^(NSString *fromValue, NSString *toValue, NSString *unit) {
            [__weakSelf didFillingCustomDataFromValue:fromValue toValue:toValue unit:unit];
        }];
    }
    return _fillingView;
}

- (HCCollectionCommitView *)commitView {
    if (!_commitView) {
        _commitView = [[HCCollectionCommitView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,COMMIT_VIEW_BUTTON_HEIGHT}];
        [self addSubview:_commitView];
        WEAK_SELF(__weakSelf, self);
        [_commitView setClickClearActionBlock:^(){
            [__weakSelf didClearFilterCodesAction];
        }];
        [_commitView setClickCommitActionBolck:^(){
            [__weakSelf didCommitFilterCodesAction];
        }];
    }
    return _commitView;
}

@end


