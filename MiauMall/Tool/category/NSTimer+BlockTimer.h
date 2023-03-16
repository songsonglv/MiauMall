//
//  NSTimer+BlockTimer.h
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/12/16.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (BlockTimer)
+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats blockTimer:(void (^)(NSTimer *))block;

+ (void)timered:(NSTimer*)timer;
@end

NS_ASSUME_NONNULL_END
