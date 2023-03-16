//
//  MMWalletDataModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMWalletDataModel : NSObject
@property (nonatomic, copy) NSString *BalanceRlue;
@property (nonatomic, copy) NSString *BalanceRlueName;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *HaveBalance;
@property (nonatomic, copy) NSString *HaveWith;
@property (nonatomic, copy) NSString *IsUseBalance;
@property (nonatomic, copy) NSString *IsUseSetBalanceRlue;
@property (nonatomic, copy) NSString *Moneys;
@property (nonatomic, copy) NSString *MoneysShow;
@property (nonatomic, copy) NSString *RechargeMin;
@property (nonatomic, strong) NSArray *accounts;
@end

NS_ASSUME_NONNULL_END
