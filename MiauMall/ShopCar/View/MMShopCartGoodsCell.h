//
//  MMShopCartGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/14.
//

#import <UIKit/UIKit.h>
#import "MMShopCarGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCartGoodsCell : UITableViewCell
@property (nonatomic, strong) MMShopCarGoodsModel *model;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) NSString *isSelect;
@property (nonatomic, copy) void(^tapSubBlock)(NSString *num,MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapAddBlock)(NSString *num,MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapAttiBlock)(MMShopCarGoodsModel *model);
@property (nonatomic, copy) void(^tapSeleBlock)(MMShopCarGoodsModel *model,NSString *isBuy);
@property (nonatomic, copy) void(^tapDeleteBlock)(MMShopCarGoodsModel *model);

@end

NS_ASSUME_NONNULL_END
