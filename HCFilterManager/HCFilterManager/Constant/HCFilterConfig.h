//
//  HCFilterConfig.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *fileKeyFromNameDict(NSString *);

// 下拉view的类型
extern HCFilterListType pullDownViewTypeByKey(NSString *);

// 可以填写自定义的数据
extern NSArray *fillingCustomArray();

@interface HCFilterConfig : NSObject



@end


extern NSString *const kNotificationPullDownViewDismissKey;
extern NSString *const kNotificationSelectTitleIndex;
extern NSString *const kNotificationSelectFilterModel;
extern NSString *const kNotificationSelectFilterCodes;
