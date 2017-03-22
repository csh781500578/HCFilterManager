//
//  ViewController.m
//  HCFilterManager
//
//  Created by hanryChen on 2017/3/22.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "ViewController.h"
#import "HCFilterManager+SupportedAPIs.h"

@interface ViewController ()

/** 筛选栏 */
@property(nonatomic, strong) HCFilterManager *filterManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self layoutFilterView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)layoutFilterView {
    // title 
    NSDictionary *zhudict = @{@"住宅":@[@"面积",@"类型",@"排序",@"标签",@"来源",@"装修",@"楼层",@"朝向"]};;
    NSDictionary *bieshu = @{@"别墅":@[@"面积",@"排序",@"标签",@"卧室",@"装修",@"层数",@"花园",@"来源"]};
    NSDictionary *moreDict = @{@"更多":@[zhudict,bieshu]};
    NSDictionary *quyu = @{@"区域":@[@"城区",@"地铁"]};
    NSArray *showTitles =  @[quyu,@"总价",@"户型",moreDict];
    
    self.filterManager.showTitles = showTitles;
}

- (HCFilterManager *)filterManager {
    if (!_filterManager) {
        _filterManager = [HCFilterManager filterManagerWithFrame:(CGRect){0,64,SCREEN_WIDTH,FILTER_VIEW_HEIGHT} superView:self.view];
    }
    return _filterManager;
}

@end
