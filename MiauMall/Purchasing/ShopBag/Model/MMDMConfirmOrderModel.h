//
//  MMDMConfirmOrderModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMConfirmOrderModel : NSObject
@property (nonatomic, strong) NSMutableArray *AddressModels;
@property (nonatomic, strong) NSMutableArray *ProductItems;//商品数组
@property (nonatomic, copy) NSString *BuyNum;
@property (nonatomic, copy) NSString *ItemMoney;
@property (nonatomic, copy) NSString *ItemMoneyShow;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PayMoneySignShow;
@property (nonatomic, copy) NSString *HaveIntePay;
@property (nonatomic, copy) NSString *MyIntegral;

@property (nonatomic, copy) NSString *UseIntegral;
@property (nonatomic, copy) NSString *UseIntegralShow;
@property (nonatomic, copy) NSString *IsRemotely;
@property (nonatomic, copy) NSString *ProductMoney;
@property (nonatomic, copy) NSString *ProductMoneyShow;
@property (nonatomic, copy) NSString *HandingMoney;
@property (nonatomic, copy) NSString *HandingMoneyShow;

@property (nonatomic, copy) NSString *SureMoney;
@property (nonatomic, copy) NSString *SureMoneyShow;
@property (nonatomic, copy) NSString *JapanFreightMoney;
@property (nonatomic, copy) NSString *JapanFreightMoneyShow;
@property (nonatomic, copy) NSString *HuiLvTips;
@property (nonatomic, strong) NSMutableArray *OrderKnowTips; //下单须知数组

@end


NS_ASSUME_NONNULL_END
