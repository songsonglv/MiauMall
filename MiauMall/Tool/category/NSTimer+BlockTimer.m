//
//  NSTimer+BlockTimer.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/12/16.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "NSTimer+BlockTimer.h"

@implementation NSTimer (BlockTimer)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats blockTimer:(void (^)(NSTimer *))block{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timered:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+(void)timered:(NSTimer *)timer{
    void (^block)(NSTimer *timer)  = timer.userInfo;
        block(timer);
}

@end
