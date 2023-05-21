//
//  ZTNetworking.m
//  zhuantou
//
//  Created by 吕松松 on 2019/4/16.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import "ZTNetworking.h"
#import "AFNetworking.h"
#import "DeleteNull.h"
#import "TCDeviceName.h"
#import "MMTabbarController.h"
#import "UIView+ACMediaExt.h"
static AFHTTPSessionManager *manager;
static NSMutableURLRequest *request;
@interface ZTNetworking()

@end

@implementation ZTNetworking


+(NSString *)convertToJSONData:(id)infoDict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    if (!jsonData) {
        NSLog(@"Got an error:%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉首位的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

+(void)PostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
    }];
}


+(void)postWithUrlstring:(NSString *)urlstring paramter:(id)paramter success:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlstring parameters:paramter headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
    }];
}

+(void)FormPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    KweakSelf(self);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"application/x-www-form-urlencoded", nil];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:(NSJSONWritingPrettyPrinted) error:&parseError];
        
        NSString *jsonStr =  [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
       
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if([code isEqualToString:@"120"]){
                NSLog(@"%@",url);
                MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
                loginVC.modalPresentationStyle = 0;
                [[self currentViewController] presentViewController:loginVC animated:YES completion:nil];
            }
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}


+(void)FormDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param ssuccess:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"application/x-www-form-urlencoded", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:param headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithFormData:data name:@""];
    }  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+(void)FormImageDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param RequestData:(NSData *)imageData ssuccess:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ///自定义http header 此处可省略
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    NSString *authorization;
    NSString *userId;
    NSString *deviceToken;
    NSString *deviceID;
    
    [manager POST:url parameters:param
          headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@".jpg" mimeType:@"image/png"];
    }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

+(void)FormVideoDataPostRequestUrl:(NSString *)url RequestPatams:(NSDictionary *)param RequestData:(NSData *)videoData ssuccess:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ///自定义http header 此处可省略
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    NSString *authorization;
    NSString *userId;
    NSString *deviceToken;
    NSString *deviceID;
    
    [manager POST:url parameters:param
          headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:videoData name:@"file" fileName:@".mp4" mimeType:@"video/mp4"];
    }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

/**
+(void)FormDataGETRequestUrl:(NSString *)url ssuccess:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ///自定义http header 此处可省略
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    NSString *authorization;
    NSString *userId;
    NSString *deviceToken;
    authorization = [userDefaulst valueForKey:@"authorization"];
    if ([authorization isEqualToString:@""] || authorization == nil || [authorization  isEqual: @""]) {
        [manager.requestSerializer setValue:@"authorization"forHTTPHeaderField:@""];
    }else{
        [manager.requestSerializer setValue:@"authorization"forHTTPHeaderField:authorization];
    }
    
    userId = [userDefaulst valueForKey:@"userId"];
    if ([userId isEqualToString:@""] || userId == nil || [userId  isEqual: @""]) {
        [manager.requestSerializer setValue:@"userId"forHTTPHeaderField:@""];
    }else{
        [manager.requestSerializer setValue:@"userId"forHTTPHeaderField:userId];
    }
    
    deviceToken = [userDefaulst valueForKey:@"deviceToken"];
       if ([deviceToken isEqualToString:@""] || deviceToken == nil || [deviceToken  isEqual: @""]) {
           [manager.requestSerializer setValue:@"deviceToken"forHTTPHeaderField:@""];
       }else{
           [manager.requestSerializer setValue:@"deviceToken"forHTTPHeaderField:deviceToken];
       }
    
    
    
    [manager.requestSerializer setValue:@"productModel"forHTTPHeaderField:[TCDeviceName getDeviceName]];
    [manager.requestSerializer setValue:@"device"forHTTPHeaderField:@"ios"];
    [manager.requestSerializer setValue:@"appVersion"forHTTPHeaderField:@"1.0.00"];
    [manager.requestSerializer setValue:@"brand" forHTTPHeaderField:@"APPLE"];
    [manager.requestSerializer setValue:@"source"forHTTPHeaderField:@"app"];
    
    manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithFormData:data name:@""];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
**/

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(void)cancleRequest{
    
}

//data转字典
+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData

{

if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {

return nil;

}

id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

if (![jsonObj isKindOfClass:[NSDictionary class]]) {

return nil;

}

return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];

}



+(void)testNetWork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //AFNetworkReachabilityStatus *state1;
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkConnect" object:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
//                [ZTProgressHUD showMessage:@"没有网络，请检查网络连接"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkConnect1" object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkConnect" object:nil];
                break;
                
            default:
                break;
                
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
    
}


