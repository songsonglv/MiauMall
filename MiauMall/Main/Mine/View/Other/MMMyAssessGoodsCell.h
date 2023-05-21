//
//  MMMyAssessGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import <UIKit/UIKit.h>
#import "MMNoAssessGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMyAssessGoodsCell : UITableViewCell
@property (nonatomic, strong) MMNoAssessGoodsModel *model;

@property (nonatomic, copy) void(^goAssessBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
