//
//  HCSingleCollectionView.h
//  SimpleProject
//
//  Created by hanryChen on 2017/3/17.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCFilterResultModel.h"
@class HCCollectionViewCell;
@class HCMoreCollectionViewHeader;
@class HCCollectionCommitView;

#define FILLING_VIEW_HEIGHT 49
#define COLLECTION_VIEW_CELL_HEIGHT 30
#define COLLECTION_COMMIT_VIEW_HEIGHT 57

typedef NS_ENUM(NSUInteger, HCCollectionType) {
    HCCollectionTypeNone = 0,
    HCCollectionTypeCustom,
    HCCollectionTypeMore
};

@interface HCFilterCollectionView : UIView

/** collection view的内容 */
@property(nonatomic, assign) HCCollectionType type;
/** 数据 */
@property(nonatomic, strong) NSArray *modelList;

/** showIndex */
@property(nonatomic, assign) NSInteger showIndex;
 
@end