//post异步请求封装函数

+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *, NSData *, NSError *))block{
    NSURL *url=[NSURL URLWithString:Url];
    
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    //转换dictionary为pos的string
    NSString *parseParmsResult = [self parseParams:params];
    NSData *postData=[parseParmsResult dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    
    //创建一个新队列（新线程）
   NSOperationQueue *queue= [NSOperationQueue new];
    //发送异步请求，请求完成以后返回的数据通过completionHandler参数调用
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:block];
}

/**Get请求
 
 url 服务器请求地址
 
 success 服务器响应返回的结果
 
 faile  失败的信息
 
 */

+ (void)getHttpRequestURL:(NSString *)url RequestSuccess:(void(^)(NSString *jsonStr, NSDictionary *jsonDic))success RequestFaile:(void(^)(NSError *error))faile{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ///自定义http header 此处可省略
//    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
//    NSString *authorization;
//    NSString *userId;
//    NSString *deviceToken;
//    NSString *deviceID;
//    authorization = [userDefaulst valueForKey:@"authorization"];
//    if ([authorization isEqualToString:@""] || authorization == nil || [authorization  isEqual: @""]) {
//        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"authorization"];
//    }else{
//        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"authorization"];
//    }
//
//    userId = [userDefaulst valueForKey:@"userId"];
//    if ([userId isEqualToString:@""] || userId == nil || [userId  isEqual: @""]) {
//        [manager.requestSerializer setValue:@""forHTTPHeaderField:@"userId"];
//    }else{
//        [manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
//    }
//
//    deviceToken = [userDefaulst valueForKey:@"deviceToken"];
//       if ([deviceToken isEqualToString:@""] || deviceToken == nil || [deviceToken  isEqual: @""]) {
//           [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"deviceToken"];
//       }else{
//           [manager.requestSerializer setValue:deviceToken forHTTPHeaderField:@"deviceToken"];
//       }
//
//    deviceID = [userDefaulst valueForKey:@"deviceID"];
//    if ([deviceID isEqualToString:@""] || deviceID == nil || [deviceID  isEqual: @""]) {
//        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"deviceId"];
//    }else{
//        [manager.requestSerializer setValue:deviceID forHTTPHeaderField:@"deviceId"];
//    }
//
//
//
//    [manager.requestSerializer setValue:[TCDeviceName getDeviceName] forHTTPHeaderField:@"productModel"];
//    [manager.requestSerializer setValue:@"ios"forHTTPHeaderField:@"device"];
//    [manager.requestSerializer setValue:@"3.0.00"forHTTPHeaderField:@"appVersion"];
//    [manager.requestSerializer setValue:@"APPLE" forHTTPHeaderField:@"brand"];
//    [manager.requestSerializer setValue:@"app"forHTTPHeaderField:@"source"];
//    [manager.requestSerializer setValue:@"antRebate" forHTTPHeaderField:@"channel"];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//放弃解析
    
    ///自定义http header 此处可省略
    
    /// [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    
    /// [manager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    
    /// [manager.requestSerializer setValue:@"http header" forHTTPHeaderField:@"XiaoGuiGe"];
    
    
    
    [manager GET:url parameters:nil  headers:nil  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSDictionary *dic = [ZTNetworking dictionaryWithJsonString:jsonStr];
            success(jsonStr, [DeleteNull changeType:dic]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//把NSDictionary转换成post格式的NSString

+ (NSString *)parseParams:(NSDictionary *)params{
    
    NSString *keyValueFormat;
    
    NSMutableString *result=[NSMutableString new];
    
    //实例化一个key枚举器来存放dictionary的key
    
    NSEnumerator *keyEnum=[params keyEnumerator];
    
    id key;
    
    while (key=[keyEnum nextObject]) {
        
        keyValueFormat=[NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        
        [result appendString:keyValueFormat];
        
        NSLog(@"post()方法post参数:%@",result);
        
    }
    
    return result;
    
}


//对后台返回错误进行解析

//字典转字符串
-(NSString *)dicToJSon:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:(NSJSONWritingPrettyPrinted) error:&parseError];
    
    return  [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/**
 *          获取当前控制器
 */
+(UIViewController*) currentViewController {
    
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self atPersentViewController:viewController];
}

+(UIViewController*)atPersentViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
         
        
        return [self atPersentViewController:vc.presentedViewController];
         
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
         
        
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.viewControllers.lastObject];
        else
            return vc;
         
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
         
        
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.topViewController];
        else
            return vc;
         
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
         
        
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.selectedViewController];
        else
            return vc;
         
    } else {
        return vc;
         
    }
     
}

@end
