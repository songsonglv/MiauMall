//
//  MMOrderDetailInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import <UIKit/UIKit.h>
#import "MMOrderDetailInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMOrderDetailInfoView : UIView
@property (nonatomic, strong) MMOrderDetailInfoModel *model;
@property (nonatomic, copy) void(^tapCopyBlock)(NSString *orderNo);
@end

NS_ASSUME_NONNULL_END
