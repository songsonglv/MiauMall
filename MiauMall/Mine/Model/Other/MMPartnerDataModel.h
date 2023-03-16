//
//  MMPartnerDataModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/28.
//

#import <Foundation/Foundation.h>
#import "MMMemberInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerDataModel : NSObject
@property (nonatomic, copy) NSString *AVGMoneys;
@property (nonatomic, copy) NSString *KefuPicture;
@property (nonatomic, copy) NSString *MaxYongRate;
@property (nonatomic, copy) NSString *MinYongRate;
@property (nonatomic, copy) NSString *TeamConversionCount;
@property (nonatomic, copy) NSString *TeamConversionRate;
@property (nonatomic, copy) NSString *TeamMoneys;
@property (nonatomic, copy) NSString *TeamNum;
@property (nonatomic, copy) NSString *TeamOrderNum;
@property (nonatomic, copy) NSString *TeamRepurchaseCount;
@property (nonatomic, copy) NSString *TeamRepurchaseRate;
@property (nonatomic, copy) NSString *daifahuo;
@property (nonatomic, copy) NSString *daishouhuo;
@property (nonatomic, copy) NSString *shouhou;
@property (nonatomic, copy) NSString *yiwancheng;
@property (nonatomic, strong) MMMemberInfoModel *memberInfo;
@property (nonatomic, strong) NSArray *HotSales;
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
