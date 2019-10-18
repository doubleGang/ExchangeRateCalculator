//
//  CalculatorViewController.m
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/17.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CurrencyListViewController.h"

#import "ExchangeRate.h"
#import "CalculatorView.h"

@interface CalculatorViewController () <CalculatorViewDelegate>

// 计算器view（选择币种、输入金额）
@property (nonatomic, strong) CalculatorView *calView;
// 汇率数组
@property (nonatomic, copy) NSArray <ExchangeRate *>*rateInfoArray;

@end

@implementation CalculatorViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"汇率换算器";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.calView];
    [self erc_layoutSubviews];
}



#pragma mark - CalculatorViewDelegate
- (void)calculatorView:(CalculatorView *)view currencyName:(NSString *)currencyName selecedCurrencyCompletion:(void (^)(NSString * _Nonnull, NSString * _Nonnull))completion {
        
    CurrencyListViewController *listVc = [[CurrencyListViewController alloc] initWithCurrencyName:currencyName];
    listVc.selectNewCNameCompletion = ^(NSString * _Nonnull newCName, NSString * _Nonnull cPicName) {
        if (completion) {
            completion(newCName, cPicName);
        }
    };
    [self.navigationController pushViewController:listVc animated:YES];
}


#pragma mark - private methods
- (void)erc_layoutSubviews {
    [self.calView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(168);
    }];
}


#pragma mark - getters
- (CalculatorView *)calView {
    if (_calView == nil) {
        _calView = [[CalculatorView alloc] initWithRateArr:self.rateInfoArray];
        _calView.delegate = self;
    
    }
    return _calView;
}

- (NSArray *)rateInfoArray {
    if (_rateInfoArray == nil) {
        
        NSArray *dictArr = @[@{@"name" : @"美元",
                               @"rate" : @"706.9"},
                             @{@"name" : @"欧元",
                               @"rate" : @"786.25"},
                             @{@"name" : @"日元",
                               @"rate" : @"6.5081"},
                             @{@"name" : @"港元",
                               @"rate" : @"90.136"},
                             @{@"name" : @"英镑",
                               @"rate" : @"909.52"},
                             @{@"name" : @"林吉特",
                               @"rate" : @"59.133"},
                             @{@"name" : @"卢布",
                               @"rate" : @"906.19"},
                             @{@"name" : @"澳元",
                               @"rate" : @"482.38"},
                             @{@"name" : @"加元",
                               @"rate" : @"538.03"},
                             @{@"name" : @"新西兰元",
                               @"rate" : @"448.85"},
                             @{@"name" : @"新加坡元",
                               @"rate" : @"517.89"},
                             @{@"name" : @"瑞士法郎",
                               @"rate" : @"715.7"},
                             @{@"name" : @"兰特",
                               @"rate" : @"209.83"},
                             @{@"name" : @"韩元",
                               @"rate" : @"16695.0"},
                             @{@"name" : @"迪拉姆",
                               @"rate" : @"51.975"},
                             @{@"name" : @"里亚尔",
                               @"rate" : @"53.074"},
                             @{@"name" : @"福林",
                               @"rate" : @"4212.75"},
                             @{@"name" : @"兹罗提",
                               @"rate" : @"54.498"},
                             @{@"name" : @"丹麦克朗",
                               @"rate" : @"95.03"},
                             @{@"name" : @"瑞典克朗",
                               @"rate" : @"137.38"},
                             @{@"name" : @"挪威克朗",
                               @"rate" : @"129.94"},
                             @{@"name" : @"里拉",
                               @"rate" : @"82.331"},
                             @{@"name" : @"比索",
                               @"rate" : @"271.58"},
                             @{@"name" : @"泰铢",
                               @"rate" : @"428.77"}];
        
        NSMutableArray *muArr = [NSMutableArray array];
        for (NSDictionary *dict in dictArr) {
            ExchangeRate *rate = [[ExchangeRate alloc] initWithName:dict[@"name"] rate:dict[@"rate"]];
            [muArr addObject:rate];
        }
        _rateInfoArray = muArr;
    }
    return _rateInfoArray;
}


@end
