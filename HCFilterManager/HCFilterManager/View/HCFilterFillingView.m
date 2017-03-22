//
//  HCFillingView.m
//  SimpleProject
//
//  Created by hanryChen on 2017/3/20.
//  Copyright © 2017年 hanryChen. All rights reserved.
//

#import "HCFilterFillingView.h"

#define TEXT_FIELD_HEIGHT 30
#define SEPARATE_VIEW_WIDTH 8
#define SEPARATE_VIEW_HEIGHT 1
#define BUTTON_WIDTH 90
#define BUTTON_HEIGHT 30

#define TITLE_LABEL_ORIGIN 15
#define SEPARATE_VIEW_LEADING 3
#define UNIT_LABEL_LEADING 8

#define TEXT_FIELD_CORNER_RADIUS 2.0

#define TITLE_LABEL_TEXT @"自定义价格"
#define UNIT_LABEL_TEXT @"万"
#define COMMIT_BUTTON_TEXT @"确定"

@interface HCFilterFillingView()

/** 标题 */
@property(nonatomic, strong) UILabel *titleLabel;
/** 下限 */
@property(nonatomic, strong) UITextField *fromTextField;
/** 分隔view */
@property(nonatomic, strong) UIView *separateView;
/** 上限 */
@property(nonatomic, strong) UITextField *toTextField;
/** 单位 */
@property(nonatomic, strong) UILabel *unitLabel;
/** 确定 */
@property(nonatomic, strong) UIButton *commitButton;

@end

@implementation HCFilterFillingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = TITLE_LABEL_TEXT_COLOR;
            label.font = UIFont(11);
            label.text = TITLE_LABEL_TEXT;
            label;
        });
        
        _fromTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
            textField.font = UIFont(12);
            textField.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS;
            textField.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR;
            textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
            textField.leftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,10}];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            textField;
        });
        _separateView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = SEPARATE_VIEW_BACKGROUND_COLOR;
            
            view;
        });
        
        _toTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
            textField.font = UIFont(12);
            textField.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR;
            textField.layer.cornerRadius = TEXT_FIELD_CORNER_RADIUS;
            textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
            textField.leftView = [[UIView alloc] initWithFrame:(CGRect){0,0,10,10}];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            textField;
        });
        _unitLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = UNIT_LABEL_TEXT;
            label.textColor = TITLE_LABEL_TEXT_COLOR;
            label.font = UIFont(11);
            
            label;
        });
        _commitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:COMMIT_BUTTON_TEXT forState:UIControlStateNormal];
            [button setBackgroundColor:UENABLE_BUTTON_BACKGROUND_COLOR];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = UIFont(15);
            [button addTarget:self action:@selector(fillingResult) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = NO;
            
            button;
        });
        
        [self addSubview:_titleLabel];
        [self addSubview:_fromTextField];
        [self addSubview:_separateView];
        [self addSubview:_toTextField];
        [self addSubview:_unitLabel];
        [self addSubview:_commitButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat centerY = frame.size.height / 2;
    
    self.titleLabel.frame = (CGRect){TITLE_LABEL_ORIGIN,0,50,15};
    [self.titleLabel sizeToFit];
    self.titleLabel.leju_centerY = centerY;
    
    CGFloat textField_width = SCREEN_WIDTH - (TITLE_LABEL_ORIGIN * 3 + CGRectGetWidth(_titleLabel.frame) + SEPARATE_VIEW_LEADING * 2 + SEPARATE_VIEW_WIDTH + UNIT_LABEL_LEADING * 2 + BUTTON_WIDTH + 12);
    
    self.fromTextField.frame = (CGRect){CGRectGetMaxX(_titleLabel.frame) + TITLE_LABEL_ORIGIN,centerY - TEXT_FIELD_HEIGHT / 2,textField_width / 2,TEXT_FIELD_HEIGHT};
    self.separateView.frame = (CGRect){CGRectGetMaxX(_fromTextField.frame) + SEPARATE_VIEW_LEADING, centerY - SEPARATE_VIEW_HEIGHT / 2, SEPARATE_VIEW_WIDTH, SEPARATE_VIEW_HEIGHT};
    self.toTextField.frame = (CGRect){CGRectGetMaxX(_separateView.frame) + SEPARATE_VIEW_LEADING,centerY - TEXT_FIELD_HEIGHT / 2,textField_width / 2,TEXT_FIELD_HEIGHT};
    self.unitLabel.frame = (CGRect){CGRectGetMaxX(_toTextField.frame) + UNIT_LABEL_LEADING, 0, 10, 10};
    self.unitLabel.leju_centerY = centerY;
    [self.unitLabel sizeToFit];
    self.commitButton.frame = (CGRect){CGRectGetMaxX(_unitLabel.frame) + UNIT_LABEL_LEADING,centerY - BUTTON_HEIGHT / 2, BUTTON_WIDTH, BUTTON_HEIGHT};
    [self layoutIfNeeded];
}

- (void)setFromValue:(NSString *)fromValue {
    _fromValue = fromValue;
    self.fromTextField.text = fromValue;
}

- (void)setToValue:(NSString *)toValue {
    _toValue = toValue;
    self.toTextField.text = toValue;
}

- (void)fillingResult {
    [self endEditing:YES];
    if (self.resultFromValueToValueBlock) {
        self.resultFromValueToValueBlock(self.fromTextField.text,self.toTextField.text,UNIT_LABEL_TEXT);
    }
}

- (void)textFieldDidChange:(NSNotification *)notification {
    if (self.fromTextField.text.length > 8) {
        self.fromTextField.text = [self.fromTextField.text substringToIndex:8];
    }
    if (self.toTextField.text.length > 8) {
        self.toTextField.text = [self.toTextField.text substringToIndex:8];
    }
    if ([self.toTextField.text integerValue] > [self.fromTextField.text integerValue]) {
        self.commitButton.userInteractionEnabled = YES;
        self.commitButton.backgroundColor = ENABLE_BUTTON_BACKGROUND_COLOR;
    }else {
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = UENABLE_BUTTON_BACKGROUND_COLOR;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
