//
//  HuiLvTableViewCell.h
//  JZYBaseProject
//
//  Created by 杨永杰 on 2019/9/30.
//  Copyright © 2019 JZY. All rights reserved.
//

//#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuiLvTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *selectedMarkView;
@property (nonatomic, readonly) UILabel *nameLabel;

@property (nonatomic, copy) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
