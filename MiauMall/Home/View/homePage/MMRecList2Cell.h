//
//  MMRecList2Cell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMRecList2Cell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^TapProListTwoGoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapProListTwoGoodsCarBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
