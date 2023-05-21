//
//  MMDistributionOrderCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <UIKit/UIKit.h>
#import "MMPartnerOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDistributionOrderCell : UITableViewCell
@property (nonatomic, strong) MMPartnerOrderModel *model;
@end

NS_ASSUME_NONNULL_END
