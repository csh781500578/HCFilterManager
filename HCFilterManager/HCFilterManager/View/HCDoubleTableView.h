//
//  HCDoubleTableView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCFilterResultModel.h"
@class HCTableViewCell;

@interface HCDoubleTableView : UIView

/** 双层列表数据 */
@property(nonatomic, strong) HCFilterTitleModel *listModels;

/** 展开哪类数据 */
@property(nonatomic, assign) NSUInteger showIndex;

@end
