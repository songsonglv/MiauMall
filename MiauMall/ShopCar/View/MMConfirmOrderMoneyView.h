//
//  MMConfirmOrderMoneyView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "MMConfirmOrderModel.h"
#import "MMConfirmShipDateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMConfirmOrderMoneyView : UIView
@property (nonatomic, strong) MMConfirmOrderModel *model;
@property (nonatomic, strong) MMConfirmShipDateModel *dateModel;
@property (nonatomic, copy) void(^selectCouponBlock)(NSString *str);
@property (nonatomic, copy) void(^selectInteBlock)(NSString *str);
@property (nonatomic, copy) void(^selecGiftBlock)(NSString *str);
@property (nonatomic, copy) void(^inputDiscoundCodeBlock)(NSString *code);


-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
