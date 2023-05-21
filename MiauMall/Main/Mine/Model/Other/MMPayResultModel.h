//
//  MMPayResultModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPayResultModel : NSObject
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
@property (nonatomic, copy) NSString *IsStripeType;//是否展示信用卡支付弹窗 0 否 1 是
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
@property (nonatomic, copy) NSString *Taxation; //提示文案 只在countryid == 3361（）加拿大时才会用到 和信用卡或PayPal 同时满足时 两种提示文案拼接
@property (nonatomic, copy) NSString *PayChargeTips;//2.
@property (nonatomic, strong) NSArray *TmplIds;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *urlorder;

@end

NS_ASSUME_NONNULL_END
