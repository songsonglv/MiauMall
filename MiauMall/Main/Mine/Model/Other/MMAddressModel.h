//
//  MMAddressModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAddressModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ColumnID;
@property (nonatomic, copy) NSString *OrderID;
@property (nonatomic, copy) NSString *IsCheck;
@property (nonatomic, copy) NSString *IsDel;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Consignee;
@property (nonatomic, copy) NSString *MobilePhone;
@property (nonatomic, copy) NSString *Telephone;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *PostalCode;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *IsDefault;
@property (nonatomic, copy) NSString *MemberID;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *ShortName;
@property (nonatomic, copy) NSString *AreaName;
@property (nonatomic, copy) NSString *AreaIds;
@property (nonatomic, copy) NSString *DeliveryTime;
@property (nonatomic, copy) NSString *Longitude;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *AdminId;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *CountryID;
@property (nonatomic, copy) NSString *Area;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *IDCard;
@property (nonatomic, copy) NSString *CityName;
@property (nonatomic, copy) NSString *StateName;
@property (nonatomic, copy) NSString *WeiXinCode;
@property (nonatomic, copy) NSString *ConsigneeLastName;
@property (nonatomic, copy) NSString *Country;
@property (nonatomic, copy) NSString *City;
@property (nonatomic, copy) NSString *AreaIds_Bind;
@property (nonatomic, copy) NSString *MemberID_Bind;
@property (nonatomic, copy) NSString *IsCheck_Bind;
@property (nonatomic, copy) NSString *IsDefault_Bind;
@end

NS_ASSUME_NONNULL_END
