//
//  HCPullDownView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCFilterResultModel.h"

static inline NSArray  * titlesFromList(NSArray *list) {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:2];
    for (id value in list) {
        if ([value isKindOfClass:[NSString class]]) {
            [titles addObject:value];
        }else if ([value isKindOfClass:[NSDictionary class]]) {
            [titles addObjectsFromArray:[value allKeys]];
        }else if ([value isKindOfClass:[HCFilterCodeModel class]]) {
            [titles addObject:((HCFilterCodeModel *)value).name];
        }
    }
    return titles;
}

static inline NSArray  * titlesFromSegmentList(NSArray *list) {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:2];
    for (id value in list) {
        if ([value isKindOfClass:[NSString class]]) {
            [titles addObject:value];
        }else if ([value isKindOfClass:[NSDictionary class]]) {
            [titles addObjectsFromArray:[value allKeys]];
        }
    }
    return titles;
}

static inline NSMutableArray *titlesFromTitleModels(NSArray *titleModels) {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:4];
    [titleModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HCFilterTitleModel class]]) {
            [titles addObject:((HCFilterTitleModel *)obj).name];
        }else {
            [titles addObject:obj];
        }
    }];
    return titles;
}


@interface HCPullDownView : UIView

/** <#注释#> */
@property(nonatomic, strong) HCFilterTitleModel *titleModel;

/** <#name#> */
@property(nonatomic, assign) CGFloat view_height;

/** 展开哪类数据 */
@property(nonatomic, assign) NSUInteger showIndex;

@end
