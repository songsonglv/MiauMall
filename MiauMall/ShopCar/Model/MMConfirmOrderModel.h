//
//  MMConfirmOrderModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//

#import <Foundation/Foundation.h>
#import "MMFreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMConfirmOrderModel : NSObject
@property (nonatomic, copy)NSString *ActiveItemMoney;
@property (nonatomic, copy)NSString *ActiveItemMoneyShow;
@property (nonatomic, copy)NSString *Address;
@property (nonatomic, copy)NSString *AddressId;
@property (nonatomic, strong)NSArray *AddressModels;
@property (nonatomic, copy)NSString *AddressType;
@property (nonatomic, copy)NSString *AreaName;
@property (nonatomic, copy)NSString *BuyNum;
@property (nonatomic, copy)NSString *BuyTips;
@property (nonatomic, copy)NSString *CalendarPicture;
@property (nonatomic, copy)NSString *CalendarTitle;
@property (nonatomic, copy)NSString *Consignee;
@property (nonatomic, copy)NSString *CostInteg;
@property (nonatomic, copy)NSString *CountryID;
@property (nonatomic, copy)NSString *CouponID;
@property (nonatomic, copy)NSString *CouponName;
@property (nonatomic, copy)NSString *DelayShipmentTime;
@property (nonatomic, copy)NSString *DiscRule;
@property (nonatomic, copy)NSString *DiscRuleVal;
@property (nonatomic, copy)NSString *Discount;
@property (nonatomic, copy)NSString *DiscountMoneys;
@property (nonatomic, copy)NSString *DiscountMoneysShow; //使用折扣码优惠
@property (nonatomic, copy)NSString *DiscountShow;//使用优惠券优惠
@property (nonatomic, copy)NSString *EstimatedShipment;
@property (nonatomic, copy)NSString *FangyiTips;
@property (nonatomic, copy)NSString *FreeShipNeedMoney;
@property (nonatomic, copy)NSString *FreeShipNeedMoneyShow;
@property (nonatomic, copy)NSString *Freight;
@property (nonatomic, copy)NSString *FreightShow;
@property (nonatomic, copy)NSString *Freighttips;
@property (nonatomic, copy)NSString *HaveCoupon;
@property (nonatomic, copy)NSString *HaveIntePay;
@property (nonatomic, copy)NSString *HaveShipContact;
@property (nonatomic, copy)NSString *HaveShipContact1;
@property (nonatomic, copy)NSString *HaveShipContact2;
@property (nonatomic, copy)NSString *HaveShipContact3;
@property (nonatomic, copy)NSString *IntegMoneys;
@property (nonatomic, copy)NSString *IntegMoneysShow;
@property (nonatomic, copy)NSString *IsOpenFangyiTips;
@property (nonatomic, copy)NSString *IsRemotely;
@property (nonatomic, copy)NSString *ItemMoney;
@property (nonatomic, copy)NSString *ItemMoneyRMB;
@property (nonatomic, copy)NSString *ItemMoneyShow;
@property (nonatomic, copy)NSString *LevelDiscount;
@property (nonatomic, copy)NSString *LevelMoneys;
@property (nonatomic, copy)NSString *LevelMoneysShow;
@property (nonatomic, copy)NSString *MaxUseIntegral;
@property (nonatomic, copy)NSString *MaxUseIntegralShow;
@property (nonatomic, copy)NSString *MeitongPrecautions;
@property (nonatomic, copy)NSString *MobilePhone;
@property (nonatomic, copy)NSString *Moneys;
@property (nonatomic, copy)NSString *MyIntegral;
@property (nonatomic, copy)NSString *OldPayMoney;
@property (nonatomic, copy)NSString *OnlyRenXuanTotalShow;
@property (nonatomic, strong)NSArray *PackNums;
@property (nonatomic, copy)NSString *PayMoney;
@property (nonatomic, copy)NSString *PayMoneyRMB;
@property (nonatomic, copy)NSString *PayMoneyShow;
@property (nonatomic, copy)NSString *PostalCode;
@property (nonatomic, copy)NSString *Province;
@property (nonatomic, copy)NSString *RemotelyMoney;
@property (nonatomic, copy)NSString *RemotelyMoneyShow;
@property (nonatomic, copy)NSString *RemotelyShortName;
@property (nonatomic, copy)NSString *RemotelyTips;
@property (nonatomic, copy)NSString *ShipmentTips;
@property (nonatomic, copy)NSString *ShippingType;
@property (nonatomic, copy)NSString *ShunfengTips;
@property (nonatomic, copy)NSString *SignMoney;
@property (nonatomic, copy)NSString *SignMoneyShow;
@property (nonatomic, copy)NSString *TemporaryTips;
@property (nonatomic, strong)NSArray *TmplIds;
@property (nonatomic, copy)NSString *TotalInt;
@property (nonatomic, copy)NSString *TransactionsType;
@property (nonatomic, copy)NSString *UseCoupon;
@property (nonatomic, copy)NSString *UseInteg;
@property (nonatomic, copy)NSString *UseIntegral;
@property (nonatomic, strong)MMFreeModel *fremodel;
@property (nonatomic, copy)NSString *shipname;
@property (nonatomic, copy)NSString *shipphone;
@property (nonatomic, strong)NSArray *list;
@property (nonatomic, strong)NSArray *list2;
@property (nonatomic, strong)NSArray *list3;
@property (nonatomic, strong) NSArray *Weight;

@end

NS_ASSUME_NONNULL_END
