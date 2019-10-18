//
//  ExchangeRate.h
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeRate : NSObject

- (instancetype)initWithName:(NSString *)name rate:(NSString *)rate;

@property (nonatomic, readonly) NSString * s_name; //原币种名称
@property (nonatomic, readonly) NSString * rate; //汇率

@end

NS_ASSUME_NONNULL_END
