//
//  TCGetDeviceId.m
//  某某
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import "TCGetDeviceId.h"
#import "SSKeychain.h"
#import <UIKit/UIKit.h>
@implementation TCGetDeviceId

+ (NSString *)getDeviceId
{   
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

@end
