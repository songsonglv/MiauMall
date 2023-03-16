//
//  MMShopCarEditView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/16.
//

#import <UIKit/UIKit.h>
#import "MMShopCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCarEditView : UIView
@property (nonatomic, strong) MMShopCarModel *model;
@property (nonatomic, copy) void(^tapSeleBlock)(NSString *str);
@property (nonatomic, copy) void(^tapDeleBlock)(NSString *str);
@property (nonatomic, copy) void(^tapCollBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
