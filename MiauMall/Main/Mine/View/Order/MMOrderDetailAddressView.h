//
//  MMOrderDetailAddressView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import <UIKit/UIKit.h>
#import "MMOrderDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderDetailAddressView : UIView
@property (nonatomic, strong) MMAddressModel *model;
@property (nonatomic, strong) MMOrderDetailInfoModel *mainModel;
@property (nonatomic, copy) void(^selectAddressBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
