//
//  MMGoodsSpecModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//  商品详情里面的规格信息最外层

#import <Foundation/Foundation.h>
#import "MMGoodsAttdataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsSpecModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *PreSaleAgreementName;
@property (nonatomic, copy) NSString *ActivePriceShowPrice;
@property (nonatomic, copy) NSString *DepositStartTime;
@property (nonatomic, copy) NSString *ColumnID;
@property (nonatomic, copy) NSString *HaveAttribute;
@property (nonatomic, strong) NSArray *attdatas; //显示出来的item对应的信息 使用attr与name对应
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *attlist; //规格一共几层 就有几个元素 基本一层
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *DepositMoney;
@property (nonatomic, copy) NSString *PreSaleAgreementConts;
@property (nonatomic, copy) NSString *code; //接口是否成功 1成功 其他 失败 失败会有msg
@property (nonatomic, copy) NSString *attr;
@property (nonatomic, copy) NSString *FinalPayEndTime;
@property (nonatomic, copy) NSString *DepositEndTime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *LimtOrderBuy;
@property (nonatomic, copy) NSString *ActivePrice;
@property (nonatomic, copy) NSString *PreSaleType;
@property (nonatomic, copy) NSString *TotalPriceShow;
@property (nonatomic, copy) NSString *Shipping48; //48小时内发货
@property (nonatomic, copy) NSString *Shipping828; //48小时内发货
@property (nonatomic, copy) NSString *DepositMoneyShow;
@property (nonatomic, copy) NSString *IsCanReturn;
@property (nonatomic, copy) NSString *Swell;
@property (nonatomic, copy) NSString *Weight;
@property (nonatomic, copy) NSString *IsFullGift;
@property (nonatomic, strong) NSArray *attsdatas;//目前看来与attdatas字段相同
@property (nonatomic, copy) NSString *ActivePriceShowSign;
@property (nonatomic, copy) NSString *FinalPayStartTime;
@property (nonatomic, strong) MMGoodsAttdataModel *attbuying; //应该是选中规格的数据 不确定 再看看
@property (nonatomic, copy) NSString *TotalPrice;
@property (nonatomic, copy) NSString *MeitongTips;
@property (nonatomic, copy) NSString *ActivePriceShow;
@property (nonatomic, copy) NSString *Precautions;

@end

NS_ASSUME_NONNULL_END
