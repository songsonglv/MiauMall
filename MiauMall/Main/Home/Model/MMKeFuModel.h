//
//  MMKeFuModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/16.
//

#import <Foundation/Foundation.h>
#import "MMMemberInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMKeFuModel : NSObject
@property (nonatomic, copy) NSString *IsMeiQia;
@property (nonatomic, copy) NSString *SalesCount;
@property (nonatomic, copy) NSString *SalesMoney;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *LastOrderID; //最新订单ID
@property (nonatomic, strong) MMMemberInfoModel *memInfo;
@end

NS_ASSUME_NONNULL_END
