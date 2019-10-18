//
//  CalculatorView.m
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/17.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "CalculatorView.h"

@interface CalculatorView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *firstBgView;
@property (nonatomic, strong) UIImageView *firstIconView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UITextField *firstTf;
@property (nonatomic, strong) UILabel *firstNoLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *secondBgView;
@property (nonatomic, strong) UIImageView *secondIconView;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UITextField *secondTf;
@property (nonatomic, strong) UILabel *secondNoLabel;

@property (nonatomic, assign) BOOL inputValueIsFirst;

@property (nonatomic, copy) NSArray <ExchangeRate *>*rateArr;

@end

@implementation CalculatorView


#pragma mark - life cycle
- (instancetype)init {
    return [self initWithRateArr:nil];
}

- (instancetype)initWithRateArr:(NSArray<ExchangeRate *> *)rateArr {
    if (self = [super init]) {
        
        self.inputValueIsFirst = YES;
        self.rateArr = rateArr;
        
        [self addSubview:self.firstBgView = makeBgView()];
        [self addSubview:self.firstIconView = makeImageView()];
        [self addSubview:self.firstButton = makeButton()];
        [self addSubview:self.firstTf = makeTextField()];
        [self addSubview:self.firstNoLabel = makeLabel()];
        self.firstIconView.image = IMAGE(@"flag_cny");
        [self.firstButton setAttributedTitle:makeBtnAttriText(@"人民币") forState:UIControlStateNormal];
        self.firstTf.placeholder = @"100";
        self.firstNoLabel.text = @"CNY";
        
        [self addSubview:self.secondBgView = makeBgView()];
        [self addSubview:self.secondIconView = makeImageView()];
        [self addSubview:self.secondButton = makeButton()];
        [self addSubview:self.secondTf = makeTextField()];
        [self addSubview:self.secondNoLabel = makeLabel()];
        self.secondIconView.image = IMAGE(@"flag_usd");
        [self.secondButton setAttributedTitle:makeBtnAttriText(@"美元") forState:UIControlStateNormal];
        self.secondNoLabel.text = @"USD";

        [self.firstButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.firstTf addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.secondTf addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        self.firstTf.delegate = self;
        self.secondTf.delegate = self;
        
        [self calculateHuiLv];
    }
    return self;
}

#pragma mark - event response
- (void)buttonAction:(UIButton *)button {

    // 点击的是哪个button
    BOOL isFirstBtn = button == self.firstButton;
    
    if (self.firstTf.hasText || self.secondTf.hasText) {
        self.inputValueIsFirst = isFirstBtn;
    } else {
        self.inputValueIsFirst = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *currencyName = [self textWithBtn:button];
    if ([self.delegate respondsToSelector:@selector(calculatorView:currencyName:selecedCurrencyCompletion:)]) {

        [self.delegate calculatorView:self currencyName:currencyName selecedCurrencyCompletion:^(NSString * _Nonnull newCName, NSString * _Nonnull cPicName) {
                    
            NSArray *texts = [newCName componentsSeparatedByString:@" "];
            [button setAttributedTitle:makeBtnAttriText(texts.firstObject) forState:UIControlStateNormal];
    
            if (isFirstBtn) {
                weakSelf.firstNoLabel.text = texts.lastObject;
                weakSelf.firstIconView.image = IMAGE(cPicName);
            } else {
                weakSelf.secondNoLabel.text = texts.lastObject;
                weakSelf.secondIconView.image = IMAGE(cPicName);
            }
    
            [weakSelf calculateHuiLv];
        }];
    }
}

- (void)tfEditingChanged:(UITextField *)tf {
    
    self.inputValueIsFirst = tf == self.firstTf;
    [self calculateHuiLv];
}


#pragma mark - private methods
// 汇率计算
- (void)calculateHuiLv {
    //
    if (self.inputValueIsFirst) {
       
        NSString *valueStr = nil;
        BOOL hasText = self.firstTf.hasText;
        
        // 1. 1 && 2 == RMB
        if (self.firstIsRMB && self.secondIsRMB) {

            if (hasText) {
                self.secondTf.text = self.firstTf.text;
            } else {
                self.secondTf.text = nil;
                self.secondTf.placeholder = self.firstTf.placeholder;
            }

        // 2. 1 == RMB && 2 != RMB
        } else if (self.firstIsRMB && !self.secondIsRMB) {
            
            valueStr = [NSString stringWithFormat:@"%0.2f", self.firstValue / self.secondHuiLv];
            if (hasText) {
                self.secondTf.text = valueStr;
            } else {
                self.secondTf.text = nil;
                self.secondTf.placeholder = valueStr;
            }
        
        // 3. 1 != RMB && 2 == RMB
        } else if (!self.firstIsRMB && self.secondIsRMB) {
            
            valueStr = [NSString stringWithFormat:@"%0.2f", self.firstValue * self.firstHuiLv];
            if (hasText) {
                self.secondTf.text = valueStr;
            } else {
                self.secondTf.text = nil;
                self.secondTf.placeholder = valueStr;
            }
            
        // 4. 1 != RMB && 2 != RMB
        } else if (!self.firstIsRMB && !self.secondIsRMB) {
            
            valueStr = [NSString stringWithFormat:@"%0.2f", self.firstValue * self.firstHuiLv / self.secondHuiLv];
            if (hasText) {
                self.secondTf.text = valueStr;
            } else {
                self.secondTf.text = nil;
                self.secondTf.placeholder = valueStr;
            }
        }

    } else {
        
        NSString *valueStr = nil;
        BOOL hasText = self.secondTf.hasText;
        
        // 1. 1 && 2 == RMB
        if (self.secondIsRMB && self.firstIsRMB) {

            if (hasText) {
                self.firstTf.text = self.secondTf.text;
            } else {
                self.firstTf.text = nil;
                self.firstTf.placeholder = self.secondTf.placeholder;
            }

        // 2. 2 == RMB && 1 != RMB
        } else if (self.secondIsRMB && !self.firstIsRMB) {
            
            valueStr = [NSString stringWithFormat:@"%0.2f", self.secondValue / self.firstHuiLv];
            if (hasText) {
                self.firstTf.text = valueStr;
            } else {
                self.firstTf.text = nil;
                self.firstTf.placeholder = valueStr;
            }
          
        // 3. 2 != RMB && 1 == RMB
        } else if (!self.secondIsRMB && self.firstIsRMB) {
            
            valueStr = [NSString stringWithFormat:@"%0.2f", self.secondValue * self.secondHuiLv];
            if (hasText) {
                self.firstTf.text = valueStr;
            } else {
                self.firstTf.text = nil;
                self.firstTf.placeholder = valueStr;
            }
            
        // 4. 2 != RMB && 1 != RMB
        } else if (!self.firstIsRMB && !self.secondIsRMB) {
                
            valueStr = [NSString stringWithFormat:@"%0.2f", self.secondValue * self.secondHuiLv / self.firstHuiLv];
            if (hasText) {
                self.firstTf.text = valueStr;
            } else {
                self.firstTf.text = nil;
                self.firstTf.placeholder = valueStr;
            }
        }
    }
}

- (NSString *)textWithBtn:(UIButton *)btn {
    NSAttributedString *att = btn.currentAttributedTitle;
    NSMutableAttributedString *resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:att];
              
    //枚举出所有的附件字符串
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // key-NSAttachment
        // NSTextAttachment value类型
        NSTextAttachment * textAtt = attrs[@"NSAttachment"];//从字典中取得那一个图片
        if (textAtt) {
            [resutlAtt replaceCharactersInRange:range withString:@""];
        }
    }];
    return resutlAtt.string;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(84);
    }];
    [self.firstIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.firstBgView);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstIconView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.firstBgView);
        make.size.mas_equalTo(CGSizeMake(100, 43));
    }];
    [self.firstTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.firstBgView);
        make.left.mas_equalTo(self.firstButton.mas_right).mas_offset(4);
        make.height.mas_equalTo(30);
    }];
    [self.firstNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.firstTf.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];
    
    [self.secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.firstBgView.mas_bottom);
        make.height.mas_equalTo(84);
    }];
    [self.secondIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.secondBgView);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondIconView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.secondBgView);
        make.size.mas_equalTo(CGSizeMake(100, 43));
    }];
    [self.secondTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.secondBgView);
        make.left.mas_equalTo(self.secondButton.mas_right).mas_offset(4);
        make.height.mas_equalTo(30);
    }];
    [self.secondNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.secondTf.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];
}

