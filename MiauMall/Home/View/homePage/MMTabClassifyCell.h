//
//  MMTabClassifyCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTabClassifyCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong) NSArray *contArr; 
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *touter);
@property (nonatomic, copy) void(^tapCarBlock)(NSString *GoodsID);
@end

NS_ASSUME_NONNULL_END
