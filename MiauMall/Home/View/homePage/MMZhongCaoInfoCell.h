//
//  MMZhongCaoInfoCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMZhongCaoInfoCell : UITableViewCell
@property (nonatomic, strong) MMZhongCaoInfoItemModel *model;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@property (nonatomic, strong) NSString *heiStr;
@end

NS_ASSUME_NONNULL_END
