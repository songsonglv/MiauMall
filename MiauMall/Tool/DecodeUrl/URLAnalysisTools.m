//
//  URLAnalysisTools.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/6/18.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "URLAnalysisTools.h"

@implementation URLAnalysisTools

/**
 
 @property (nullable, readonly, copy) NSString *absoluteString;
 @property (readonly, copy) NSString *relativeString;
 @property (nullable, readonly, copy) NSURL *baseURL;
 @property (nullable, readonly, copy) NSURL *absoluteURL;
 @property (nullable, readonly, copy) NSString *scheme;
 @property (nullable, readonly, copy) NSString *resourceSpecifier;
 @property (nullable, readonly, copy) NSString *host;
 @property (nullable, readonly, copy) NSNumber *port;
 @property (nullable, readonly, copy) NSString *user;
 @property (nullable, readonly, copy) NSString *password;
 @property (nullable, readonly, copy) NSString *path;
 @property (nullable, readonly, copy) NSString *fragment;
 @property (nullable, readonly, copy) NSString *parameterString;
 @property (nullable, readonly, copy) NSString *query;
 @property (nullable, readonly, copy) NSString *relativePath;

 */
+(NSDictionary *)urlWithString:(NSString *)url{
    
    NSURL *urlBase = [NSURL URLWithString:url];
    
    //1.先按照‘&’拆分字符串
    NSArray *array0 = [urlBase.query componentsSeparatedByString:@"?"];
    NSArray *array = [array0[0] componentsSeparatedByString:@"&"];
    //2.初始化两个可变数组
    NSMutableArray *mutArrayKey = [[NSMutableArray alloc]init];
    NSMutableArray *mutArrayValue = [[NSMutableArray alloc]init];
    //3.以拆分的数组内容个数为准继续拆分数组，并将拆分的元素分别存到两个可变数组中
    for (int i=0; i<[array count]; i++) {
        NSArray *arr = [array[i] componentsSeparatedByString:@"="];
        [mutArrayKey addObject:arr[0]];
        if (arr.count > 1) {
            [mutArrayValue addObject:arr[1]];
        }
        
    }
    //4.初始化一个可变字典，并设置键值对
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:mutArrayValue forKeys:mutArrayKey];
    
    return @{@"scheme":urlBase.scheme?:@"",
             @"host":urlBase.host?:@"",
             @"port":urlBase.port?:@"",
             @"path":urlBase.path?:@"",
             @"query":dict};
    
}

@end
