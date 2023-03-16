//
//  MMOrderDetailInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderDetailInfoModel : NSObject
@property (nonatomic, copy) NSString *MoneysShow;
@property (nonatomic, copy) NSString *PayStatus;
@property (nonatomic, copy) NSString *GetCouponID;
@property (nonatomic, strong) NSArray *itemlist;
@property (nonatomic, copy) NSString *ExpressPhone;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *DiscRule;
@property (nonatomic, copy) NSString *RemotelyMoney;
@property (nonatomic, copy) NSString *_Processing;//订单状态
@property (nonatomic, copy) NSString *OtherPay;
@property (nonatomic, copy) NSString *LevelMoneys;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Payment;//支付方式
@property (nonatomic, copy) NSString *Freight; //运费
@property (nonatomic, copy) NSString *runid;
@property (nonatomic, copy) NSString *DiscRuleShow;
@property (nonatomic, copy) NSString *Processing;
@property (nonatomic, copy) NSString *RemotelyShortName;
@property (nonatomic, copy) NSString *Discount;
@property (nonatomic, copy) NSString *CanRefundItem;
@property (nonatomic, copy) NSString *Moneys;
@property (nonatomic, copy) NSString *UseInteg;
@property (nonatomic, copy) NSString *PackNum;
@property (nonatomic, copy) NSString *CanAssessOrder;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *BuyNum;
@property (nonatomic, copy) NSString *CanCancelItem;
@property (nonatomic, copy) NSString *SignMoneyShow;
@property (nonatomic, copy) NSString *CanRefundMoney;
@property (nonatomic, copy) NSString *FreightShow;
@property (nonatomic, copy) NSString *ExpressLink;
@property (nonatomic, copy) NSString *OrderType;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *MobilePhone;

@property (nonatomic, copy) NSString *GiftMoneyShow;
@property (nonatomic, strong) NSDictionary *DeliAddress;
@property (nonatomic, strong) NSArray *tracklist;
@property (nonatomic, copy) NSString *Transactions;//交易方式
@property (nonatomic, copy) NSString *RemotelyTips;
@property (nonatomic, copy) NSString *CanCancelMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *GiftMoney;
@property (nonatomic, copy) NSString *CanReceiptOrder;
@property (nonatomic, copy) NSString *Integration;
@property (nonatomic, copy) NSString *OtherPayShow;
@property (nonatomic, copy) NSString *OrderInte;
@property (nonatomic, copy) NSString *CanResult;
@property (nonatomic, copy) NSString *Consignee;
@property (nonatomic, copy) NSString *PartialBalance;
@property (nonatomic, copy) NSString *payState;//支付状态
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PartialBalanceShow;
@property (nonatomic, copy) NSString *OldPayMoney;
@property (nonatomic, copy) NSString *DiscountShow;//优惠券折扣
@property (nonatomic, copy) NSString *ShippingId;
@property (nonatomic, copy) NSString *DiscountMoneysShow; //折扣码优惠
@property (nonatomic, copy) NSString *SignMoney;
@property (nonatomic, copy) NSString *CanAddress;
@property (nonatomic, copy) NSString *CanPay;
@property (nonatomic, copy) NSString *LevelMoneysShow;//段位折扣
@property (nonatomic, copy) NSString *ItemMoneyShow;
@property (nonatomic, copy) NSString *CanCancel;
@property (nonatomic, copy) NSString *RemotelyMoneyShow;
@property (nonatomic, copy) NSString *CanTips;
@property (nonatomic, copy) NSString *ItemMoney;
@property (nonatomic, copy) NSString *ColumnID;
@property (nonatomic, copy) NSString *DiscountMoneys;
@property (nonatomic, copy) NSString *CanExpress;
@property (nonatomic, copy) NSString *AddTime;//下单时间
@property (nonatomic, copy) NSString *IntegrationShow;//积分优惠
@property (nonatomic, copy) NSString *AllState; //0 待发货 1 代收获 2 已完成 3 已退款 4 已退货 5 已取消 6 仓库打包中 7 定金已支付 10 售后 20 发货 待收货

@end

NS_ASSUME_NONNULL_END
