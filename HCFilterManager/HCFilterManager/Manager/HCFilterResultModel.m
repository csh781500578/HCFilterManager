//
//  HCFilterResultModel.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterResultModel.h"
#import <objc/runtime.h>

static void * dickCacheQueueKey = &dickCacheQueueKey;

static inline void initWithCoder(NSCoder *coder,id instance) {
    unsigned int count;
    Ivar *ivarArray = class_copyIvarList([instance class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarArray[i];
        const char *nameChar = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:nameChar];
        id value = [coder decodeObjectForKey:name];
        [instance setValue:value forKey:name];
    }
    free(ivarArray);
}

static inline void encodeWithCoder(NSCoder *coder,id instance) {
    unsigned int count;
    Ivar *ivarArray = class_copyIvarList([instance class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar ivar = ivarArray[i];
        const char *nameChar = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:nameChar];
        id value = [instance valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
    free(ivarArray);
}

@implementation HCFilterResultModel
@dynamic serialQueue;

+ (void)load {
    [super load];
}

+ (void)initialize {
    [super initialize];
    self.serialQueue = dispatch_queue_create("com.githup.hanryChen", DISPATCH_QUEUE_SERIAL);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        initWithCoder(aDecoder,self);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    encodeWithCoder(aCoder, self); 
}

+ (void)setFilterResultModel:(HCFilterResultModel *)model forKey:(NSString *)key {
    dispatch_async(self.serialQueue, ^{
        
        NSMutableDictionary *filterDic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        if (!filterDic) {
            filterDic = [[NSMutableDictionary alloc] init];
        }
        
        [filterDic setValue:model forKey:key];
        BOOL success = [NSKeyedArchiver archiveRootObject:filterDic toFile:[self filePath]];
        
        if (success) {
            NSLog(@"保存成功");
        }
    });
}

+ (HCFilterResultModel *)filterResultModelForKey:(NSString *)key {
    NSMutableDictionary *filterDic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    if (!filterDic) {
        filterDic = [[NSMutableDictionary alloc] init];
    }
    
    HCFilterResultModel *model = [filterDic valueForKey:key];
    return model;
}

+ (NSString *)filePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"esf_list_filter"];
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"filter_result.data"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentPath]) {
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;

}

+ (void)setSerialQueue:(dispatch_queue_t)serialQueue {
    return objc_setAssociatedObject(self, dickCacheQueueKey, serialQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (dispatch_queue_t)serialQueue {
    return objc_getAssociatedObject(self, dickCacheQueueKey);
}

@end

@implementation HCFilterTitleModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        initWithCoder(aDecoder,self);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    encodeWithCoder(aCoder, self);
}

@end

@implementation HCFilterCodeModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        initWithCoder(aDecoder,self);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    encodeWithCoder(aCoder, self);
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"baiduX" : @"baidu_x",
             @"baiduY" : @"baidu_y",
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    static NSDictionary *config;
    if (!config) {
        config = @{
                   @"data" :@"HCBlockModel",
                   @"block":@"HCFilterCodeModel"
                   };
    }
    return config;
}

- (NSString *)code {
    if (!_code) {
        _code = self.data.code;
    }
    return _code;
}

@end 
