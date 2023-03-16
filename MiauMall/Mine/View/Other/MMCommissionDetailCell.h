//
//  MMCommissionDetailCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import <UIKit/UIKit.h>
#import "MMCommissionModel.h"
#import "MMBalanceRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCommissionDetailCell : UITableViewCell
@property (nonatomic, strong) MMCommissionModel *model;
@property (nonatomic, strong) MMBalanceRecordModel *model1;
@end

NS_ASSUME_NONNULL_END
