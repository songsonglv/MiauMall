//
//  MMDMOrderKnowView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import <UIKit/UIKit.h>
#import "MMDMConfirmOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderKnowView : UIView
@property (nonatomic, strong) MMDMConfirmOrderModel *model;
@property (nonatomic, copy) void(^clickKnowBlock)(NSString *str,NSString *isSelect);
@end

NS_ASSUME_NONNULL_END
