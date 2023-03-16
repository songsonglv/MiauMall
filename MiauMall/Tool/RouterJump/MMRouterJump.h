//
//  MMRouterJump.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//

#import <Foundation/Foundation.h>
#import "MMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRouterJump : NSObject

+(MMBaseViewController *)jumpToRouters:(NSString *)routers;

@end

NS_ASSUME_NONNULL_END
