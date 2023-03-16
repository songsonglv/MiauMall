//
//  MMRankList2Cell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMRankList2Cell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^TapRankListTwoGoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapRankListwoGoodsCarBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
