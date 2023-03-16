//
//  ZTNetworking.h
//  zhuantou
//
//  Created by 吕松松 on 2019/4/16.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZTNetworking : NSObject

+ (AFHTTPSessionManager *)sharedManager;


+ (NSString*)convertToJSONData:(id)infoDict;

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData;

+(BOOL)testNetWork;

//基础post请求
+(void)postWithUrlstring:(NSString *)urlstring
                paramter:(id)paramter
                 success:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success
                 failure:(void (^)(NSError *error))failure;


+(void)cancleRequest;

+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;

+ (void)getHttpRequestURL:(NSString *)url RequestSuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success RequestFaile:(void(^)(NSError *error))faile;

+(void)FormDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;

+(void)FormDataGETRequestUrl:(NSString *)url ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(void)FormImageDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param RequestData:(NSData *)imageData ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;

+(void)FormVideoDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param RequestData:(NSData *)videoData ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;

+(void)PostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;

+(void)FormPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void (^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure;
@end


