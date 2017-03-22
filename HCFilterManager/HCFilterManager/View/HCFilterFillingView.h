//
//  HCFillingView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/20.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCFilterFillingView : UIView

/** from value **/
@property(nonatomic,copy) NSString *fromValue;
/** to value **/
@property(nonatomic,copy) NSString *toValue;

/** 点击回调 */
@property(nonatomic, copy) void (^resultFromValueToValueBlock)(NSString *,NSString *,NSString *unit);

@end
