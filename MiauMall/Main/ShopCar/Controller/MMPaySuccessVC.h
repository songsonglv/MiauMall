//
//  MMPaySuccessVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPaySuccessVC : MMBaseViewController
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *isEnter;// 1 直接返回 上上上个页面
@property (nonatomic, strong) NSString *isDM;//1 代买进来的

@end

NS_ASSUME_NONNULL_END
