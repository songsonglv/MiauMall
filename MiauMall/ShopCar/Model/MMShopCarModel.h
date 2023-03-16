//
//  MMShopCarModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCarModel : NSObject
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *intetotal;
@property (nonatomic, copy) NSString *packprice;
@property (nonatomic, copy) NSString *Num1;
@property (nonatomic, copy) NSString *Total1;
@property (nonatomic, copy) NSString *_totalshow; //展示总价格
@property (nonatomic, copy) NSString *_totalactiveprice; //日元合计
@property (nonatomic, copy) NSString *_totalactivepriceshow;//展示的总价格 jpy
@property (nonatomic, copy) NSString *Intetotal1;
@property (nonatomic, copy) NSString *uptime;
@property (nonatomic, copy) NSString *Packprice1;
@property (nonatomic, copy) NSString *freefirst;
@property (nonatomic, copy) NSString *freefreight;
@property (nonatomic, copy) NSString *freefreightStr;//是否达到包邮门槛文案
@property (nonatomic, copy) NSString *freefreightStr2;
@property (nonatomic, copy) NSString *freefreightStrHead;//"满CNY 619.68包邮"
@property (nonatomic, copy) NSString *couponStr;
@property (nonatomic, copy) NSString *coupon;
@property (nonatomic, copy) NSString *offsetcash;
@property (nonatomic, copy) NSString *SpotCartTips;
@property (nonatomic, copy) NSString *isHaveNoStock;//是否有没有库存的商品
@property (nonatomic, copy) NSString *_totalweight;
@property (nonatomic, copy) NSString *PreSaleFinalStartTime;
@property (nonatomic, copy) NSString *PreSaleFinalEndTime;
@property (nonatomic, copy) NSString *_renxuantotal;
@property (nonatomic, copy) NSString *_renxuantotalsales;
@property (nonatomic, copy) NSString *_renxuantotalsalesshow;
@property (nonatomic, copy) NSString *_discountcode;//折扣码
@property (nonatomic, copy) NSString *_discounttotalsales;//实际优惠金额
@property (nonatomic, copy) NSString *_discounttotalsalesshow;//实际优惠展示
@property (nonatomic, copy) NSString *_totalsales; //总优惠 jpy
@property (nonatomic, copy) NSString *_totalsalesshow;//总优惠展示

@property (nonatomic, strong) NSArray *item;
@property (nonatomic, strong) NSArray *newitem;

@end

NS_ASSUME_NONNULL_END
