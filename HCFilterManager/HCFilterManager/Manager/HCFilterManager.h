//
//  HCFilterManager.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/10.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HCFilterManager : NSObject

/** 筛选栏 */
@property(nonatomic, strong) HCFilterContentView *filterView;

/** select codes */
@property(nonatomic, strong) NSArray *selectCodes;

/** show titles */
@property(nonatomic, strong) NSArray *showTitles;

/** 文件路径 **/
@property(nonatomic,copy) NSString *filePath;

/** 在这里修改数据源 */
- (void)receiveDataSourceFromFilePath:(NSString *)filePath;

//遍历数据源
- (void)traverseDataSourceWithSelectCodes:(NSArray *)selectCodes;

// 刷新数据
- (void)reloadDataAtTitleModel:(HCFilterTitleModel *)titleModel;
@end
