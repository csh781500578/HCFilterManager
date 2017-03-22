//
//  HCFilterResultModel.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCFilterCodeModel;
@class HCBlockModel;

@interface HCFilterResultModel : NSObject<NSCoding>

/** code array **/
@property(nonatomic,copy) NSArray *codes;

/** model array */
@property(nonatomic, strong) NSMutableArray <HCFilterCodeModel *>* codeModels;

/** serial queue */
@property(class,nonatomic, strong) dispatch_queue_t serialQueue;

/**
 Store the filter model to disk cache
 
 @param model The filter model to store
 @param key The unique filter model cache key, usually it's controller name and type
 */
+ (void)setFilterResultModel:(HCFilterResultModel *)model forKey:(NSString *)key;


/**
 Get filter model from disk cache
 
 @param key The unique key used to store the filter model
 @return The filter model
 */
+ (HCFilterResultModel *)filterResultModelForKey:(NSString *)key;
@end

@interface HCFilterTitleModel : NSObject

/** name **/
@property(nonatomic,copy) NSString *name;

/** select */
@property(nonatomic, assign, getter=isSelected) BOOL selected;

/** selected title **/
@property(nonatomic,copy) NSString *title;

/** segment **/
@property(nonatomic,copy) NSArray <HCFilterTitleModel *>*segment;

/** filter models */
@property(nonatomic, copy) NSArray <HCFilterCodeModel *>* lists;
@end


@interface HCFilterCodeModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
/** is custom */
@property(nonatomic, assign, getter=isCustomed) BOOL customed;
@property (strong, nonatomic) NSString *baiduX;
@property (strong, nonatomic) NSString *baiduY;
@property (strong, nonatomic) HCFilterCodeModel *data;
/** if has block */
@property(nonatomic, strong) NSArray <HCFilterCodeModel *>*block;
@property (nonatomic, getter=isSelected) BOOL selected;
@end
 
