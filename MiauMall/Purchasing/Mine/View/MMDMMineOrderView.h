//
//  MMDMMineOrderView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/16.
//

#import <UIKit/UIKit.h>
#import "MMDMMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMMineOrderView : UIView
@property (nonatomic, strong) MMDMMemberModel *model;
@property (nonatomic, copy) void(^clickPayBlock)(NSString *orderId);
@property (nonatomic, copy) void(^clickOrderBlock)(NSString *typeId);
@end

NS_ASSUME_NONNULL_END
