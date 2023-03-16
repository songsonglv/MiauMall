//
//  MMPayViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMBaseViewController.h"
#import "MMPayResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPayViewController : MMBaseViewController
@property (nonatomic, strong) MMPayResultModel *model;
@property (nonatomic, strong) NSString *isEnter;//0 返回上一页（从订单进入支付） 1 返回上上页 （从购物车或者商品直接进入购买）
@end

NS_ASSUME_NONNULL_END
