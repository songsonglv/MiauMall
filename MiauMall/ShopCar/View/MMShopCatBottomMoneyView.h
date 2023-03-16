//
//  MMShopCatBottomMoneyView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import <UIKit/UIKit.h>
#import "MMShopCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCatBottomMoneyView : UIView
@property (nonatomic, strong) MMShopCarModel *model;
@property (nonatomic, copy) void(^tapDetailBlock)(NSString *str);
@property (nonatomic, copy) void(^tapPayBlock)(NSString *str);
@property (nonatomic, copy) void(^tapAllBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
