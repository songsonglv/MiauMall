//
//  MMOrderChangeAddressVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMBaseViewController.h"
#import "MMOrderDetailInfoModel.h"
#import "MMAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderChangeAddressVC : MMBaseViewController
@property (nonatomic, strong) MMOrderDetailInfoModel *model;
@property (nonatomic, strong) MMOrderAddressModel *addressModel;
@property (nonatomic, strong) NSString *isEnder;//0 列表 1 详情
@property (nonatomic, copy) void(^selectAddressBlock)(MMAddressModel *addressModel);
@end

NS_ASSUME_NONNULL_END
