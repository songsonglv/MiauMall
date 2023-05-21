//
//  MMOrderAddressModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderAddressModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *AreaAddress;
@property (nonatomic, copy) NSString *AreaName;
@property (nonatomic, copy) NSString *CityName;
@property (nonatomic, copy) NSString *Consignee;
@property (nonatomic, copy) NSString *ConsigneeLastName;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *IDCard;
@property (nonatomic, copy) NSString *MobilePhone;
@property (nonatomic, copy) NSString *PostalCode;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *StateName;
@property (nonatomic, copy) NSString *WeiXinCode;
@end

NS_ASSUME_NONNULL_END
