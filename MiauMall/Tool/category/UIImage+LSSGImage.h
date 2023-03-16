//
//  UIImage+LSSGImage.h
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/5/22.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LSSGImage)
// 加载最原始的图片，没有渲染
+ (UIImage *)originImageWithName: (NSString *)name;

// 绘制圆角
- (void)Lss_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;
@end

NS_ASSUME_NONNULL_END
