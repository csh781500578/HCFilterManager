//
//  NSObject+HCModel.h
//  HCFilterManager
//
//  Created by hanryChen on 2017/3/22.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HCModel)

+ (NSDictionary *)hc_replacedKeyWithProperty;

+ (NSDictionary *)hc_modelWithArrayObject;

+ (instancetype)hc_objectWithkeyValue:(id)object;

+ (NSMutableArray *)hc_objectArrayWithkeyValues:(NSArray *)array;

@end
