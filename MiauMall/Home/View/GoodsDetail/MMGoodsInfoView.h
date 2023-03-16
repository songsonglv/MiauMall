//
//  MMGoodsInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"
#import "MMAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsInfoView : UIView
@property (nonatomic, strong) MMGoodsDetailMainModel *proInfo;//商品主要信息
@property (nonatomic, strong) MMAddressModel *addressModel;//收货地址
@property (nonatomic, strong) NSArray *rotationArr;//滚动图片数组
@property (nonatomic, strong) NSString *showStr;//规格显示的字符串 没有的话就x1件
@property (nonatomic, strong) NSString *limitNum;//限购数量
@property (nonatomic,copy) void (^discountTapBlock)(NSString *indexStr);//点击优惠按钮
@property (nonatomic,copy) void (^shareTapBlock)(NSString *indexStr);//点击晒单按钮
@property (nonatomic,copy) void (^selectTapBlock)(NSString *indexStr);//点击选择规格
@property (nonatomic,copy) void (^equityTapBlock)(NSString *indexStr);//点击权益
@end

NS_ASSUME_NONNULL_END
