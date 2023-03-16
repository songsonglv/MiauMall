//
//  MMPartnerAddAccountVC.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMBaseViewController.h"
#import "MMEditAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerAddAccountVC : MMBaseViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) MMEditAccountModel *model;
@end

NS_ASSUME_NONNULL_END
