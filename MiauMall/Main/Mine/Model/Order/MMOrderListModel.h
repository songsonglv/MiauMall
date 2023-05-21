//
//  MMOrderListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderListModel : NSObject
@property (nonatomic, copy) NSString *CanTips; //提醒发货
@property (nonatomic, copy) NSString *CanReceiptOrder; //确认收货
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *CanResult; //查看结果 待定
@property (nonatomic, copy) NSString *ColumnID; //804很特殊不知道是什么
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *CanRefundItem; //退款
@property (nonatomic, copy) NSString *PackNum; //不太清楚
@property (nonatomic, copy) NSString *CanRefundMoney;//可退款金额
@property (nonatomic, copy) NSString *CanExpress;//查看物流
@property (nonatomic, copy) NSString *Moneys;
@property (nonatomic, copy) NSString *CanAssessOrder; //去评价
@property (nonatomic, copy) NSString *MoneysShow;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *BuyNum;

@property (nonatomic, copy) NSString *CanCancelItem; //订单退货

@property (nonatomic, copy) NSString *IntCount;
@property (nonatomic, copy) NSString *Processing; //
@property (nonatomic, copy) NSString *CanCancelMoney; //可取消的钱
@property (nonatomic, copy) NSString *CanPay; //去支付
@property (nonatomic, copy) NSString *CanAddCart;//加购物车
@property (nonatomic, copy) NSString *Discount;//优惠金额
@property (nonatomic, copy) NSString *DiscountMoneys;//优惠金额
@property (nonatomic, copy) NSString *DiscountMoneysShow;//优惠金额
@property (nonatomic, copy) NSString *DiscountShow;//优惠金额
@property (nonatomic, strong) NSArray *itemlist;//商品列表
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PriceCountRMB;
@property (nonatomic, copy) NSString *CanAddress; //修改地址
@property (nonatomic, copy) NSString *EstimatedShipment; //预计发货时间展示
@property (nonatomic, copy) NSString *CanCancel; //待支付状态下可取消
@property (nonatomic, copy) NSString *ExpressLink; //物流链接
@property (nonatomic, copy) NSString *PriceCount;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *chaidanName;//目前没见过这个字段
@property (nonatomic, copy) NSString *ShowState;//订单状态展示
@property (nonatomic, copy) NSString *AllState;//订单状态 新增 0 未处理 1已发货 2已完成 3已退款 4已退货 5已取消 6仓库打包中 7 定金已支付 10售后 20发货
@property (nonatomic, copy) NSString *OnlyRenXuanTotal;//任选优惠
@property (nonatomic, copy) NSString *OnlyRenXuanTotalShow; //任选优惠币价格
@property (nonatomic, copy) NSString *CanAfterSalesEvaluation;//是否显示售后评价
@property (nonatomic, copy) NSString *CanDeleteOrder;//是否显示删除订单按钮

@property (nonatomic, strong) NSString *isShow;//默认0 选中后为1
@end

NS_ASSUME_NONNULL_END
