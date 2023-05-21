//
//  MMRealNameViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/28.
//

#import <UIKit/UIKit.h>
#import "MMConfirmOrderModel.h"
#import "MMRealNameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRealNameViewController : UIViewController
@property (nonatomic, strong) MMConfirmOrderModel *orderModel;
@property (nonatomic, strong) MMRealNameModel *realNameModel;
@property (nonatomic, copy) void(^returnAgoBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
