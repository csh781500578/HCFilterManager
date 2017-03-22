//
//  HCFillingView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/20.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCFilterFillingView : UIView

/** 点击回调 */
@property(nonatomic, copy) void (^resultFromValueToValueBlock)(NSString *,NSString *,NSString *unit);

@end
