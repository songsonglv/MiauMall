//
//  ZTProgressHUD.m
//  ShopDeatils
//
//  Created by 冀永金 on 2019/12/16.
//  Copyright © 2019 冀永金. All rights reserved.
//

#import "ZTProgressHUD.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#define DelayTime 2
@implementation ZTProgressHUD
/** 单例 */
+(instancetype)shareInstance{
    static ZTProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[ZTProgressHUD alloc] init];
        instance.HUDStyle = ZTProgressHUDStyleBlack;
    });
    return instance;
}




/// 只显示文字(显示在window上)
/// @param message 要显示的文字
+(void)showMessage:(nullable NSString *)message {
    [self show:message onView:nil hudMode:ZTProgressHUDModeTextOnly afterDelay:DelayTime];
}
/// 只显示文字
/// @param message 要显示的文字
/// @param view   要显示的view
+(void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view{
    [self show:message onView:view hudMode:ZTProgressHUDModeTextOnly afterDelay:DelayTime];
}


/// 显示文字,自定义消失时间(显示在window上)
/// @param message 要显示的文字
/// @param delay 时间
+(void)showMessage:(nullable NSString *)message afterDelayTime:(NSTimeInterval)delay{
    [self show:message onView:nil hudMode:ZTProgressHUDModeTextOnly afterDelay:delay];
}
/// 显示文字,自定义消失时间
/// @param message 要显示的文字
/// @param view 要显示的view
/// @param delay 时间
+(void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view afterDelayTime:(NSTimeInterval)delay{
    [self show:message onView:view hudMode:ZTProgressHUDModeTextOnly afterDelay:DelayTime];
}


/// 成功提示(显示在window上)
/// @param message 要显示的文字
+(void)showSuccessWithMessage:(nullable NSString *)message {
    [self show:message onView:nil hudMode:ZTProgressHUDModeSuccess afterDelay:DelayTime];
}
/// 成功提示
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showSuccessWithMessage:(nullable NSString *)message onView:(nullable UIView *)view{
    [self show:message onView:view hudMode:ZTProgressHUDModeSuccess afterDelay:DelayTime];
}


/// 失败提示(显示在window上)
/// @param message 要显示的文字
+(void)showFailWithMessage:(nullable NSString *)message{
    [self show:message onView:nil hudMode:ZTProgressHUDModeFail afterDelay:DelayTime];
}
/// 失败提示
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showFailWithMessage:(nullable NSString *)message onView:(nullable UIView *)view{
    [self show:message onView:view hudMode:ZTProgressHUDModeFail afterDelay:DelayTime];
}


/// 自定义图片显示(显示在window上)
/// @param message 要显示的文字
/// @param imageName 要显示的图片
+(void)showMessage:(nullable NSString *)message imageName:(NSString *)imageName{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:message onView:nil hudMode:ZTProgressHUDModeCustomerImage customImgView:imgView afterDelay:DelayTime];
}
/// 自定义图片显示
/// @param message 要显示的文字
/// @param imageName 要显示的图片
/// @param view 要显示的view
+(void)showMessage:(nullable NSString *)message imageName:(NSString *)imageName onView:(nullable UIView *)view{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:message onView:view hudMode:ZTProgressHUDModeCustomerImage customImgView:imgView afterDelay:DelayTime];
}


/// 显示动画(显示在window上)
/// @param message 要显示的文字
/// @param imgArry 帧动画数组
+(void)showCustomAnimationWithMessage:(nullable NSString *)message withImageArry:(NSArray *)imgArry{
    UIImageView *imgView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *imageString in imgArry) {
        [imageArray addObject:[UIImage imageNamed:imageString]];
    }
    imgView.animationImages = imageArray;
    [imgView setAnimationRepeatCount:0];
    [imgView setAnimationDuration:imgArry.count  * 0.25];
    [imgView startAnimating];
    [self show:message onView:nil hudMode:ZTProgressHUDModeCustomAnimation customImgView:imgView afterDelay:0];
}
/// 显示动画
/// @param message 要显示的文字
/// @param imgArry 帧动画数组
/// @param view 要显示的view
+(void)showCustomAnimationWithMessage:(nullable NSString *)message withImageArry:(NSArray *)imgArry onView:(nullable UIView *)view{
    UIImageView *imgView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *imageString in imgArry) {
        [imageArray addObject:[UIImage imageNamed:imageString]];
    }
    imgView.animationImages = imageArray;
    [imgView setAnimationRepeatCount:0];
    [imgView setAnimationDuration:imgArry.count  * 0.25];
    [imgView startAnimating];
    [self show:message onView:view hudMode:ZTProgressHUDModeCustomAnimation customImgView:imgView afterDelay:0];
}


