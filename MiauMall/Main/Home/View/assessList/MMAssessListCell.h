//
//  MMAssessListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/22.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailAssessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMAssessListCell : UITableViewCell
@property (nonatomic, strong) MMGoodsDetailAssessModel *model;
@property (nonatomic, copy) void(^tapPicBlock)(NSArray *arr,NSInteger index);
@end

NS_ASSUME_NONNULL_END
