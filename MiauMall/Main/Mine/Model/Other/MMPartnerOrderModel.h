//
//  MMPartnerOrderModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerOrderModel : NSObject
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *BindOrder;
@property (nonatomic, copy)NSString *Name;
@property (nonatomic, copy)NSString *Picture;
@property (nonatomic, copy)NSString *ItemID;
@property (nonatomic, copy)NSString *ChildName;
@property (nonatomic, copy)NSString *MyLevel;
@property (nonatomic, copy)NSString *OrderNumber;
@property (nonatomic, copy)NSString *MyYongMoney;
@property (nonatomic, copy)NSString *AddTime;
@property (nonatomic, copy)NSString *Processing;
@property (nonatomic, copy)NSString *FatherName;
@end

NS_ASSUME_NONNULL_END
