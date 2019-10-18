//
//  HuiLvTableViewCell.m
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/30.
//  Copyright © 2019 JZY. All rights reserved.
//

#import "HuiLvTableViewCell.h"

@interface HuiLvTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedMarkView;

@end

@implementation HuiLvTableViewCell


#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.selectedMarkView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.contentView);
    }];
        
    [self.selectedMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(16, 10));
    }];
}

#pragma mark - setters
- (void)setData:(id)data {
    if ([data isKindOfClass:NSDictionary.class]) {
        self.iconImageView.image = IMAGE(data[@"icon"]);
        self.nameLabel.text = data[@"text"];
    }
}

#pragma mark - getters
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        UIImageView *iv = [[UIImageView alloc] init];
        _iconImageView = iv;
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = 36 / 2;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Font(18);
        _nameLabel.textColor = ColorFromRGB(0x3B3B3B);
    }
    return _nameLabel;
}

- (UIImageView *)selectedMarkView {
    if (_selectedMarkView == nil) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:IMAGE(@"icon_right_G")];
        _selectedMarkView = iv;
        iv.hidden = YES;
    }
    return _selectedMarkView;
}

@end
