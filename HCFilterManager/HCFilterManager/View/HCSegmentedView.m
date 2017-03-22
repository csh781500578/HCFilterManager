//
//  HCSegmentedView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCSegmentedView.h"

#define BUTTON_VIEW_TAG_DEFAULT 1100

#define RED_LINE_VIEW_HEIGHT 2.0

@interface HCSegmentedView()

/** 选中下划线 */
@property(nonatomic, strong) UIView *bottomRedView;

@end

@implementation HCSegmentedView

- (instancetype)initWithFrame:(CGRect)frame themes:(NSArray *)themes {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutSubButtonWithThemes:themes];
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,frame.size.height - LINE_VIEW_HEIGHT,SCREEN_WIDTH,LINE_VIEW_HEIGHT}];
        lineView.backgroundColor = [UIColor lineDefaultColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setThemes:(NSArray *)themes {
    _themes = themes;
    
    NSUInteger count = themes.count;
    if (count != self.themes.count) {
        CGFloat width = self.leju_width / count;
        CGFloat height = self.leju_height - RED_LINE_VIEW_HEIGHT;
        for (NSUInteger i = 0; i < count; i ++) {
            NSString *theme = [themes objectAtIndex:i];
            HCFilterMenuButton *button = [self viewWithTag:BUTTON_VIEW_TAG_DEFAULT + i];
            if (button) {
                button.frame = CGRectMake(i * width, 0, width, button.leju_height);
                [button setTitle:theme forState:HCControlStateNormal];
            }else {
                HCFilterMenuButton *button = [HCFilterMenuButton filterButton];
                button.frame = CGRectMake(i * width, 0, width, height);
                [button setTitle:theme forState:HCControlStateNormal];
                [button setTitleColor:TITLE_COLOR forState:HCControlStateNormal];
                [button setTitleColor:RED_COLOR forState:HCControlStateSelected];
                [button addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = BUTTON_VIEW_TAG_DEFAULT + i;
                [self addSubview:button];
            } 
        }
    }
}

- (void)layoutSubButtonWithThemes:(NSArray *)themes {
    self.themes = themes;
    NSUInteger count = themes.count;
    CGFloat width = self.leju_width / count;
    CGFloat height = self.leju_height - RED_LINE_VIEW_HEIGHT;
    for (int i = 0; i < count; i ++) {
        NSString *theme = [themes objectAtIndex:i];
        if (![theme isKindOfClass:[NSString class]]) {
            return;
        }
        
        HCFilterMenuButton *button = [HCFilterMenuButton filterButton];
        button.frame = CGRectMake(i * width, 0, width, height);
        [button setTitle:theme forState:HCControlStateNormal];
        [button setTitleColor:TITLE_COLOR forState:HCControlStateNormal];
        [button setTitleColor:RED_COLOR forState:HCControlStateSelected];
        [button addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BUTTON_VIEW_TAG_DEFAULT + i;
        [self addSubview:button];
        if (i == 0) {
            button.selected = YES;
            self.bottomRedView = [[UIView alloc] initWithFrame:(CGRect){0,height,width,RED_LINE_VIEW_HEIGHT}];
            self.bottomRedView.backgroundColor = RED_COLOR;
            [self addSubview:self.bottomRedView];
        }
    }
}

- (void)didSelectAction:(UIButton *)button {
    NSUInteger count = self.themes.count;
    for (int i = 0; i < count; i ++) {
        UIButton *filterButton = [self viewWithTag:BUTTON_VIEW_TAG_DEFAULT + i];
        if (filterButton != button) {
            filterButton.selected = NO;
        }else {
            button.selected = YES;
            CGRect rect = button.frame;
            rect.origin.y = rect.size.height;
            rect.size.height = RED_LINE_VIEW_HEIGHT;
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomRedView.frame = rect;
            }]; 
        }
    }
    
    if (self.selectSegmentedButtonBlock) {
        self.selectSegmentedButtonBlock(button.tag - BUTTON_VIEW_TAG_DEFAULT);
    }
}

@end
