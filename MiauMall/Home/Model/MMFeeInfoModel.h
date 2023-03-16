//
//  MMFeeInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//。运费

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMFeeInfoModel : NSObject
@property (nonatomic, copy) NSString *IsJNumber;
@property (nonatomic, copy) NSString *IsMoneyAll;
@property (nonatomic, copy) NSString *JNumber;
@property (nonatomic, copy) NSString *MoneyAll;
@property (nonatomic, copy) NSString *MoneyAllShow;
@end

NS_ASSUME_NONNULL_END
