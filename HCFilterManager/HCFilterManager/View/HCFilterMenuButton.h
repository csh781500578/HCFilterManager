//
//  HCFilterButton.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, HCControlState) {
    HCControlStateNormal      = UIControlStateNormal,
    HCControlStateHighlighted = UIControlStateHighlighted, // used when UIControl isHighlighted is set
    HCControlStateDisabled    = UIControlStateDisabled,
    HCControlStateSelected    = UIControlStateSelected,    // flag usable by app (see below)
    HCControlStateFocused     = UIControlStateFocused ,    // Applicable only when the screen supports focus
    HCControlStateApplication = UIControlStateApplication, // additional flags available for application use
    HCControlStateReserved    = UIControlStateReserved     // flags reserved for internal framework use
};

#define RED_COLOR   [UIColor redColor]
#define TITLE_COLOR [UIColor textGrayColor]
#define FILTER_DOWM_IMAGE [UIImage imageNamed:@"filter_down"]
#define FILTER_UP_IMAGE   [UIImage imageNamed:@"filter_up"]
#define FILTER_SELECTED_IMAGE [UIImage imageNamed:@"filter_selected"]

static void * _Nullable tagForTitleButonKey = &tagForTitleButonKey;

@interface HCFilterMenuButton : UIControl

@property(nullable, nonatomic,readonly,strong) NSString *currentTitle;
@property(nullable, nonatomic,readonly,strong) UIColor  *currentTitleColor;
@property(nullable, nonatomic,readonly,strong) UIImage  *currentImage;

@property(nullable, nonatomic,readonly,strong) UILabel     *titleLabel;
@property(nullable, nonatomic,readonly,strong) UIImageView *imageView;

+ (nullable instancetype)filterButton;

- (void)setTitle:(nullable NSString *)title forState:(HCControlState)state;

- (void)setTitleColor:(nullable UIColor *)color forState:(HCControlState)state;

- (void)setImage:(nullable UIImage *)image forState:(HCControlState)state;


@end
