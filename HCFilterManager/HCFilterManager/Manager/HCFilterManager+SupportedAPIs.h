//
//  HCFilterManager+SupportedAPIs.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/22.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterManager.h"

@interface HCFilterManager (SupportedAPIs)

/** code **/
@property(nonatomic,copy) NSArray *codes; 

// 创建筛选菜单
+ (instancetype)filterManagerWithFrame:(CGRect)frame superView:(UIView *)view;

@end
