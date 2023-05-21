//
//  MMRefundResultModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/19.
//  售后结果数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMRefundResultModel : NSObject
@property (nonatomic, copy) NSString *Application;
@property (nonatomic, copy) NSString *CanCancelItem;
@property (nonatomic, copy) NSString *CanCancelMoney;
@property (nonatomic, copy) NSString *HandleTime;
@property (nonatomic, copy) NSString *OrderNumber;
@property (nonatomic, copy) NSString *RefundEmail;
@property (nonatomic, copy) NSString *RefundReason;
@property (nonatomic, copy) NSString *RefundStatus;
@property (nonatomic, copy) NSString *RefundWeixin;
@property (nonatomic, copy) NSString *Steps;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray *itemlist;
@property (nonatomic, strong) NSArray *tracklist;
@end

NS_ASSUME_NONNULL_END
