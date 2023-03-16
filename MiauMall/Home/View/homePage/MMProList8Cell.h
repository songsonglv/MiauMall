//
//  MMProList8Cell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMProList8Cell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^taPro8GoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapPro8GoodsCarBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
