//
//  MMCouponInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//  优惠券

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMCouponInfoModel : NSObject
@property (nonatomic, copy) NSString *EndTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *OffsetCash;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *Summary;
@property (nonatomic, copy) NSString *TimeType;

@end

NS_ASSUME_NONNULL_END
