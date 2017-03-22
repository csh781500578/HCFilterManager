//
//  NSObject+HCModel.m
//  HCFilterManager
//
//  Created by hanryChen on 2017/3/22.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "NSObject+HCModel.h"
#import <objc/runtime.h>

@implementation NSObject (HCModel)

+ (NSDictionary *)hc_replacedKeyWithProperty {
    return @{};
}

+ (NSDictionary *)hc_modelWithArrayObject {
    return @{};
}

+ (NSMutableArray *)hc_objectArrayWithkeyValues:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *diction in array) {
        if ([diction isKindOfClass:[NSArray class]]){
            [modelArray addObject:[self hc_objectWithkeyValue:diction]];
        } else {
            id model = [self hc_objectWithkeyValue:diction];
            if (model) {
                [modelArray addObject:model];
            }
        }
    }
    
    return modelArray;
}

+ (instancetype)hc_objectWithkeyValue:(id)object {
    id model = [[self alloc] init];
    if (!object) {
        return model;
    }
    uint count = 0;
    Ivar *ivar = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i ++) {
        Ivar iva = ivar[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(iva)];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(iva)];
        name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        name = [name stringByReplacingOccurrencesOfString:@"@" withString:@""];
        name = [name substringFromIndex:1];
        type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        NSString *key = [name copy];
        id value = object[key];
        if (!value) {
            if ([[self hc_replacedKeyWithProperty].allKeys containsObject:key]) {
                key = [[self hc_replacedKeyWithProperty] objectForKey:key];
                value = object[key];
            }
        }
        if ([value isKindOfClass:[NSDictionary class]] && ![type hasPrefix:@"NS"]) {
            Class subClass = NSClassFromString(type);
            
            value = [subClass hc_objectWithkeyValue:value];
        }else if ([value isKindOfClass:[NSArray class]]) {
            if ([[[self hc_modelWithArrayObject] allKeys] containsObject:name]) {
                
                NSMutableArray *array = [NSMutableArray new];
                for (id subValue in value) {
                    Class subClass = NSClassFromString([[self hc_modelWithArrayObject] objectForKey:name]);
                    id subObject = [subClass hc_objectWithkeyValue:subValue];
                    [array addObject:subObject];
                }
                value = array.copy;
            }
        }else if (value) {
            value = [NSString stringWithFormat:@"%@",value];
        }else {
            continue;
        }
        //KVC 相对setter/getter方法性能会低一些 直接访问ivar性能最高
        //直接访问ivar > setter/getter > KVC
        [model setValue:value forKey:name];
    }
    free(ivar);
    return model;
}


@end
