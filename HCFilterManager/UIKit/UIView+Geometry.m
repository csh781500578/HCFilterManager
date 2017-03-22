//
//  UIView+Geometry.m
//  PPYToolkit
//
//  Created by leju on 14-6-30.
//  Copyright (c) 2014年 leju Inc. All rights reserved.
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)
@dynamic leju_x, leju_y, leju_left, leju_right, leju_top, leju_bottom, leju_origin, leju_size, leju_width, leju_height, leju_centerX, leju_centerY;

- (CGFloat)leju_x
{
    return self.frame.origin.x;
}

- (void)setLeju_x:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)leju_y
{
    return self.frame.origin.y;
}

- (void)setLeju_y:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)leju_left
{
    return self.frame.origin.x;
}

- (void)setLeju_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)leju_top {
    return self.frame.origin.y;
}

- (void)setLeju_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)leju_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLeju_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)leju_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeju_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)leju_centerX
{
    return self.center.x;
}

- (void)setLeju_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)leju_centerY
{
    return self.center.y;
}

- (void)setLeju_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)leju_width
{
    return self.frame.size.width;
}

- (void)setLeju_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)leju_height
{
    return self.frame.size.height;
}

- (void)setLeju_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)leju_origin
{
    return self.frame.origin;
}

- (void)setLeju_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)leju_size
{
    return self.frame.size;
}

- (void)setLeju_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end