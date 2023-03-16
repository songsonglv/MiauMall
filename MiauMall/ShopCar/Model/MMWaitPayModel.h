//
//  MMWaitPayModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMWaitPayModel : NSObject
@property (nonatomic, copy) NSString *CanAlipayPay;
@property (nonatomic, copy) NSString *CanBalancePay;
@property (nonatomic, copy) NSString *CanCardPay;
@property (nonatomic, copy) NSString *CanH5Pay;
@property (nonatomic, copy) NSString *CanMinWxPay;
@property (nonatomic, copy) NSString *CanPayPal;
@property (nonatomic, copy) NSString *CanUnionPay;
@property (nonatomic, copy) NSString *CanWeixinPay;
@property (nonatomic, copy) NSString *HaveAlipay;
@property (nonatomic, copy) NSString *HaveBalance;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *IsLinuxApi;
@property (nonatomic, copy) NSString *IsTaxation;
@property (nonatomic, copy) NSString *IsUseBalance;
@property (nonatomic, copy) NSString *MyBalance;
@property (nonatomic, copy) NSString *MyBalanceRMB;
@property (nonatomic, copy) NSString *MyBalanceShow;
@property (nonatomic, copy) NSString *OrderInte;
@property (nonatomic, copy) NSString *PartialBalance;
@property (nonatomic, copy) NSString *PartialBalanceRMB;
@property (nonatomic, copy) NSString *PartialBalanceShow;
@property (nonatomic, copy) NSString *PayCount;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyRMB;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PayPriceTips;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *Taxation;
@property (nonatomic, strong) NSArray *TmplIds;
@property (nonatomic, copy) NSString *urlorder;
@end

NS_ASSUME_NONNULL_END