/// 显示下载上传进度
/// @param message 要显示的文字
/// @param progress 进度
/// @param view 要显示的view
+(void)showProgressWithMessage:(nullable NSString *)message progress:(double)progress onView:(nullable UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
         UIView *showView = view;
        if (showView == nil)  showView = (UIView*)[UIApplication sharedApplication].delegate.window;
        if ([ZTProgressHUD shareInstance].hud == nil) {
            [ZTProgressHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        }
        
        [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeAnnularDeterminate;
        // 设置背景颜色
        if ([ZTProgressHUD shareInstance].HUDStyle == ZTProgressHUDStyleBlack) {
            [ZTProgressHUD shareInstance].hud.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor whiteColor];
            [ZTProgressHUD shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        }else {
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor blackColor];
        }
        [[ZTProgressHUD shareInstance].hud setMargin:20];
        [[ZTProgressHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
        [ZTProgressHUD shareInstance].hud.detailsLabel.text = message == nil ? @"" : message;
        [ZTProgressHUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        [ZTProgressHUD shareInstance].hud.progress = progress;
        if (progress >= 1) {
            [[ZTProgressHUD shareInstance].hud hideAnimated:YES];
            [ZTProgressHUD shareInstance].hud = nil;
        }
    });
    
}
/// 显示下载上传进度
/// @param message 要显示的文字
/// @param progress 进度
+(void)showProgressWithMessage:(nullable NSString *)message progress:(double)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = (UIView*)[UIApplication sharedApplication].delegate.window;
        if ([ZTProgressHUD shareInstance].hud == nil) {
            [ZTProgressHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        }
        
        [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeAnnularDeterminate;
        // 设置背景颜色
        if ([ZTProgressHUD shareInstance].HUDStyle == ZTProgressHUDStyleBlack) {
            [ZTProgressHUD shareInstance].hud.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor whiteColor];
            [ZTProgressHUD shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        }else {
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor blackColor];
        }
        [[ZTProgressHUD shareInstance].hud setMargin:20];
        [[ZTProgressHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
        [ZTProgressHUD shareInstance].hud.detailsLabel.text = message == nil ? @"" : message;
        [ZTProgressHUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        [ZTProgressHUD shareInstance].hud.progress = progress;
        if (progress >= 1) {
            [[ZTProgressHUD shareInstance].hud hideAnimated:YES];
            [ZTProgressHUD shareInstance].hud = nil;
        }
    });
}


/// 显示正在加载菊花(显示在window上)
/// @param message 要显示的文字
+(void)showLoadingWithMessage:(nullable NSString *)message{
    [self show:message onView:nil hudMode:ZTProgressHUDModeLoading afterDelay:0];
}
/// 显示正在加载菊花
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showLoadingWithMessage:(nullable NSString *)message onView:(nullable UIView *)view{
    [self show:message onView:view hudMode:ZTProgressHUDModeLoading afterDelay:0];
}


/// 显示正在加载圆圈(显示在window上)
/// @param message 要显示的文字
+(void)showCircleLoadingWithMessage:(nullable NSString *)message{
    [self show:message onView:nil hudMode:ZTProgressHUDModeCircle afterDelay:0];
}
/// 显示正在加载圆圈
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showCircleLoadingWithMessage:(nullable NSString *)message onView:(nullable UIView *)view{
    [self show:message onView:view hudMode:ZTProgressHUDModeCircle afterDelay:0] ;
    
}


+ (void)hide {
    if ([ZTProgressHUD shareInstance].hud != nil) {
        [[ZTProgressHUD shareInstance].hud hideAnimated:YES];
         [ZTProgressHUD shareInstance].hud = nil;
    }
}



- (void)setHUDStyle:(ZTProgressHUDStyle)HUDStyle {
    _HUDStyle = HUDStyle;
    
}



+ (void)show:(nullable NSString *)message onView:(nullable UIView *)view hudMode:(ZTProgressHUDMode)hudMode afterDelay:(double)afterDelay  {
    
    [self show:message onView:view hudMode:hudMode customImgView:nil afterDelay:afterDelay ];
    
}

+(void)showMessage:(NSString *)message antTitle:(NSString *)title onView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
         UIView *showView = view;
        if (showView == nil){
           showView = (UIView*)[UIApplication sharedApplication].keyWindow;
        }
        // 如果当前存在,则先消失
        if ([ZTProgressHUD shareInstance].hud != nil) {
            [[ZTProgressHUD shareInstance].hud hideAnimated:YES];
            [ZTProgressHUD shareInstance].hud = nil;
        }
        
    });
}

