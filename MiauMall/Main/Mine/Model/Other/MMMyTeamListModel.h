//
//  MMMyTeamListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMMyTeamListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *IsSales;
@property (nonatomic, copy) NSString *IsShowSales;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *SalesLevel;
@property (nonatomic, copy) NSString *SalesName;
@property (nonatomic, copy) NSString *SalesNameStr;
@property (nonatomic, copy) NSString *SalesTime;
@property (nonatomic, copy) NSString *SubYongRate;
@property (nonatomic, copy) NSString *TeamConversionRate;
@property (nonatomic, copy) NSString *TeamRepurchaseRate;
@property (nonatomic, copy) NSString *ToDayMoney;
@property (nonatomic, copy) NSString *TotalMoney;
@property (nonatomic, copy) NSString *TotalOrder;
@property (nonatomic, copy) NSString *YongRate;
@end

NS_ASSUME_NONNULL_END
