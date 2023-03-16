//
//  MMAddressListViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import "MMBaseViewController.h"
@class MMAddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface MMAddressListViewController : MMBaseViewController
@property (nonatomic, strong) NSString *isEnter;//0 选择地址 点击穿出去
@property (nonatomic, copy) void(^returnAddressBlock)(MMAddressModel *model);

@end

NS_ASSUME_NONNULL_END
