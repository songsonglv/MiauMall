//
//  MMRefundGoodsInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/19.
//

#import <UIKit/UIKit.h>
#import "MMRefundResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRefundGoodsInfoView : UIView
@property (nonatomic, strong) MMRefundResultModel *model;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
