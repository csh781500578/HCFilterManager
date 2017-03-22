//
//  HCFilterManager.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterManager.h"

@interface HCFilterManager()

/** 显示数据 */
@property(nonatomic, strong) NSMutableArray <HCFilterTitleModel *> *dataSource;

/** 数据源 */
@property(nonatomic, strong) NSDictionary *fileData;

/** 下标 */
@property(nonatomic, assign) NSInteger index;

@end

@implementation HCFilterManager

// 文件路径
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    [self receiveDataSourceFromFilePath:filePath];
}

- (void)setShowTitles:(NSArray *)showTitles {
    _showTitles = showTitles;
    
    self.dataSource = [self layoutDataList:showTitles];
    [self.filterView setContentViewWithList:self.dataSource];
}

- (NSArray *)selectCodes {
    return [self selectCodesFromFilterView];
}

- (NSArray *)selectCodesFromFilterView {
    NSMutableArray *codes = [NSMutableArray arrayWithCapacity:4];
    [self.filterView.selectedCodes enumerateObjectsUsingBlock:^(NSMutableArray *_Nonnull arrays, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrays enumerateObjectsUsingBlock:^(NSString  *_Nonnull code, NSUInteger idx, BOOL * _Nonnull stop) {
            [codes addObject:code];
        }];
    }];
    return codes;
}

// 模型转换
- (NSMutableArray *)layoutDataList:(NSArray *)list {
    NSMutableArray *mutables = [NSMutableArray arrayWithCapacity:4];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutables addObject:[self setTitleModelWithObject:obj]];
    }];
    return mutables;
}

// 字典转模型
- (id)setTitleModelWithObject:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        HCFilterTitleModel *titleModel = [[HCFilterTitleModel alloc] init];
        titleModel.name = [[object allKeys] firstObject];
        id values = [object objectForKey:titleModel.name];
        titleModel.segment = [self setTitleModelWithObject:values];
        return titleModel;
    }else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        [(NSArray *)object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[self setTitleModelWithObject:obj]];
        }];
        return array;
    }else if ([object isKindOfClass:[NSString class]]) {
        HCFilterTitleModel *titleModel = [[HCFilterTitleModel alloc] init];
        titleModel.name = object;
        titleModel.lists = [[[self valueDictionary:self.fileData forKey:object] allValues] firstObject];
        // 如果该分类下可以自定义数据，则插入一条可自定义的model
        if ([fillingCustomArray() containsObject:object]) {
            HCFilterCodeModel *model = [[HCFilterCodeModel alloc] init];
            model.customed = YES;
            titleModel.lists = [titleModel.lists arrayByAddingObject:model];
        }
        return titleModel;
    }
    return @"";
}

//通过关键字key去源数据里面找对应的数据源，数据源一定是字典，遇到数组则可以跳过
- (NSDictionary *)valueDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    //字符串对应的key
    NSString *newKey = fileKeyFromNameDict(key);
    if (!newKey) {
        newKey = key;
    }
    for (NSString *valueKeys in dictionary) {
        id value = [dictionary objectForKey:valueKeys];
        if ([valueKeys isEqualToString:newKey]) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *array = [HCFilterCodeModel hc_objectArrayWithkeyValues:value];
                return @{key:array?:@""};
            }else {
                HCFilterCodeModel *model = [HCFilterCodeModel hc_objectWithkeyValue:value];
                return @{key:model?:@""};
            } 
        }else {
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = [self valueDictionary:value forKey:key];
                if (dictionary) {
                    return dictionary;
                }
            }
        }
    }
    return nil;
}


/**
 遍历有选择的model

 @param selectCodes 选中的codes
 */
- (void)traverseDataSourceWithSelectCodes:(NSArray *)selectCodes {
    if (selectCodes.count < 1) {
        return;
    }
    self.selectCodes = selectCodes;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self traverseAnyTypeOfObject:self.dataSource];
    });
}

- (void)reloadDataAtTitleModel:(HCFilterTitleModel *)titleModel {
    if ([self.dataSource containsObject:titleModel]) {
        self.index = [self.dataSource indexOfObject:titleModel];
    } 
    [self traverseAnyTypeOfObject:titleModel];
}

//遍历数据源
- (BOOL)traverseAnyTypeOfObject:(id)object {
    __block BOOL selected = NO;
    if ([object isKindOfClass:[NSArray class]]) {
        // 遍历数组
        [(NSArray *)object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.dataSource containsObject:obj]) {
                self.index = idx;
            }
            if ([self traverseAnyTypeOfObject:obj]) {
                selected = YES;
            }
        }];
    } else if ([object isKindOfClass:[HCFilterTitleModel class]]) {
        // 遍历外层model
        HCFilterTitleModel *titleModel = (HCFilterTitleModel *)object;
        if (titleModel.segment) {
            if ([self traverseAnyTypeOfObject:titleModel.segment]) {
                selected = YES;
            }
        }
        if (titleModel.lists) {
            if ([self traverseAnyTypeOfObject:titleModel.lists]) {
                selected = YES;
            }
        }
        titleModel.selected = selected;
    } else if ([object isKindOfClass:[HCFilterCodeModel class]]) {
        // 遍历内存model
        HCFilterCodeModel *codeModel = (HCFilterCodeModel *)object;
        if (codeModel.data) {
            codeModel.data.selected = NO;
            if (codeModel.data.block) {
                if ([self traverseAnyTypeOfObject:codeModel.data.block]) {
                    selected = YES;
                }
            }
        }else {
            // 最终结果
            selected = [self.selectCodes containsObject:codeModel.code];
            if (codeModel.isCustomed) {
                for (NSString *code in self.selectCodes) {
                    if ([code containsString:@"-"]) {
                        selected = YES;
                        codeModel.code = code;
                        codeModel.name = [[code substringFromIndex:1] stringByAppendingString:@"万"];
                    }
                }
            }
            if (selected) {
                [self didSelectModel:codeModel];
            }
        }
        codeModel.selected = selected;
    } else {
        NSLog(@"object %@",object);
    }
    return selected;
}

// 上一次点中的model
- (void)didSelectModel:(HCFilterCodeModel *)model {
    [self.filterView setShowTitlesWithModel:model index:self.index];
}

//数据文件路径
- (void)receiveDataSourceFromFilePath:(NSString *)filePath {
    if (!filePath) {
        return;
    }
    self.fileData = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

@end
