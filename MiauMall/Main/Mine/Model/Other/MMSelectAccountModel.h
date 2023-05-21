//
//  MMSelectAccountModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectAccountModel : NSObject
@property (nonatomic, strong) NSDictionary *AccountModel;
@property (nonatomic, copy) NSString *Extract;
@property (nonatomic, copy) NSString *ExtractFees;
@property (nonatomic, copy) NSString *YongBalance;
@end

NS_ASSUME_NONNULL_END
