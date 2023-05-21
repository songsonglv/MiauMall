//
//  MMSelectSKUPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//

#import <UIKit/UIKit.h>
#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectSKUPopView : UIView
@property (nonatomic, strong) NSString *type;// 0 选择sku 1加入购物车 2立即购买 3购物车进来的
@property (nonatomic, copy) void(^SkuAndNumBlock)(MMGoodsAttdataModel *model,NSString *numStr);

@property (nonatomic, copy) void(^addCarBlock)(NSString *str);//点击加入购物车
@property (nonatomic, copy) void(^buyNowBlock)(NSString *str);//点击购买
@property (nonatomic, copy) void(^payDepositBlock)(NSString *str);//付定金

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsSpecModel *)specModel;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
