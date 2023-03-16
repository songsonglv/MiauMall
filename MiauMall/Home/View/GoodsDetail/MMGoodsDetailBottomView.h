//
//  MMGoodsDetailBottomView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDetailBottomView : UIView
@property (nonatomic, strong) NSString *num;//展示购物车数量
@property (nonatomic,copy) void (^homeTapBlock)(NSString *indexStr);//点击进入首页
@property (nonatomic,copy) void (^kefuTapBlock)(NSString *indexStr);//点击进入客服
@property (nonatomic,copy) void (^carTapBlock)(NSString *indexStr);//点击进入购物车
@property (nonatomic,copy) void (^addCarTapBlock)(NSString *indexStr);//点击加入购物车
@property (nonatomic,copy) void (^buyNowTapBlock)(NSString *indexStr);//点击进入立即购买页面
@property (nonatomic, strong) UIButton *addCarBt;
@property (nonatomic, strong) UIButton *exchangeBt;
@end

NS_ASSUME_NONNULL_END
