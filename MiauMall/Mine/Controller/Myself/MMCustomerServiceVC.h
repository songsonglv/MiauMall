//
//  MMCustomerServiceVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import "MMBaseWebViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCustomerServiceVC : MMBaseWebViewVC
@property (nonatomic, strong) NSString *goodsID;//从商品详情带过来的
@property (nonatomic, strong) NSString *orderID;
@end

NS_ASSUME_NONNULL_END
