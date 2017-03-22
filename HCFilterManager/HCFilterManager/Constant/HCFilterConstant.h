//
//  HCFilterConstant.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#ifndef HCFilterConstant_h
#define HCFilterConstant_h

#define FILTER_VIEW_HEIGHT         44
#define LINE_VIEW_HEIGHT           0.5
#define COLLECTION_VIEW_LEADING    10
#define SUB_VIEW_LEADING           15
#define WEAK_SELF(__npointer , __pointer) __weak __typeof(__pointer)__npointer = __pointer;
#define UIFont(__size) [UIFont systemFontOfSize:__size]

#define TITLE_LABEL_TEXT_COLOR [UIColor colorWithRGB:0x878787]
#define TEXT_FIELD_BACKGROUND_COLOR [UIColor colorWithRGB:0xEFEFEF]
#define SEPARATE_VIEW_BACKGROUND_COLOR [UIColor colorWithRGB:0x535353]
#define UENABLE_BUTTON_BACKGROUND_COLOR [UIColor colorWithRGB:0xCCCCCC]
#define ENABLE_BUTTON_BACKGROUND_COLOR [UIColor redColor]
#define LAYER_BORDER_COLOR [UIColor colorWithRGB:0xD5D5D5]
#define COLLECTION_HEADER_BACKGROUND_COLOR [UIColor colorWithRGB:0xF5F5F5]


typedef NS_ENUM(NSUInteger, HCFilterSelectType) {
    HCFilterSelectTypeSingle,   //单选
    HCFilterSelectTypeMultiple, //多选
    HCFilterSelectTypeFirst,    //默认选中第一个
};

typedef NS_ENUM(NSUInteger, HCFilterListType) {
    HCFilterListTypeNone,    //没有(排序)
    HCFilterListTypeSingle,  //单列
    HCFilterListTypeDouble,  //双列
    HCFilterListTypeMultiple,//多列
    HCFilterListTypeMore     //更多
};
 


#endif /* HCFilterConstant_h */
