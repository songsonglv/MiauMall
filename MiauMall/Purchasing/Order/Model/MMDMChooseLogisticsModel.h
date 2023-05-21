//
//  MMDMChooseLogisticsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMChooseLogisticsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PaySignMoney;
@property (nonatomic, copy) NSString *TotalPhotoMoney;
@property (nonatomic, copy) NSString *TotalPhotoMoneyShow;
@property (nonatomic, copy) NSString *SupplementaryMoney;
@property (nonatomic, copy) NSString *SupplementaryMoneyShow;
@property (nonatomic, copy) NSString *Freight;
@property (nonatomic, copy) NSString *FreightShow;
@property (nonatomic, copy) NSString *CustodyMoney;
@property (nonatomic, copy) NSString *CustodyMoneyShow;
@property (nonatomic, copy) NSString *Weight;
@property (nonatomic, copy) NSString *Consignee;
@property (nonatomic, copy) NSString *MobilePhone;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *CustodyDay;
@property (nonatomic, copy) NSString *ReinforcementMoney;
@property (nonatomic, copy) NSString *ReinforcementMoneyShow;
@property (nonatomic, copy) NSString *ReinforcementTitle;
@property (nonatomic, copy) NSString *ReinforcementTips;
@property (nonatomic, strong) NSMutableArray *ExpressFees;
@end

NS_ASSUME_NONNULL_END
