//
//  AESCipher.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESCipher : NSObject
+(NSString*)aesEncryptString:(NSString *)content;

+(NSString*)aesDecryptString:(NSString*)content;

+(NSString *)aesEncryptString:(NSString *)content withKey:(NSString *)key withIv:(NSString*)iv;

+(NSString *)aesDecryptString:(NSString *)content withKey:(NSString *)key withIv:(NSString*)iv;

@end

NS_ASSUME_NONNULL_END
