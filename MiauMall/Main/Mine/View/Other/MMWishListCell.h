//
//  MMWishListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import <UIKit/UIKit.h>
#import "MMWishListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMWishListCell : UITableViewCell
@property (nonatomic, strong) MMWishListModel *model;
@property (nonatomic, copy) void(^addWishBlock)(NSString *ID);
@property (nonatomic, copy) void(^goShopBlock)(NSString *indexStr);
@end

NS_ASSUME_NONNULL_END
