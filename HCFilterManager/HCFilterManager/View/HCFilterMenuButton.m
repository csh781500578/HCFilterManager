//
//  HCFilterButton.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterMenuButton.h"
#import <objc/runtime.h>

static void * filter_button_title_key = &filter_button_title_key;
static void * filter_button_color_key = &filter_button_color_key;
static void * filter_button_image_key = &filter_button_image_key;

#define TITLE_FONT [UIFont systemFontOfSize:14]

@interface HCFilterMenuButton()

/** title label */
@property(nonatomic, strong) UILabel *titleLabel;

/** image view */
@property(nonatomic, strong) UIImageView *imageView;

/** state */
@property(nonatomic, assign) HCControlState controlState;

@end

@implementation HCFilterMenuButton

+ (instancetype)filterButton {
    HCFilterMenuButton *button = [[HCFilterMenuButton alloc] init];
    button.controlState = HCControlStateNormal;
    return button;
}

//=================================================================
//                           override
//=================================================================
#pragma mark - override
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.text = self.currentTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.leju_width / 2, self.leju_height / 2);
    self.titleLabel.textColor = self.currentTitleColor;
    if (self.titleLabel.leju_width > self.leju_width - 10) {
        [self layoutIfNeeded];
        CGRect frame = self.titleLabel.frame;
        frame.size.width = self.leju_width - 10;
        frame.origin.x = 0;
        self.titleLabel.frame = frame;
    }
    
    self.imageView.image = self.currentImage;
    CGFloat x = CGRectGetMaxX(self.titleLabel.frame);
    self.imageView.frame = (CGRect){(CGPoint){x,self.leju_height / 2 - self.currentImage.size.height / 2},self.currentImage.size};
}

- (void)setTitle:(nullable NSString *)title forState:(HCControlState)state {
    [self setValue:title forState:state title:filter_button_title_key];
    
    [self setNeedsLayout];
}

- (void)setTitleColor:(nullable UIColor *)color forState:(HCControlState)state {
    [self setValue:color forState:state title:filter_button_color_key];
    
    [self setNeedsLayout];
}

- (void)setImage:(nullable UIImage *)image forState:(HCControlState)state {
    [self setValue:image forState:state title:filter_button_image_key];
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.controlState = HCControlStateSelected;
    }else {
        self.controlState = HCControlStateNormal;
    }
    
    [self setNeedsLayout];
}

// set
- (void)setValue:(id)value forState:(HCControlState)state title:(const void *)title {
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, title);
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    [dictionary setValue:value forKey:[@(state) stringValue]];
    NSLog(@"%p",title);
    objc_setAssociatedObject(self, title, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// get
- (id)valueForState:(HCControlState)state title:(const void *)title {
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, title);
    
    id value = [dictionary valueForKey:[@(state) stringValue]];
    if (!value) {
        value = [dictionary valueForKey:[@(HCControlStateNormal) stringValue]];
    }
    
    return value;
}

- (NSString *)currentTitle {
    return [self valueForState:self.controlState title:filter_button_title_key];
}

- (UIColor *)currentTitleColor {
    return [self valueForState:self.controlState title:filter_button_color_key];
}

- (UIImage *)currentImage {
    return [self valueForState:self.controlState title:filter_button_image_key];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = TITLE_FONT;
        _titleLabel.minimumScaleFactor = 0.5;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
