//
//  MMCouponCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import <UIKit/UIKit.h>
#import "MMCouponInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMCouponCell : UITableViewCell
@property (nonatomic, strong) MMCouponInfoModel *model;
@property (nonatomic, copy) void(^goHomeBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
