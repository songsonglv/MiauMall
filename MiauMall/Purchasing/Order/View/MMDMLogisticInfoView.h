//
//  MMDMLogisticInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <UIKit/UIKit.h>
#import "MMDMChooseLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMLogisticInfoView : UIView
@property (nonatomic, strong) MMDMChooseLogisticsModel *model;
@property (nonatomic, strong) NSString *attachStr;
@end

NS_ASSUME_NONNULL_END
