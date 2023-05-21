//
//  MMDMUseIntegView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import <UIKit/UIKit.h>
#import "MMDMConfirmOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMUseIntegView : UIView
@property (nonatomic, strong) MMDMConfirmOrderModel *model;
@property (nonatomic, copy) void(^returnUseBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
