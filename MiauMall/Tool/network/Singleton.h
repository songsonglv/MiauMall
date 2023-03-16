//
//  Singleton.h
//  SpareTime
//
//  Created by 吕松松 on 2020/5/14.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>

#define singleton_Interface(class)  + (class *)share##class;

#define singleton_implemetntion(class)\
static class * instance = nil;\
+ (class *)share##class\
{\
if (!instance) {\
instance = [[class alloc]init];\
}\
return instance;\
}\
+ (class *)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onece;\
dispatch_once(&onece, ^{\
instance = [super allocWithZone:zone];\
});\
return instance;\
}
@interface Singleton : NSObject

@end

