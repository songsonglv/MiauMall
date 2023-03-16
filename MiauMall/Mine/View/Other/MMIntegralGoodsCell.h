//
//  MMIntegralGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import <UIKit/UIKit.h>
#import "MMIntegralListGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMIntegralGoodsCell : UICollectionViewCell
@property (nonatomic, strong) MMIntegralListGoodsModel *model;
@property (nonatomic, copy) void(^tapExchangeBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
