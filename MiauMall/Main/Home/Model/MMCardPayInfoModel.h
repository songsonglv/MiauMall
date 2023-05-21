//
//  MMCardPayInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMCardPayInfoModel : NSObject
@property (nonatomic, copy) NSString *PayMoneyJPY;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *StripeMoneyTips;
@property (nonatomic, copy) NSString *StripeMoneyPercent;//手续费百分比

@end

NS_ASSUME_NONNULL_END
