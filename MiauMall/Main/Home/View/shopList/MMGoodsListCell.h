//
//  MMGoodsListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsListCell : UITableViewCell
@property (nonatomic, strong) MMHomeRecommendGoodsModel *model;
@property (nonatomic, copy) void(^clickShopCar)(NSString *goodsID);
@end

NS_ASSUME_NONNULL_END
