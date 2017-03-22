//
//  HCFilterManager+SupportedAPIs.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/22.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterManager+SupportedAPIs.h"
#import "HCFilterMenuView.h"

static void * selectedCodesAddressKey = &selectedCodesAddressKey;

@implementation HCFilterManager (SupportedAPIs)
@dynamic codes;

- (void)setSelectCodes:(NSArray *)selectCodes {
    [self traverseDataSourceWithSelectCodes:selectCodes];
}

+ (instancetype)filterManagerWithFrame:(CGRect)frame superView:(UIView *)view {
    HCFilterManager *filterManager = [[HCFilterManager alloc] init];
    
    HCFilterContentView *contentView = [[HCFilterContentView alloc] initWithFrame:frame];
    [view addSubview:contentView];
    filterManager.filterView = contentView;
    filterManager.filePath = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
    
    WEAK_SELF(__weakManager, filterManager);
    [filterManager.filterView setDidSelectCodesAtTitleModel:^(HCFilterTitleModel *titleModel) {
        [__weakManager reloadDataAtTitleModel:titleModel];
    }];
    
    return filterManager;
}


@end