+ (void)show:(nullable NSString *)message onView:(nullable UIView *)view hudMode:(ZTProgressHUDMode)hudMode customImgView:(UIImageView *)customImgView afterDelay:(double)afterDelay{
    dispatch_async(dispatch_get_main_queue(), ^{
         UIView *showView = view;
        if (showView == nil){
           showView = (UIView*)[UIApplication sharedApplication].keyWindow;
        }
        // 如果当前存在,则先消失
        if ([ZTProgressHUD shareInstance].hud != nil) {
            [[ZTProgressHUD shareInstance].hud hideAnimated:YES];
            [ZTProgressHUD shareInstance].hud = nil;
        }
        
        [ZTProgressHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        // 设置背景颜色
        if ([ZTProgressHUD shareInstance].HUDStyle == ZTProgressHUDStyleBlack) {
            [ZTProgressHUD shareInstance].hud.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor whiteColor];
            [ZTProgressHUD shareInstance].hud.userInteractionEnabled = NO;
            [ZTProgressHUD shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        }else {
            [ZTProgressHUD shareInstance].hud.contentColor = [UIColor blackColor];
        }
        
        [[ZTProgressHUD shareInstance].hud setMargin:20];
        [[ZTProgressHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
        [ZTProgressHUD shareInstance].hud.detailsLabel.text = message == nil ? @"" : message;
        [ZTProgressHUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        switch (hudMode) {
            case ZTProgressHUDModeTextOnly://只显示文字
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeText;
                break;
                
            case ZTProgressHUDModeLoading://加载菊花
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
                break;
                
            case ZTProgressHUDModeCircle:{//加载环形
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                animation.toValue = [NSNumber numberWithFloat:M_PI*2];
                animation.duration = 1.0;
                animation.repeatCount = 100;
                [img.layer addAnimation:animation forKey:nil];
                [ZTProgressHUD shareInstance].hud.customView = img;
            }
                break;
                
            case ZTProgressHUDModeCustomerImage://自定义图片
                [ZTProgressHUD shareInstance].hud.bezelView.color = UIColor.clearColor;
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                [ZTProgressHUD shareInstance].hud.customView = customImgView;
                
                
                
                break;
                
            case ZTProgressHUDModeCustomAnimation://自定义帧动画
                //这里设置动画的背景色
                //            [ZTProgressHUD shareInstance].hud.bezelView.color = [UIColor whiteColor];
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                [ZTProgressHUD shareInstance].hud.customView = customImgView;
                //            [ZTProgressHUD shareInstance].hud.detailsLabel.textColor = [UIColor blackColor];
                break;
                
            case ZTProgressHUDModeSuccess:{
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                UIImageRenderingMode renderMode = [ZTProgressHUD shareInstance].HUDStyle == ZTProgressHUDStyleBlack ? UIImageRenderingModeAlwaysOriginal : UIImageRenderingModeAlwaysTemplate;
                UIImage *image = [[UIImage imageNamed:@"success"] imageWithRenderingMode:renderMode];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
                [ZTProgressHUD shareInstance].hud.customView = imgView;
            }
                break;
                
            case ZTProgressHUDModeFail:{
                [ZTProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                UIImageRenderingMode renderMode = [ZTProgressHUD shareInstance].HUDStyle == ZTProgressHUDStyleBlack ? UIImageRenderingModeAlwaysOriginal : UIImageRenderingModeAlwaysTemplate;
                UIImage *image = [[UIImage imageNamed:@"fail"] imageWithRenderingMode:renderMode];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
                [ZTProgressHUD shareInstance].hud.customView = imgView;
            }
                break;
            default:
                break;
        }
        if (afterDelay > 0) {
            [[ZTProgressHUD shareInstance].hud hideAnimated:YES afterDelay:afterDelay];
             [ZTProgressHUD shareInstance].hud = nil;
        }
    });
    
}

@end
