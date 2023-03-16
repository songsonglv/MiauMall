//
//  UIView+Controller.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/12/7.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)
- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
@end
