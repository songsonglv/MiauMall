//
//  MMHomeShopGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeShopGoodsCell : UICollectionViewCell
@property (nonatomic, strong) MMHomeRecommendGoodsModel *model;
@property (nonatomic, strong) MMHomeGoodsModel *model1;

@property (nonatomic,copy) void (^TapCarBlock)(NSString *indexStr); //点击商品

@end

NS_ASSUME_NONNULL_END
