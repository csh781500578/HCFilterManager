//
//  HCFilterContentView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterContentView.h"

#define PULL_DOWN_VIEW_TAG_DEFAULT 1000
#define ANIMATION_TIME_INTERNAL 0.1

@interface HCFilterContentView()

/** 菜单栏 */
@property(nonatomic, strong) HCFilterMenuView *menuView;

/** lists **/
@property(nonatomic,copy) NSArray *dataList;

/** 背景view */
@property(nonatomic, strong) UIView *backgroundView;
/** 展示 */
@property(nonatomic, assign) BOOL isShow;

@end

@implementation HCFilterContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownViewCommitNotification:) name:kNotificationPullDownViewDismissKey object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pullDownViewCommitNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    NSNumber *number = [userInfo objectForKey:kNotificationSelectTitleIndex];
    NSArray *codes = [userInfo objectForKey:kNotificationSelectFilterCodes] ?: @[];
    if (self.dataList.count >= [number integerValue] ) {
        NSMutableArray *mutableArray = [self.selectedCodes objectAtIndex:[number integerValue]];
        [mutableArray removeAllObjects];
        [mutableArray addObjectsFromArray:codes];
        // 清理所有单选的model
        [self deselectSingleModelAtIndex:[number integerValue]];
    }
    
    [self dismissPullDownView:nil];
}

// 数据
- (void)setContentViewWithList:(NSArray<HCFilterTitleModel *> *)list {
    self.dataList = list;
    self.selectedCodes = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < list.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        [self.selectedCodes addObject:array];
    }
    [self setTitlesForMenuView];
}

- (void)setTitlesForMenuView {
    self.menuView.titles = self.dataList;
}

// 点击菜单主题
- (void)didSelectTitleAtIndex:(NSInteger)index selected:(BOOL)selected {
    if (selected) {
        WEAK_SELF(weakSelf, self);
        [self dismissPullDownView:^{
            [weakSelf showPullDownViewAtIndex:index];
        }];
    }else {
        [self dismissPullDownView:nil];
    }
}

// 显示下拉菜单
- (void)showPullDownViewAtIndex:(NSInteger)index {
    self.isShow = YES;
    
    HCPullDownView *pullDownView = [self viewWithTag:PULL_DOWN_VIEW_TAG_DEFAULT + index];
    if (!pullDownView) {
        pullDownView = [[HCPullDownView alloc] initWithFrame:(CGRect){0,FILTER_VIEW_HEIGHT,SCREEN_WIDTH,FILTER_VIEW_HEIGHT}];
        pullDownView.tag = PULL_DOWN_VIEW_TAG_DEFAULT + index;
        pullDownView.clipsToBounds = YES;
        pullDownView.showIndex = index;
        
    }
    HCFilterTitleModel *titleModel = [self.dataList objectAtIndex:index];
    if ([titleModel isKindOfClass:[HCFilterTitleModel class]]) {
        pullDownView.titleModel = titleModel;
    }
    
    [self insertSubview:pullDownView belowSubview:self.menuView];
    [self layoutIfNeeded];
    
    CGRect rect = self.frame;
    rect.size.height = SCREEN_HEIGHT;
    self.frame = rect;
    
    self.backgroundView.alpha = 0;
    pullDownView.leju_height = FILTER_VIEW_HEIGHT;
    
    [UIView animateWithDuration:ANIMATION_TIME_INTERNAL delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.2;
        CGRect frame = pullDownView.frame;
        frame.size.height = pullDownView.view_height;
        pullDownView.frame = frame;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

// 收起下拉菜单
- (void)dismissPullDownView:(void (^)(void))finish {
    if (!finish) {
        [self.menuView cancelSelected];
    }
    if (self.isShow) {
        self.isShow = NO;
        self.leju_height = FILTER_VIEW_HEIGHT;
        
        [UIView animateWithDuration:ANIMATION_TIME_INTERNAL animations:^{
            for (int i = 0; i < self.titles.count; i ++) {
                HCPullDownView *pullDownView = [self viewWithTag:PULL_DOWN_VIEW_TAG_DEFAULT + i];
                pullDownView.leju_height = 0;
            }
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finish) {
                finish();
            }
        }];
    }else{
        if (finish) {
            finish();
        }
    }
}

// 清理单选的model
- (void)deselectSingleModelAtIndex:(NSInteger)index {
    HCFilterTitleModel *titleModel = [self.dataList objectAtIndex:index];
    if (self.didSelectCodesAtTitleModel) {
        self.didSelectCodesAtTitleModel(titleModel);
    }
}

// 显示标题
- (void)setShowTitlesWithModel:(HCFilterCodeModel *)model index:(NSInteger)index {
    HCFilterTitleModel *titleModel = [self.dataList objectAtIndex:index];
    if (model) {
        titleModel.selected = YES;
        titleModel.title = model.name;
        if ([titleModel.name isEqualToString:@"更多"]) {
            titleModel.title = nil;
        }
    }else {
        titleModel.selected = NO;
        titleModel.title = nil;
    }
    [self setTitlesForMenuView];
}

- (NSArray *)titles {
    return self.menuView.titles;
}

// 点击回收
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.backgroundView) {
        [self dismissPullDownView:nil];
    }
    return [super hitTest:point withEvent:event];
}

//=================================================================
//                           懒加载
//=================================================================
#pragma mark - 懒加载
- (HCFilterMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[HCFilterMenuView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,FILTER_VIEW_HEIGHT}];
        [self addSubview:_menuView];
        WEAK_SELF(weakSelf, self);
        [_menuView setSelectClickTitleButtonBlock:^(NSInteger index, BOOL selected) {
            [weakSelf didSelectTitleAtIndex:index selected:selected];
        }];
    }
    return _menuView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
        _backgroundView.backgroundColor = [UIColor darkTextColor];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
    }
    return _backgroundView;
}

@end
