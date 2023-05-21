//
//  MMDMOrderTypeCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "MMDMOrderTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderTypeCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) MMDMOrderTypeModel *model;
@end

NS_ASSUME_NONNULL_END
