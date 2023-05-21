//
//  MMDMOrderDetailAddressView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import <UIKit/UIKit.h>
#import "MMDMOrderDetailModel.h"
#import "MMDMChooseLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderDetailAddressView : UIView
@property (nonatomic, strong) MMDMOrderDetailModel *model;
@property (nonatomic, strong) MMDMChooseLogisticsModel *model1;
@end

NS_ASSUME_NONNULL_END
