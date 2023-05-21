//
//  MMDMShopCartEditView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import <UIKit/UIKit.h>
#import "MMDMShopCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMShopCartEditView : UIView
@property (nonatomic, strong) MMDMShopCartModel *model;
@property (nonatomic, copy) void(^tapSeleBlock)(NSString *str);
@property (nonatomic, copy) void(^tapDeleBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
