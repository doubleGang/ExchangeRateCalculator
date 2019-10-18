//
//  CalculatorView.h
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/17.
//  Copyright © 2019 YYongJie. All rights reserved.
//


#import "ExchangeRate.h"

NS_ASSUME_NONNULL_BEGIN

@class CalculatorView;

@protocol CalculatorViewDelegate <NSObject>

/// 点货币按钮触发
/// @param view self
/// @param currencyName 货币name
/// @param completion 选择新的货币完成，回调
- (void)calculatorView:(CalculatorView *)view currencyName:(NSString *)currencyName selecedCurrencyCompletion:(void(^)(NSString *newCName, NSString *cPicName))completion;

@end

@interface CalculatorView : UIView

/// 初始化方法
/// @param rateArr 汇率信息数组
- (instancetype)initWithRateArr:(NSArray <ExchangeRate *>*)rateArr;

/// 代理
@property (nonatomic, weak) id<CalculatorViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
