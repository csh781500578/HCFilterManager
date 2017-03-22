//
//  HCFilterContentView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCFilterManager;

@interface HCFilterContentView : UIView

/** selected codes **/
@property(nonatomic,strong) NSMutableArray *selectedCodes;

/** dataList **/
@property(nonatomic,copy,readonly) NSArray *dataList;

/** did select code **/
@property(nonatomic,copy) void (^didSelectCodesAtTitleModel)(HCFilterTitleModel *);

// 列表数据生成下拉view
- (void)setContentViewWithList:(NSArray <HCFilterTitleModel *> *)list;

- (void)setShowTitlesWithModel:(HCFilterCodeModel *)model index:(NSInteger)index;

@end
