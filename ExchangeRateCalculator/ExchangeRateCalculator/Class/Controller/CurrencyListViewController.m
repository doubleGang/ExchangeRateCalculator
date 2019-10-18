//
//  CurrencyListViewController.m
//  ExchangeRateCalculator
//
//  Created by 杨永杰 on 2019/10/18.
//  Copyright © 2019 YYongJie. All rights reserved.
//

#import "CurrencyListViewController.h"
#import "HuiLvTableViewCell.h"

static NSString *cellId = @"cellId";

@interface CurrencyListViewController () <UITableViewDelegate, UITableViewDataSource>

// 传过来的 货币name
@property (nonatomic, copy) NSString *currencyName;
// 选中的 索引
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray <NSDictionary *>*dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CurrencyListViewController

#pragma mark - life cycle
- (instancetype)initWithCurrencyName:(NSString *)cName {
    if (self = [super init]) {
        self.currencyName = cName;
        
        for (NSDictionary *dict in self.dataArray) {
            if ([(NSString *)dict[@"text"] containsString:cName]) {
                self.selectedIndex = [self.dataArray indexOfObject:dict];
                break;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择币种";
    self.view.backgroundColor = [UIColor whiteColor];    
    [self.view addSubview:self.tableView];
}


#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HuiLvTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HuiLvTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
      
    if (indexPath.row < self.dataArray.count) {
        [cell setData:self.dataArray[indexPath.row]];
    }
    BOOL seleted = indexPath.row == self.selectedIndex;
    cell.selectedMarkView.hidden = !seleted;
    cell.nameLabel.textColor = seleted ? ColorFromRGB(0xB1EB54) : ColorFromRGB(0x3B3B3B);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        if (self.selectNewCNameCompletion) {
            self.selectNewCNameCompletion(dict[@"text"], dict[@"icon"]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



#pragma mark - getters
-(UITableView *)tableView {
    if (!_tableView) {
        
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - TopOffset);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
         _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 44;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_tableView registerClass:[HuiLvTableViewCell class] forCellReuseIdentifier:cellId];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }

    }
    return _tableView;
}

- (NSArray<NSDictionary *> *)dataArray {
    if (_dataArray == nil) {
        NSArray *textArray = @[@"人民币 CNY", @"美元 USD", @"欧元 EUR", @"日元 JPY", @"港元 HKD", @"澳元 AUD",
        @"英镑 GBP", @"韩元 KRW", @"泰铢 THB", @"新加坡元 SGD", @"卢布 RUB", @"加元 CAD", @"新西兰元 NZD", @"林吉特 MYR",
        @"瑞士法郎 CHF", @"比索 PHP", @"兰特 ZAR", @"迪拉姆 AED", @"里亚尔 SAR", @"福林 HUF", @"兹罗提 PLY", @"丹麦克朗 DKK",
          @"瑞典克朗 SEK", @"挪威克朗 NOK", @"里拉 JPY"];
                                
       NSArray *imageArray = @[@"flag_cny",
                               @"flag_usd",
                               @"flag_eur",
                               @"flag_jpy",
                               @"flag_hkd",
                               @"flag_aud",
                               @"flag_gbp",
                               @"flag_krw",
                               @"flag_thb",
                               @"flag_sgd",
                               @"flag_rub",
                               @"flag_cad",
                               @"flag_nzd",
                               @"flag_myr",
                               @"flag_chf",
                               @"flag_php",
                               @"flag_zar",
                               @"flag_aed",
                               @"flag_sar",
                               @"flag_huf",
                               @"flag_pln",
                               @"flag_dkk",
                               @"flag_sek",
                               @"flag_nok",
                               @"flag_jpy"];

        NSMutableArray *muArr = [NSMutableArray array];
        for (int i = 0 ; i < textArray.count; i++) {
            [muArr addObject:@{@"icon" : imageArray[i], @"text" : textArray[i]}];
        }
        _dataArray = muArr.copy;
    }
    return _dataArray;
}

@end
