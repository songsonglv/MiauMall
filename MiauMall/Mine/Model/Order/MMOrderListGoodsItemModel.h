//
//  MMOrderListGoodsItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderListGoodsItemModel : NSObject
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Attribute;
@property (nonatomic, copy) NSString *ShortName;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Moneys;
@property (nonatomic, copy) NSString *IntSingle;
@property (nonatomic, copy) NSString *IntTotal;
@property (nonatomic, copy) NSString *ItemID;
@property (nonatomic, copy) NSString *BColumnID;
@property (nonatomic, copy) NSString *AttributeID;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *DeliverTips;
@property (nonatomic, copy) NSString *ShipTimeTips;
@property (nonatomic, copy) NSString *IsFullGift;
@property (nonatomic, copy) NSString *OptionalID;
@property (nonatomic, copy) NSString *OptionalName;
@property (nonatomic, copy) NSString *MoneysShow;
@property (nonatomic, copy) NSString *MoneysRMB;
@property (nonatomic, copy) NSString *PriceShow;
@property (nonatomic, copy) NSString *PriceRMB;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *SalesMoney;//实付价
@property (nonatomic, copy) NSString *SalesMoneyShow;//实付价展示
@property (nonatomic, copy) NSString *SalesMoneyRMB; //实际付款的人民币金额
@end

NS_ASSUME_NONNULL_END
