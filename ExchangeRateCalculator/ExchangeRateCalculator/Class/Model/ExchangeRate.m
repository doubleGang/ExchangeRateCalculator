//
//  ExchangeRate.m
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "ExchangeRate.h"

@interface ExchangeRate ()

@property (nonatomic, copy) NSString * s_name; //原币种名称
@property (nonatomic, copy) NSString * rate; //汇率

@end

@implementation ExchangeRate

- (instancetype)initWithName:(NSString *)name rate:(NSString *)rate {
    if (self = [super init]) {
        self.s_name = name;
        self.rate = rate;        
    }
    return self;
}
@end
