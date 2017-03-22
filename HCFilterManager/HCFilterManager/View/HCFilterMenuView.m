//
//  HCFilterMenuView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterMenuView.h"

#define FILTER_MENU_VIEW_TAG_DEFAULT 1200

@implementation HCFilterMenuView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,frame.size.height - LINE_VIEW_HEIGHT,SCREEN_WIDTH,LINE_VIEW_HEIGHT}];
        lineView.backgroundColor = LINE_VIEW_DEFAULT_COLOR;
        [self addSubview:lineView];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    NSUInteger count = titles.count;
    CGFloat width = self.leju_width / count;
    CGFloat height = self.leju_height - LINE_VIEW_HEIGHT;
    
    for (int i = 0; i < count; i ++) {
        HCFilterTitleModel *titleModel = [titles objectAtIndex:i];
        NSString *title = titleModel.title ?: titleModel.name;
        HCFilterMenuButton *button = [self viewWithTag:FILTER_MENU_VIEW_TAG_DEFAULT + i];
        if (!button) {
            button = [HCFilterMenuButton filterButton];
        }
        button.frame = CGRectMake(i * width, 0, width, height);
        button.selected = NO;
        
        
        button.titleLabel.minimumScaleFactor = 0.5;
        [button setTitleColor:TITLE_COLOR forState:HCControlStateNormal];
        [button setTitleColor:RED_COLOR forState:HCControlStateSelected];
        [button setImage:FILTER_DOWM_IMAGE forState:HCControlStateNormal];
        [button setImage:FILTER_UP_IMAGE forState:HCControlStateSelected];
        if (titleModel.selected) { 
            [button setTitleColor:RED_COLOR forState:HCControlStateNormal];
            [button setImage:FILTER_SELECTED_IMAGE forState:HCControlStateNormal];
        }
        [button setTitle:title forState:HCControlStateNormal];
        [button addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = FILTER_MENU_VIEW_TAG_DEFAULT + i;
        [self addSubview:button];
    }
}
- (void)didSelectAction:(UIButton *)button {
    [self cancelSelectedWithoutButton:button];
    button.selected = !button.selected;
    if (self.selectClickTitleButtonBlock) {
        self.selectClickTitleButtonBlock((button.tag - FILTER_MENU_VIEW_TAG_DEFAULT),button.selected);
    }
}

- (void)cancelSelected {
    [self cancelSelectedWithoutButton:nil];
}

- (void)cancelSelectedWithoutButton:(UIButton *)button {
    NSUInteger count = self.titles.count;
    for (int i = 0; i < count; i ++) {
        UIButton *filterButton = [self viewWithTag:FILTER_MENU_VIEW_TAG_DEFAULT + i];
        if (filterButton != button) {
            filterButton.selected = NO;
        }
    }
}

@end
