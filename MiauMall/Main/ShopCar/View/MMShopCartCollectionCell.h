//
//  MMShopCartCollectionCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/14.
//

#import <UIKit/UIKit.h>
#import "MMShopCarGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMShopCartCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *freefreightStrHead;
@property (nonatomic, strong) NSString *NoDiscountTips;
@property (nonatomic, assign) float hei;//总的高度
@property (nonatomic, assign) float picHei;
@property (nonatomic, strong) NSArray *picArr1;
@property (nonatomic, copy) void(^tapMoreBlock)(NSString *str);
@property (nonatomic, copy) void(^tapSubBlock)(NSString *num,MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapAddBlock)(NSString *num,MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapAttiBlock)(MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapSeleBlock)(MMShopCarGoodsModel *model,NSString *isBuy);
@property (nonatomic, copy) void(^tapDeleteBlock)(MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapCollecBlock)(MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapSimilarBlock)(MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapLikeBlock)(NSString *str,MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapUpdataBlock)(MMShopCarGoodsModel *model, NSString *num);
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapHomeBlock)(NSString *str);
//@property (nonatomic, copy) void(^tapCycleBlock)(NSString *router);
@property (nonatomic, copy) void(^tapPicblock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
