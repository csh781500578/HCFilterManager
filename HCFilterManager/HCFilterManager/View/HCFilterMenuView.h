//
//  HCFilterMenuView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCFilterResultModel.h"

@interface HCFilterMenuView : UIView

/** titles */
@property(nonatomic, copy) NSArray <HCFilterTitleModel *>*titles;

/** click action **/
@property(nonatomic,copy) void (^selectClickTitleButtonBlock)(NSInteger,BOOL);

- (void)cancelSelected;

@end
