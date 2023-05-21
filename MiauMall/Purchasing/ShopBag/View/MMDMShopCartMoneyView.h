//
//  MMDMShopCartMoneyView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import <UIKit/UIKit.h>
#import "MMDMShopCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMShopCartMoneyView : UIView
@property (nonatomic, strong) MMDMShopCartModel *model;
@property (nonatomic, copy) void(^tapSeleBlock)(NSString *str);
@property (nonatomic, copy) void(^tapOrderBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
