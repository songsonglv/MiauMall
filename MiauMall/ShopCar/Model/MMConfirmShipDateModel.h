//
//  MMConfirmShipDateModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMConfirmShipDateModel : NSObject
@property (nonatomic, copy) NSString *DiscountCode;
@property (nonatomic, copy) NSString *DiscountCodeCN;
@property (nonatomic, copy) NSString *EMSInfo;
@property (nonatomic, copy) NSString *EMSMoney;
@property (nonatomic, copy) NSString *EMSTips;
@property (nonatomic, copy) NSString *GiftEndTime;
@property (nonatomic, copy) NSString *GiftInfo;
@property (nonatomic, copy) NSString *GiftMoney;
@property (nonatomic, copy) NSString *GiftMoneyShow;
@property (nonatomic, copy) NSString *GiftStartTime;
@property (nonatomic, copy) NSString *GiftStatus;
@property (nonatomic, copy) NSString *GiftTips;
@property (nonatomic, copy) NSString *GiftWordLimit;
@property (nonatomic, copy) NSString *MyTotalIntegral;
@property (nonatomic, copy) NSString *RecCouponID;
@property (nonatomic, copy) NSString *RecDisMethod;
@property (nonatomic, copy) NSString *ShortEMS;
@property (nonatomic, copy) NSString *ShortGift;
@property (nonatomic, copy) NSString *ShortSign;
@property (nonatomic, copy) NSString *SignInfo;
@property (nonatomic, copy) NSString *SignMoney;
@property (nonatomic, copy) NSString *SignMoneyShow;
@property (nonatomic, copy) NSString *SignTips;
@property (nonatomic, strong) NSArray *TimeStr;
@end

NS_ASSUME_NONNULL_END
