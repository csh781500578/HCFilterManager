//
//  HCSegmentedView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSegmentedView : UIView

/** themes */
@property(nonatomic, strong) NSArray *themes;
/** click action **/
@property(nonatomic,copy) void (^selectSegmentedButtonBlock)(NSInteger);

- (instancetype)initWithFrame:(CGRect)frame themes:(NSArray *)themes;
@end