static inline UIImageView *makeImageView() {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

static inline UIButton *makeButton() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:ColorFromRGB(0x3B3B3B) forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = Font(19);
    return button;
}

static inline UILabel *makeLabel() {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = ColorFromRGB(0x919191);
    label.textAlignment = NSTextAlignmentRight;
    label.font = Font(12);
    return label;
}

static inline UIView *makeBgView() {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}

static inline UITextField *makeTextField() {
    UITextField *tf = [[UITextField alloc] init];
    tf.textAlignment = NSTextAlignmentRight;
    tf.font = Font(23);
    tf.textColor = ColorFromRGB(0x3B3B3B);
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    return tf;
}

static inline NSAttributedString *makeBtnAttriText(NSString *text) {

    //创建Attachment Str
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"expand_arrow"];
    attach.bounds = CGRectMake(4, -2, 7, 14);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttriStr appendAttributedString:imageStr];

    [mutableAttriStr setAttributes:@{NSFontAttributeName: Font(19)} range:NSMakeRange(0, text.length)];
    
    return mutableAttriStr.copy;
}

- (CGFloat)huiLvWithCName:(NSString *)cName {
    if ([cName isEqualToString:@"人民币"]) {
        return 0.0;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"s_name", cName];
    NSArray <ExchangeRate *>*tempArr = [self.rateArr filteredArrayUsingPredicate:predicate];
    return tempArr.firstObject.rate.floatValue;
    return 0.0;
}


#pragma mark - getters
- (CGFloat)firstValue {
    if (self.firstTf.hasText) {
        return self.firstTf.text.floatValue;
    }
    return self.firstTf.placeholder.floatValue;
}
- (CGFloat)secondValue {
    if (self.secondTf.hasText) {
        return self.secondTf.text.floatValue;
    }
    return self.secondTf.placeholder.floatValue;
}

- (CGFloat)firstHuiLv {
    return [self huiLvWithCName:self.firstBtnTitle] / 100.0;
}
- (CGFloat)secondHuiLv {
    return [self huiLvWithCName:self.secondBtnTitle] / 100.0;
}

- (BOOL)firstIsRMB {
    return [self.firstBtnTitle containsString:@"人民币"];
}
- (BOOL)secondIsRMB {
    return [self.secondBtnTitle containsString:@"人民币"];
}
- (NSString *)firstBtnTitle {
    return [self textWithBtn:self.firstButton];
}
- (NSString *)secondBtnTitle {
    return [self textWithBtn:self.secondButton];
}



@end
