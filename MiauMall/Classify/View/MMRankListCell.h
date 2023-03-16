//
//  MMRankListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/10.
//

#import <UIKit/UIKit.h>
#import "MMHotGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMRankListCell : UITableViewCell
@property (nonatomic, strong) MMHotGoodsModel *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^tapCarBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
