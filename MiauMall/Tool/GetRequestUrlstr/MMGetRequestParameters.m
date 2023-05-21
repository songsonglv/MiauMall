//
//  MMGetRequestParameters.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMGetRequestParameters.h"

@implementation MMGetRequestParameters
/**
 处理Get请求URL

 @param url 请求链接
 @param params 请求参数
 @return 请求链接
 */
+(NSString *)getURLForInterfaceStringDefine:(NSString *)url params:(NSDictionary *)params {
    // 判空
    if (!url && !url.length) {
        return @"";
    }
    // 创建
    NSString *resultUrl = url;

    if(params){
        NSArray *keys = [params allKeys];
        
        for(int i = 0; i < keys.count ; i++){
            NSString *key = keys[i];
            NSString *value = params[key];
            if(i == 0){
                resultUrl = [NSString stringWithFormat:@"%@?%@=%@",resultUrl,key,value];
            }else{
                resultUrl = [NSString stringWithFormat:@"%@&%@=%@",resultUrl,key,value];
            }
        }
    }
    
    return resultUrl;
                                          
}
@end
