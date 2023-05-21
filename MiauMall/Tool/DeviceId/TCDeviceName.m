//
//  TCDeviceName.m
//  顺道嘉(新)
//
//  Created by 胡高广 on 2017/11/3.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "TCDeviceName.h"
#import "sys/utsname.h"
@implementation TCDeviceName


+ (NSString *)getDeviceName {
    
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if([deviceString isEqualToString:@"iPhone12,1"])return@"iPhone 11";
    if([deviceString isEqualToString:@"iPhone12,3"])return@"iPhone 11 Pro Max";
    if([deviceString isEqualToString:@"iPhone12,5"])return@"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,8"]) return @"iPhone SE(2nd generation)";
        if ([deviceString isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
        if ([deviceString isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
        if ([deviceString isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
        if ([deviceString isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
        if ([deviceString isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
        if ([deviceString isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
        if ([deviceString isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
        if ([deviceString isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
        if ([deviceString isEqualToString:@"iPhone14,6"]) return @"iPhone SE (3rd generation)";
        if ([deviceString isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
        if ([deviceString isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
        if ([deviceString isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
        if ([deviceString isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";

    
    return  deviceString;
}

@end
