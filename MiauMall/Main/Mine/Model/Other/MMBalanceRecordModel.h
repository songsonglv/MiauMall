//
//  MMBalanceRecordModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBalanceRecordModel : NSObject
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *NeedPayMoney;
@property (nonatomic, copy) NSString *NeedPayMoneyShow;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *RefundBalance;
@property (nonatomic, copy) NSString *RefundBalanceShow;
@property (nonatomic, copy) NSString *RefundTime;
@property (nonatomic, copy) NSString *RewardInte;
@property (nonatomic, copy) NSString *RewardMoney;
@property (nonatomic, copy) NSString *RewardMoneyShow;
@property (nonatomic, copy) NSString *SurplusBalance;
@property (nonatomic, copy) NSString *SurplusBalanceShow;
@property (nonatomic, copy) NSString *Transactions;
@end

NS_ASSUME_NONNULL_END
