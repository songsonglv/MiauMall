//
//  MMAgainSetPassWordVC.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/13.
//

#import "MMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMAgainSetPassWordVC : MMBaseViewController
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *VerifyCode;
@property (nonatomic, strong) NSString *type;
@end

NS_ASSUME_NONNULL_END
