//
//  NSString+AES256.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+AES256.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES256)
-(NSString *) aes256_encrypt:(NSString*)key;// 加密
-(NSString *) aes256_decrypt:(NSString *)key;// 解密
@end

NS_ASSUME_NONNULL_END
