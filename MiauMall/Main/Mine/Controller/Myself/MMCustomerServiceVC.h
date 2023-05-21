//
//  MMCustomerServiceVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import "MMBaseWebViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCustomerServiceVC : MMBaseWebViewVC
@property (nonatomic, strong) NSString *goodsName; //所有非订单页面进来的 都需要传商品ID
@property (nonatomic, strong) NSString *orderID; //订单页面进来无需传商品ID
@property (nonatomic, strong) NSString *isDM;//代买页面进来
@end

NS_ASSUME_NONNULL_END
