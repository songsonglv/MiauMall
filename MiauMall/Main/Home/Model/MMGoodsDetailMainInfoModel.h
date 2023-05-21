//
//  MMGoodsDetailMainInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//  商品详情主要信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDetailMainInfoModel : NSObject
@property (nonatomic, copy) NSString *ActiveName;
@property (nonatomic, copy) NSString *ActivePrice;
@property (nonatomic, copy) NSString *ActivePriceShow;
@property (nonatomic, copy) NSString *ActivePriceShowPrice;
@property (nonatomic, copy) NSString *ActivePriceShowSign;

@property (nonatomic, copy) NSString *ActiveDiscountPrice; //判断优惠是用大图还是小图
@property (nonatomic, copy) NSString *ActiveDiscountPriceShow;
@property (nonatomic, copy) NSString *ActiveDiscountPriceShowPrice;
@property (nonatomic, copy) NSString *ActiveDiscountPriceShowSign;

@property (nonatomic, strong) NSArray *Albums;
//banner数组 Albums =         (
//"https://static.miau2020.com/upload/Plupload/Img_451/20221209143055586.jpg"
//)

@property (nonatomic, copy) NSString *ArrivalTime;
@property (nonatomic, copy) NSString *Collections;
@property (nonatomic, copy) NSString *DepositEndTime;
@property (nonatomic, copy) NSString *DepositMoney;
@property (nonatomic, copy) NSString *DepositMoneyShow;
@property (nonatomic, copy) NSString *DepositStartTime;
@property (nonatomic, copy) NSString *DiscountCode;
@property (nonatomic, copy) NSString *DiscountName;//折扣标签展示
@property (nonatomic, copy) NSString *DiscountShow;
@property (nonatomic, copy) NSString *DiscountTips;
@property (nonatomic, copy) NSString *FinalPayEndTime;
@property (nonatomic, copy) NSString *FinalPayStartTime;
@property (nonatomic, copy) NSString *FirstVideo;
@property (nonatomic, copy) NSString *HaveAttribute;
@property (nonatomic, copy) NSString *HidSalesCount;
@property (nonatomic, copy) NSString *Hits;
@property (nonatomic, copy) NSString *IsActive;
@property (nonatomic, copy) NSString *IsCanReturn;
@property (nonatomic, copy) NSString *IsFreeShip;
@property (nonatomic, copy) NSString *IsLimitTime;
@property (nonatomic, copy) NSString *IsOnline;
@property (nonatomic, copy) NSString *Isinte;
@property (nonatomic, copy) NSString *JPDiscount;
@property (nonatomic, copy) NSString *JPDiscountShow;
@property (nonatomic, copy) NSString *LimitBuy;
@property (nonatomic, copy) NSString *LimitNumber;
@property (nonatomic, copy) NSString *LimitPercen;
@property (nonatomic, copy) NSString *LimitType;
@property (nonatomic, copy) NSString *LimtOrderBuy;
@property (nonatomic, copy) NSString *MeitongTips;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *OldPrice;
@property (nonatomic, copy) NSString *OldPriceShow;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *PreSaleNumber;
@property (nonatomic, copy) NSString *PreSaleType;
@property (nonatomic, copy) NSString *Precautions;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *PriceCutName;
@property (nonatomic, copy) NSString *PriceRMB;
@property (nonatomic, copy) NSString *PriceShow;
@property (nonatomic, copy) NSString *PriceShowPrice;
@property (nonatomic, copy) NSString *PriceShowSign;
@property (nonatomic, copy) NSString *PromotionEnd;
@property (nonatomic, copy) NSString *PromotionStamp;
@property (nonatomic, copy) NSString *PromotionStart;
@property (nonatomic, copy) NSString *RealNumber; //库存
@property (nonatomic, copy) NSString *Sales;
@property (nonatomic, copy) NSString *Shipping48;
@property (nonatomic, copy) NSString *ShortName;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *Swell;
@property (nonatomic, copy) NSString *TotalPrice;
@property (nonatomic, copy) NSString *TotalPriceShow;
@property (nonatomic, copy) NSString *TotalPriceShowPrice;
@property (nonatomic, copy) NSString *TotalPriceShowSign;
@property (nonatomic, copy) NSString *UKDiscount;
@property (nonatomic, copy) NSString *UKDiscountShow;
@property (nonatomic, copy) NSString *cartnum;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *inte;
@property (nonatomic, copy) NSString *ProductSign;//标签
@property (nonatomic, copy) NSString *ProductSignTimeStr;//发货时间展示

@end

NS_ASSUME_NONNULL_END
