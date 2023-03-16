//
//  MMPackageView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//

#import <UIKit/UIKit.h>
#import "MMConfirmOrderModel.h"
#import "MMAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPackageView : UIView
@property (nonatomic, strong) MMConfirmOrderModel *model;
@property (nonatomic, strong) MMAddressModel *addressModel;
@property (nonatomic, strong) NSString *weightStr;//重量
@property (nonatomic, copy) void(^seleAddressBlock)(NSInteger index);
@property (nonatomic, copy) void(^tapListBlock)(NSInteger index);
@property (nonatomic, copy) void(^returnRemarkBlock)(NSString *remark,NSInteger index);
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
