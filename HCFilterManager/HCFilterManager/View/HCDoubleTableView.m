//
//  HCDoubleTableView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/13.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCDoubleTableView.h"

#define TABLE_VIEW_ROW_HEIGHT 40

@interface HCTableViewCell : UITableViewCell

/** 数据 */
@property(nonatomic, strong) HCFilterCodeModel *model;

@end

@implementation HCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setModel:(HCFilterCodeModel *)model {
    _model = model;
    self.textLabel.text = model.name;
    if (model.selected) {
        self.textLabel.textColor = [UIColor colorWithHexString:@"#F43940"];;
    }else {
        self.textLabel.textColor = [UIColor colorWithHexString:@"#535353"];;
    }
}

@end

@interface HCDoubleTableView()<UITableViewDelegate,UITableViewDataSource>

/** 第一列 */
@property(nonatomic, strong) UITableView *firstTableView;
/** 第二列 */
@property(nonatomic, strong) UITableView *secondTableView;

/** 第一列数据 */
@property(nonatomic, strong) NSArray *firstDataSource;
/** 第二列数据 */
@property(nonatomic, strong) HCFilterCodeModel *codeModel;

@end

@implementation HCDoubleTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.firstTableView];
        [self addSubview:self.secondTableView];
    }
    return self;
}

- (void)setListModels:(HCFilterTitleModel *)listModels {
    _listModels = listModels;
    HCFilterCodeModel *selectModel;
    for (HCFilterCodeModel *model in listModels.lists) {
        //选择的
        if (model.selected) {
            selectModel = model;
            break;
        }
        //默认展示的
        if (!selectModel && model.data.block.count > 0) {
            selectModel = model;
        }
    }
    if (selectModel) {
        selectModel.selected = YES;
        self.codeModel = selectModel;
    }
    self.firstDataSource = listModels.lists;
    
    [self.firstTableView reloadData];
    [self.secondTableView reloadData];
}

// tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return self.firstDataSource.count;
    }
    return self.codeModel.data.block.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCTableViewCell class]) forIndexPath:indexPath];
    if (tableView == self.firstTableView) {
        HCFilterCodeModel *model = [self.firstDataSource objectAtIndex:indexPath.row];
        cell.model = model;
        if (model.selected) {
            cell.backgroundColor = [UIColor whiteColor];
        }else {
            cell.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
        }
    }else if (tableView == self.secondTableView) {
        HCFilterCodeModel *model = [self.codeModel.data.block objectAtIndex:indexPath.row];
        cell.model = model;
        cell.backgroundColor = [UIColor whiteColor]; 
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self deselectFilterModelAtTableView:tableView];
    if (tableView == self.firstTableView) {
        HCFilterCodeModel *model = [self.firstDataSource objectAtIndex:indexPath.row];
        model.selected = YES;
        self.codeModel = model;
        
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
        if (!model.data.block) {
            [self didSelectFilterModel:model];
        }
    }else {
        HCFilterCodeModel *model = [self.codeModel.data.block objectAtIndex:indexPath.row];
        model.selected = YES;
        [self.secondTableView reloadData];
        [self didSelectFilterModel:model];
    }
}

- (void)deselectFilterModelAtTableView:(UITableView *)tableView {
    if (tableView == self.firstTableView) {
        [self.firstDataSource enumerateObjectsUsingBlock:^(HCFilterCodeModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.selected = NO;
        }];
    }else if (tableView == self.secondTableView) {
        [self.firstDataSource enumerateObjectsUsingBlock:^(HCFilterCodeModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.selected = NO;
            if (model.block) {
                [model.block enumerateObjectsUsingBlock:^(HCFilterCodeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                    model.selected = YES;
                }];
            }
        }];
    }
}

- (void)didSelectFilterModel:(HCFilterCodeModel *)model {
    NSArray *codes = @[model.code];
    if (!model.code || model.code.length == 0) {
        codes = @[self.codeModel.data.code];
        model = self.codeModel;
    } else {
        codes = @[model.code,self.codeModel.code];
    }
    NSMutableDictionary *object = [@{
                                     kNotificationSelectTitleIndex : @(self.showIndex),
                                     } mutableCopy];
    if (model.code && model.code.length > 0) {
        [object addEntriesFromDictionary:@{kNotificationSelectFilterModel : model,
                                           kNotificationSelectFilterCodes : codes}];
    }else {
        model.selected = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPullDownViewDismissKey object:object];
}

- (UITableView *)firstTableView {
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH / 2,self.leju_height} style:UITableViewStylePlain];
        _firstTableView.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
        [self layoutTableView:_firstTableView];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView {
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:(CGRect){SCREEN_WIDTH / 2,0,SCREEN_WIDTH / 2,self.leju_height} style:UITableViewStylePlain];
        [self layoutTableView:_secondTableView];
    }
    return _secondTableView;
}

- (void)layoutTableView:(UITableView *)tableView {
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.sectionHeaderHeight = 0.1;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = TABLE_VIEW_ROW_HEIGHT;
    [tableView registerClass:[HCTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HCTableViewCell class])]; 
}
@end
