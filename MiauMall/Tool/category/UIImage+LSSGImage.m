//
//  UIImage+LSSGImage.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/5/22.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "UIImage+LSSGImage.h"

#import <UIKit/UIKit.h>


@implementation UIImage (LSSGImage)
+ (UIImage *)originImageWithName: (NSString *)name {
    
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

// 绘制圆角
- (void)Lss_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *))completion{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1.利用绘图
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 2.设置填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        
        // 3. 利用 贝塞尔路径 ‘裁切’ 效果
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        // 4.绘制图像
        [self drawInRect:rect];
        
        // 5.取得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();
        
        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion != nil){
                completion(result);
            }
            
        });
        
    });
    
}


@end
