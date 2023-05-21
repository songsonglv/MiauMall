//
//  MMMyCollectionCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import <UIKit/UIKit.h>
#import "MMCollectionModel.h"
#import "MMFootOrCollectGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMyCollectionCell : UITableViewCell
@property (nonatomic, strong) MMCollectionModel *model;
@property (nonatomic, strong) MMFootOrCollectGoodsModel *model1;
@property (nonatomic, strong) NSString *isselect;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, copy) void(^tapCarBlock)(NSString *ID);
@property (nonatomic, copy) void(^addSelectBlock)(NSString *ID);
@property (nonatomic, copy) void(^deleteSelectBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
