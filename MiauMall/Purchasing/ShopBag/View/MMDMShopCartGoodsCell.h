//
//  MMDMShopCartGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import <UIKit/UIKit.h>
#import "MMDMShopCartGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMShopCartGoodsCell : UITableViewCell
@property (nonatomic, strong) MMDMShopCartGoodsModel *model;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) void(^tapSubBlock)(NSString *num,MMDMShopCartGoodsModel *model);
@property (nonatomic, copy) void(^tapAddBlock)(NSString *num,MMDMShopCartGoodsModel *model);
@property (nonatomic, copy) void(^tapSeleBlock)(MMDMShopCartGoodsModel *model,NSString *isBuy);
@property (nonatomic, copy) void(^tapDeleteBlock)(MMDMShopCartGoodsModel *model);
@property (nonatomic, copy) void(^tapUpdateBlock)(MMDMShopCartGoodsModel *model,NSString *num);
@property (nonatomic, copy) void(^tapServiceBlock)(MMDMShopCartGoodsModel *model);
@end

NS_ASSUME_NONNULL_END
