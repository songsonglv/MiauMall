//
//  ZTServerSecret.h
//  zhuantou
//
//  Created by 吕松松 on 2019/4/16.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZTServerSecret : NSObject
@property (nonatomic, strong) NSString *appapinterface;
@property (nonatomic, strong) NSString *approomno;
#pragma mark - md5 算法
+ (NSString *)md5:(NSString *)inputString;
- (NSString *)md5:(NSString *)str;
- (NSString *)md52:(NSString *)str;

//sha1加密
- (NSString *)sha1:(NSString *)str;
+ (NSString *)singstr;

//线上
+ (NSString *)loginAndRegisterSecretOnline:(NSString *)num;
//线下
+ (NSString *)loginAndRegisterSecretOffline:(NSString *)num;
+ (NSString *)loginAndRegisterSecret2:(NSString *)num;

//拼接字符串
+(NSString *)signStr:(NSDictionary*)dict andUrlstr:(NSString *)url;



//+ (NSString *)loginAndRegisterSecret3:(NSString *)num;
@end

