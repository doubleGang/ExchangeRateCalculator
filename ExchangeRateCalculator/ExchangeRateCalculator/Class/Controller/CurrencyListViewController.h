//
//  CurrencyListViewController.h
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyListViewController : UIViewController

/// 选择新的货币完成，回调 newCNmae：新的货币名；cPicName：新货币icon
@property (nonatomic, copy) void (^selectNewCNameCompletion)(NSString *newCName, NSString *cPicName);

///  初始化
/// @param cName 币种名 如：人民币、美元
- (instancetype)initWithCurrencyName:(NSString *)cName;

@end

NS_ASSUME_NONNULL_END
