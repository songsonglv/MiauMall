//
//  MMDMOrderDetailModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderDetailModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *BuyNum;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PaySignMoney;
@property (nonatomic, copy) NSString *ItemMoney;
@property (nonatomic, copy) NSString *ItemMoneyShow;
@property (nonatomic, copy) NSString *JapanFreight;
@property (nonatomic, copy) NSString *JapanFreightShow;
@property (nonatomic, copy) NSString *Freight;
@property (nonatomic, copy) NSString *FreightShow;
@property (nonatomic, copy) NSString *PartialBalance;
@property (nonatomic, copy) NSString *PartialBalanceShow;
@property (nonatomic, copy) NSString *OtherPay;
@property (nonatomic, copy) NSString *OtherPayShow;
@property (nonatomic, copy) NSString *TotalProductMoney;
@property (nonatomic, copy) NSString *TotalProductMoneyShow;

@property (nonatomic, copy) NSString *TotalHandingMoney;
@property (nonatomic, copy) NSString *TotalHandingMoneyShow;
@property (nonatomic, copy) NSString *TotalSureMoney;
@property (nonatomic, copy) NSString *TotalSureMoneyShow;
@property (nonatomic, copy) NSString *TotalPhotoMoney;
@property (nonatomic, copy) NSString *TotalPhotoMoneyShow;
@property (nonatomic, copy) NSString *ReinforcementMoney;
@property (nonatomic, copy) NSString *ReinforcementMoneyShow;

@property (nonatomic, copy) NSString *SupplementaryMoney;
@property (nonatomic, copy) NSString *SupplementaryMoneyShow;
@property (nonatomic, copy) NSString *CustodyMoney;
@property (nonatomic, copy) NSString *CustodyMoneyShow;
@property (nonatomic, copy) NSString *NoPurchasingReason;
@property (nonatomic, strong) NSMutableArray *PhotoPicture;
@property (nonatomic, copy) NSString *Weight;
@property (nonatomic, copy) NSString *RateTips;

@property (nonatomic, copy) NSString *RefundLuJing;
@property (nonatomic, copy) NSString *Processing;
@property (nonatomic, copy) NSString *ProcessingState;
@property (nonatomic, copy) NSString *Payment;
@property (nonatomic, copy) NSString *PayStatus;
@property (nonatomic, copy) NSString *Consignee;
@property (nonatomic, copy) NSString *MobilePhone;
@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *UseIntegShow;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *IsPhote;
@property (nonatomic, copy) NSString *PhoteTips;
@property (nonatomic, copy) NSString *CustodyDay;
@property (nonatomic, copy) NSString *CheckTimeStamp;

@property (nonatomic, copy) NSString *CanAssessOrder;//评价订单
@property (nonatomic, copy) NSString *CanRefundMoney;//申请退款
@property (nonatomic, copy) NSString *CanResult;//处理结果
@property (nonatomic, copy) NSString *CanPhoto;//拍照申请
@property (nonatomic, copy) NSString *CanFirstPay;//付定金
@property (nonatomic, copy) NSString *CanLastPay;//选择物流
@property (nonatomic, copy) NSString *CanCancel;//取消订单
@property (nonatomic, copy) NSString *CanDeleteOrder;//删除订单展示
@property (nonatomic, copy) NSString *CanShowTrack;//查看物流展示
@property (nonatomic, copy) NSString *CanCompleteOrder;//确认收货展示

@property (nonatomic, strong) NSMutableArray *OrderProducts;
@property (nonatomic, strong) NSMutableArray *OrderTracks;
@end

NS_ASSUME_NONNULL_END
