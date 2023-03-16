//
//  MMEditAccountModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMEditAccountModel : NSObject
@property (nonatomic, copy) NSString *AccountBank;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *AccountName;
@property (nonatomic, copy) NSString *AccountNo;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, strong) NSDictionary *account;
@end

NS_ASSUME_NONNULL_END
