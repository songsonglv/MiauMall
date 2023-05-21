//
//  MMOptionalAreaGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOptionalAreaGoodsCell : UICollectionViewCell
@property (nonatomic, strong) MMHomeRecommendGoodsModel *model;
@property (nonatomic, strong) NSString *optionalName;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
