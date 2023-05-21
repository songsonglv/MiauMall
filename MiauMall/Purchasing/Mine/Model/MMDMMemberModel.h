//
//  MMDMMemberModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMMemberModel : NSObject
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *CurrencyImg;
@property (nonatomic, copy) NSString *HeadImg;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Integral;
@property (nonatomic, copy) NSString *IntegralStr;
@property (nonatomic, copy) NSString *IntegralTips;
@property (nonatomic, copy) NSString *IsClickToday;
@property (nonatomic, copy) NSString *IsTest;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *NewCount;
@property (nonatomic, strong) NSMutableArray *ReadyPayModels;
@end

NS_ASSUME_NONNULL_END
