//
//  ZTServerSecret.m
//  zhuantou
//
//  Created by 吕松松 on 2019/4/16.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import "ZTServerSecret.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZTServerSecret
+ (NSString *)singstr
{
    ZTServerSecret *tc = [[ZTServerSecret alloc]init];
    NSString *s = @"m=12&mid=120&oid=291&p=3&timestamp=1513417786&token=xfsdfafsfds&secret=*G0^Z!eGOCh2Tf04";
    NSString *str = [tc sha1:s];
    NSLog(@"%@",str);
    return str;
}
////线上
//+ (NSString *)loginAndRegisterSecretOnline:(NSString *)num{
//    ZTServerSecret *tc = [[ZTServerSecret alloc]init];
//    NSString *s = [NSString stringWithFormat:@"*G0^Z!eGOCh2Tf04"];
//    //NSString *str = [tc md52:[tc md5:s]];
//    NSString *str = [tc sha1:s];
//    NSString *str1 = [[NSString stringWithFormat:@"https://uapi.moumou001.com/interface?actionId=%@&timestamp=%@", num,[TCGetTime getCurrentTime]] stringByAppendingString:@"&sign&"];
//    NSLog(@"%@",str1);
//    return [str1 stringByAppendingString:str];
//    NSLog(@"%@",[str1 stringByAppendingString:str]);
//}

//线下
//+ (NSString *)loginAndRegisterSecretOffline:(NSString *)num
//{
//    //    TCServerSecret *tc = [[TCServerSecret alloc]init];
//    //    NSString *s = [[NSString stringWithFormat:@"pfMXE7YQQVmaXBhr%@", num]stringByAppendingString:@"mmapi2016"];
//    //    NSString *s = [NSString stringWithFormat:@"*G0^Z!eGOCh2Tf04"];
//    //    NSString *str = [tc md52:[tc md5:s]];
//    //当前时间戳
//    //signhttp://192.168.1.2/userapi/web/
//    //https://uapi.moumou001.com/
//    //    NSString *str = [tc sha1:s];
//    NSString *str1 = [NSString stringWithFormat:@"https://uapi.moumou001.com/interface?actionId=%@&", num];
//
//    //    NSString *string = [str1 stringByAppendingFormat:@"&timestamp=%@&sign=%@",[TCGetTime getCurrentTime], str];
//
//    return str1;
//    NSLog(@"%@",str1);
//}

//+ (NSString *)loginAndRegisterSecret2:(NSString *)num{
//    TCServerSecret *tc = [[TCServerSecret alloc]init];
//    NSString *s = [[NSString stringWithFormat:@"pfMXE7YQQVmaXBhr%@", num]stringByAppendingString:@"mmapi2016"];
//    NSString *str = [tc md52:[tc md5:s]];
//    NSString *str1 = [[NSString stringWithFormat:@"https://api2.moumou001.com/interface/?actionid=%@", num]stringByAppendingString:@"&secretString="];
//    return [str1 stringByAppendingString:str];
//}

//一次加密
- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];
}

//二次加密
- (NSString *)md52:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",    // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];
}

//sha1加密
- (NSString *)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
    
}

//拼接字符串
+(NSString *)signStr:(NSDictionary*)dict andUrlstr:(NSString *)url
{
    NSMutableDictionary * mutDic2 = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSMutableString *contentString  =[NSMutableString string];
    NSString *signStr;
    NSArray *keys = [mutDic2 allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (int i = 0; i < sortedArray.count; i++) {
        NSString *str = mutDic2[sortedArray[i]];
        [mudic setObject:str forKey:sortedArray[i]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mudic
                                                       options:NSJSONWritingPrettyPrinted
                                                    error:nil];
     
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    

    NSString *timestamp = [ZTBSUtils getCurrentTimes];

    NSString *jsonStr1 = [NSString stringWithFormat:@"timestamp%@%@",timestamp,str];
    NSString *md5Str = [ZTServerSecret md5:jsonStr1].uppercaseString;
    //signStr = [md5Str uppercaseString];
   // signStr = [NSString stringWithFormat:@"%s%@?timestamp=%@&sign=%@",Base,url,timestamp,md5Str];
    //拼接字符串
    
//    for (int i = 0; i < sortedArray.count; i++) {
//        NSString *categoryId = sortedArray[i];
//
//         if (![[mutDic2 objectForKey:categoryId] isEqualToString:@""]
//                    && ![[mutDic2 objectForKey:categoryId] isEqualToString:@"sign"]
//                    && ![[mutDic2 objectForKey:categoryId] isEqualToString:@"key"]
//                    )
//                {
//                    if (i == sortedArray.count - 1) {
//                        [contentString appendFormat:@"%@=%@", categoryId, [mutDic2 objectForKey:categoryId]];
//                    }else{
//                        [contentString appendFormat:@"%@=%@&", categoryId, [mutDic2 objectForKey:categoryId]];
//                    }
//
//        //            NSString * jointStr= [contentString stringByAppendingString:@"secret=*G0^Z!eGOCh2Tf04"];
//        //            NSLog(@"%@",jointStr);
//
//
//                    signStr = [ZTServerSecret md5:contentString];
//
//
//        //            signStr = [NSString sha1:jointStr];
//        //            NSLog(@"%@ %@",signStr,jointStr);
//                }
//    }
//    for (NSString *categoryId in sortedArray) {
//        
//        if (![[mutDic2 objectForKey:categoryId] isEqualToString:@""]
//            && ![[mutDic2 objectForKey:categoryId] isEqualToString:@"sign"]
//            && ![[mutDic2 objectForKey:categoryId] isEqualToString:@"key"]
//            )
//        {
//            [contentString appendFormat:@"%@=%@&", categoryId, [mutDic2 objectForKey:categoryId]];
////            NSString * jointStr= [contentString stringByAppendingString:@"secret=*G0^Z!eGOCh2Tf04"];
////            NSLog(@"%@",jointStr);
//            
//            signStr = [ZTServerSecret md5:contentString];
//            
////            signStr = [NSString sha1:jointStr];
////            NSLog(@"%@ %@",signStr,jointStr);
//        }
//    }
    return signStr;
}



#pragma mark - md5 算法
+ (NSString *)md5:(NSString *)inputString{
    const char *cStr = [inputString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
@end
