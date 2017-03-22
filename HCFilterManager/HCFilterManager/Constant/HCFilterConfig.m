//
//  HCFilterConfig.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterConfig.h"

static NSDictionary *keyValueDict(){
    return @{
             @"城区":@"distinct_block_option",
             @"地铁":@"subway_data",
             @"总价":@"html_price",
             @"方式":@"html_renttype",
             @"户型":@"html_room",
             @"类型":@"html_pptype",
             @"面积":@"html_area",
             @"排序":@"html_sale_orderby",
             @"租金":@"html_rentprice",
             @"均价":@"html_averprice",
             @"房龄":@"html_completedate",
             @"分类":@"business_estate",
             @"来源":@"source_from",
             @"级别":@"office_level",
             @"标签":@"html_tags",
             @"朝向":@"html_fix",
             @"卧室":@"bieshu_room",
             @"层数":@"bieshu_totalfloor",
             @"装修":@"html_fitment",
             @"花园":@"bieshu_garage",
             @"楼层":@"html_floor",
             @"租金排序":@"xq_rent_orderby",
             @"总价排序":@"xq_sale_orderby",
             @"面积排序":@"html_area_orderby",
             
             };
}

HCFilterListType pullDownViewTypeByKey(NSString *key) {
    NSDictionary *valueKeys = @{
                                @"区域":[@(HCFilterListTypeDouble) stringValue],
                                @"均价":[@(HCFilterListTypeSingle) stringValue],
                                @"户型":[@(HCFilterListTypeSingle) stringValue],
                                @"面积":[@(HCFilterListTypeSingle) stringValue],
                                @"房龄":[@(HCFilterListTypeSingle) stringValue],
                                @"总价":[@(HCFilterListTypeSingle) stringValue],
                                @"租金":[@(HCFilterListTypeSingle) stringValue],
                                @"方式":[@(HCFilterListTypeSingle) stringValue],
                                @"分类":[@(HCFilterListTypeSingle) stringValue],
                                @"均价排序":[@(HCFilterListTypeNone) stringValue],
                                @"总价排序":[@(HCFilterListTypeNone) stringValue],
                                @"租金排序":[@(HCFilterListTypeNone) stringValue],
                                @"面积排序":[@(HCFilterListTypeNone) stringValue],
                                @"更多":[@(HCFilterListTypeMore) stringValue],
                                };
    NSString *value = [valueKeys objectForKey:key];
    
    return (HCFilterListType)[value integerValue];
}

NSArray *fillingCustomArray(){
    return @[@"总价"];
}

NSString *fileKeyFromNameDict(NSString *key) {
    return [keyValueDict() objectForKey:key];
}

@implementation HCFilterConfig


@end


NSString *const kNotificationPullDownViewDismissKey = @"kNotificationPullDownViewDismissKey";
NSString *const kNotificationSelectTitleIndex       = @"kNotificationSelectTitleIndex";
NSString *const kNotificationSelectFilterModel      = @"kNotificationSelectFilterModel";
NSString *const kNotificationSelectFilterCodes      = @"kNotificationSelectFilterCodes";
