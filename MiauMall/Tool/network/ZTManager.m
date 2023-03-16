//
//  ZTManager.m
//  zhuantou
//
//  Created by 吕松松 on 2019/4/16.
//  Copyright © 2019 吕松松. All rights reserved.
//创建单例

#import "ZTManager.h"
static AFHTTPSessionManager *manager;

@implementation ZTManager
+(AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

//网络类初始化
- (id)init{
    self = [super init];
    if(self)
    {
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}



@end
