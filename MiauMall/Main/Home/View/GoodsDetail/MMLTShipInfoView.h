//
//  MMLTShipInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/13.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMLTShipInfoView : UIView
@property (nonatomic, strong) MMGoodsDetailMainModel *proInfo;//商品主要信息
@property (nonatomic, strong) NSString *showStr;//规格显示的字符串 没有的话就x1件
@property (nonatomic, strong) NSString *stockStr;//库存显示字符串
@property (nonatomic,copy) void (^selectTapBlock)(NSString *indexStr);//点击选择规格
@property (nonatomic,copy) void (^equityTapBlock)(NSString *indexStr);//点击权益
@end

NS_ASSUME_NONNULL_END
