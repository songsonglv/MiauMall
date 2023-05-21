//
//  MMShopCarGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCarGoodsModel : NSObject
@property (nonatomic, copy) NSString *priceinte;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ukname;
@property (nonatomic, copy) NSString *attname;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url1;
@property (nonatomic, copy) NSString *url2;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *tagshtml;
@property (nonatomic, copy) NSString *buy;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *columnid;
@property (nonatomic, copy) NSString *attid;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *limitorderbuy;//每单限购件数
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *DepositMoney;
@property (nonatomic, copy) NSString *DepositMoneyShow;
@property (nonatomic, copy) NSString *FinalPayStartTime;
@property (nonatomic, copy) NSString *FinalPayEndTime;
@property (nonatomic, copy) NSString *activeprice;
@property (nonatomic, copy) NSString *moneys;
@property (nonatomic, copy) NSString *priceshow;
@property (nonatomic, copy) NSString *activepriceshow;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *moneysshow;
@property (nonatomic, copy) NSString *inte;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *inteall;
@property (nonatomic, copy) NSString *productnumber;
@property (nonatomic, copy) NSString *IsCanSettlement;
@property (nonatomic, copy) NSString *IsCanSelectPay;
@property (nonatomic, copy) NSString *ShipTimeTips;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *cmlength;
@property (nonatomic, copy) NSString *cmwidth;
@property (nonatomic, copy) NSString *cmheight;
@property (nonatomic, copy) NSString *DownRate;
@property (nonatomic, copy) NSString *OptionalID;//0 为自营商品 其他目前是预售商品
@property (nonatomic, copy) NSString *ONum;
@property (nonatomic, copy) NSString *OPrice;
@property (nonatomic, copy) NSString *OptionalName;
@property (nonatomic, copy) NSString *OPriceShow;
@property (nonatomic, copy) NSString *IsFreeShip;
@property (nonatomic, copy) NSString *ProductSign;
@property (nonatomic, copy) NSString *RealNumber;
@property (nonatomic, copy) NSString *renxuansalesmoney;
@property (nonatomic, copy) NSString *salesmoney;
@property (nonatomic, copy) NSString *salesmoneyshow;

@end

NS_ASSUME_NONNULL_END
