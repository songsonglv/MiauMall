//
//  MMShopCarBottomView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import <UIKit/UIKit.h>
#import "MMShopCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCarBottomView : UIView
@property (nonatomic, strong) MMShopCarModel *model;
@property (nonatomic, strong) void(^returnViewHei)(CGFloat hei);

@property (nonatomic, copy) void(^goListBlock)(NSString *str);

@property (nonatomic, assign) CGFloat hei;
@end

NS_ASSUME_NONNULL_END
