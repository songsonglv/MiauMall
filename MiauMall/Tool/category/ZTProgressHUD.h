//
//  ZTProgressHUD.h
//  ShopDeatils
//
//  Created by 冀永金 on 2019/12/16.
//  Copyright © 2019 冀永金. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <MBProgressHUD/MBProgressHUD.h>

@class MBProgressHUD;

typedef NS_ENUM(NSInteger, ZTProgressHUDMode){
    ZTProgressHUDModeTextOnly,         // 只显示文字
    ZTProgressHUDModeLoading,          // 加载菊花
    ZTProgressHUDModeCircle,           // 加载环形
    ZTProgressHUDModeProgress,         // 加载进度
    ZTProgressHUDModeCustomAnimation,  // 加载序列帧动画
    ZTProgressHUDModeSuccess,          // 加载成功
    ZTProgressHUDModeFail,             // 加载失败
    ZTProgressHUDModeCustomerImage     // 自定义图片
};

/**
 hud的样式

 - gray_background_style: 灰色背景
 - dim_background_style: 黑色背景
 */
typedef NS_ENUM(NSInteger, ZTProgressHUDStyle) {
    
    ZTProgressHUDStyleBlack = 0,
    ZTProgressHUDStyleGray,
};

@interface ZTProgressHUD : NSObject
/*===============================   属性   ================================================*/

@property (nonatomic,strong, nullable) MBProgressHUD  *hud;
@property(nonatomic , assign)ZTProgressHUDStyle HUDStyle;
/** 单例 */
+(instancetype)shareInstance;

/// 只显示文字(显示在window上)
/// @param message 要显示的文字
+(void)showMessage:(nullable NSString *)message;

/// @param message 任务返的补贴金
/// @param title 任务的文案
+(void)showMessage:(nullable NSString *)message antTitle:(nullable NSString *)title onView:(nullable UIView *)view;;
/// 只显示文字
/// @param message 要显示的文字
/// @param view   要显示的view
+(void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view;


/// 显示文字,自定义消失时间(显示在window上)
/// @param message 要显示的文字
/// @param delay 时间
+(void)showMessage:(nullable NSString *)message afterDelayTime:(NSTimeInterval)delay;
/// 显示文字,自定义消失时间
/// @param message 要显示的文字
/// @param view 要显示的view
/// @param delay 时间
+(void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view afterDelayTime:(NSTimeInterval)delay;


/// 成功提示(显示在window上)
/// @param message 要显示的文字
+(void)showSuccessWithMessage:(nullable NSString *)message;
/// 成功提示
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showSuccessWithMessage:(nullable NSString *)message onView:(nullable UIView *)view;

/// 失败提示(显示在window上)
/// @param message 要显示的文字
+(void)showFailWithMessage:(nullable NSString *)message;
/// 失败提示
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showFailWithMessage:(nullable NSString *)message onView:(nullable UIView *)view;

/// 自定义图片显示(显示在window上)
/// @param message 要显示的文字
/// @param imageName 要显示的图片
+(void)showMessage:(nullable NSString *)message imageName:(NSString *)imageName;
/// 自定义图片显示
/// @param message 要显示的文字
/// @param imageName 要显示的图片
/// @param view 要显示的view
+(void)showMessage:(nullable NSString *)message imageName:(NSString *)imageName onView:(nullable UIView *)view;


/// 显示动画(显示在window上)
/// @param message 要显示的文字
/// @param imgArry 帧动画数组
+(void)showCustomAnimationWithMessage:(nullable NSString *)message withImageArry:(NSArray *)imgArry;
/// 显示动画
/// @param message 要显示的文字
/// @param imgArry 帧动画数组
/// @param view 要显示的view
+(void)showCustomAnimationWithMessage:(nullable NSString *)message withImageArry:(NSArray *)imgArry onView:(nullable UIView *)view;


/// 显示下载上传进度
/// @param message 要显示的文字
/// @param progress 进度
+(void)showProgressWithMessage:(nullable NSString *)message progress:(double)progress;

 /// 显示下载上传进度
 /// @param message 要显示的文字
 /// @param progress 进度
 /// @param view 要显示的view
+(void)showProgressWithMessage:(nullable NSString *)message progress:(double)progress onView:(nullable UIView *)view;


/// 显示正在加载菊花(显示在window上)
/// @param message 要显示的文字
+(void)showLoadingWithMessage:(nullable NSString *)message;
/// 显示正在加载菊花
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showLoadingWithMessage:(nullable NSString *)message onView:(nullable UIView *)view;


/// 显示正在加载圆圈(显示在window上)
/// @param message 要显示的文字
+(void)showCircleLoadingWithMessage:(nullable NSString *)message;
/// 显示正在加载圆圈
/// @param message 要显示的文字
/// @param view 要显示的view
+(void)showCircleLoadingWithMessage:(nullable NSString *)message onView:(nullable UIView *)view;




/// 隐藏
+ (void)hide;

@end


