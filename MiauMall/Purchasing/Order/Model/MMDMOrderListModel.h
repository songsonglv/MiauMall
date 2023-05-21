//
//  MMDMOrderListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *BuyNum;
@property (nonatomic, copy) NSString *PayMoney;
@property (nonatomic, copy) NSString *PayMoneyShow;
@property (nonatomic, copy) NSString *PaySignMoney;
@property (nonatomic, copy) NSString *ItemMoney;
@property (nonatomic, copy) NSString *ItemMoneyShow;
@property (nonatomic, copy) NSString *RefundLuJing;
@property (nonatomic, copy) NSString *Processing;
@property (nonatomic, copy) NSString *ProcessingState;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *IsPhote;
@property (nonatomic, copy) NSString *CustodyDay;
@property (nonatomic, copy) NSString *CheckTimeStamp;
@property (nonatomic, copy) NSString *CanAssessOrder;
@property (nonatomic, copy) NSString *CanCancel;
@property (nonatomic, copy) NSString *CanFirstPay;
@property (nonatomic, copy) NSString *CanLastPay;
@property (nonatomic, copy) NSString *CanRefundMoney;
@property (nonatomic, copy) NSString *CanPhoto;
@property (nonatomic, copy) NSString *CanResult;
@property (nonatomic, copy) NSString *CanDeleteOrder;//删除按钮的显示判断
@property (nonatomic, copy) NSString *CanCompleteOrder;//确认收货
@property (nonatomic, copy) NSString *CanShowTrack;//查看物流
@property (nonatomic, strong) NSMutableArray *OrderProducts;

@end

NS_ASSUME_NONNULL_END
