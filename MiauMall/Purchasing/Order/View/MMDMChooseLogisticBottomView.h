//
//  MMDMChooseLogisticBottomView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/12.
//

#import <UIKit/UIKit.h>
#import "MMDMChooseLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMChooseLogisticBottomView : UIView
@property (nonatomic, strong) MMDMChooseLogisticsModel *model;

@property (nonatomic, copy) void(^returnSubBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
