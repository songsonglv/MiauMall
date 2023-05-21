//
//  MMOrderLogisticsInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//  物流返回的所有信息 需要用到里面的地址信息和物流编号等信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderLogisticsInfoModel : NSObject
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *ExpressCompany;
@property (nonatomic, copy) NSString *ExpressLink;
@property (nonatomic, copy) NSString *ExpressNumber;
@property (nonatomic, copy) NSString *ExpressPhone;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *Picture1;
@property (nonatomic, copy) NSString *Picture2;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *ukmsg;
@property (nonatomic, copy) NSString *ShipmentInfo; //物流信息的具体内容 json的字符串需转为dic

@end

NS_ASSUME_NONNULL_END
