//
//  AppDelegate.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "AppDelegate.h"
#import "MMTabbarController.h"
#import "MMLoginViewController.h"
#import "IQKeyboardManager.h"
#import "TalkingDataSDK.h"
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"
#import "XGPush.h"
#import "XGPushPrivate.h"
#import <UserNotifications/UserNotifications.h>
#import "MMNotificationModel.h"

@interface AppDelegate ()<XGPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[[XGPush defaultManager] configureClusterDomainName:@"tpns.sgp.tencent.com"];
	[[XGPush defaultManager] startXGWithAccessID:1620010648 accessKey:@"INXBF6P9TYWY" delegate:self];



    // Override point for customization after application launch.
    // 禁iOS13的调黑夜模式. warning: 在Xcode11及以上 放开以下注释
        if (@available(iOS 13.0, *)) {
            //强制设为iOS13之前默认的系统风格（白色系）
            self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            //fix: dark模式下 状态栏变白 导致看不清了
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        }
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *language = [languages objectAtIndex:0];
            if ([language hasPrefix:@"zh-Hans"]) {
              //开头匹配
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            }
        }
    
    //注册远程通知服务
//   [application registerUserNotificationSettings:[UIUserNotificationSettings
//   settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//   categories:nil]];
//   [[UIApplication sharedApplication]registerForRemoteNotifications];
//
    //talkingdata统计
    [TalkingDataSDK init:@ TALKINGAPPID channelId:@"AppStore" custom:@""];
    // 自动捕获异常信息
    [TalkingDataSDK setExceptionReportEnabled:YES];
    // 自动捕获异常信号
    [TalkingDataSDK setSignalReportEnabled:YES];

    
    
    ViewController *rootVC = [[ViewController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    application.applicationIconBadgeNumber = 0;
    
    
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
//    [[JLRoutesManager shareManager] addRoutes:@[@"/AControllers/:controller"]];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
#pragma mark - JLRoutes（默认的Scheme）
//    return [[JLRoutes globalRoutes] routeURL:url];
    return YES;
}



/**
 *          获取当前控制器
 */
-(UINavigationController *)currentViewController{
    
    MMTabbarController *WZXTabBar = (MMTabbarController *)self.window.rootViewController;
    return WZXTabBar.selectedViewController;
}

- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler{
    NSLog(@"%@",notification);
}

- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler{
    UNNotificationResponse *respon = response;
    NSDictionary *dic =  respon.notification.request.content.userInfo;
    NSDictionary *dic1 = dic[@"custom"];
    MMNotificationModel *model = [MMNotificationModel mj_objectWithKeyValues:dic1];
    [self RouteJump:[NSString stringWithFormat:@"/%@",model.page]];
    NSLog(@"%@",dic[@"custom"]);
}

- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken xgToken:(nullable NSString *)xgToken error:(nullable NSError *)error{
    //我自己的04269b8f83416e53e905279b5c54cd7f744b
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setValue:xgToken forKey:@"xgToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)xgPushDidFailToRegisterDeviceTokenWithError:(nullable NSError *)error{
    NSLog(@"%@",error);
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [[self currentViewController] pushViewController:vc animated:YES];
}


@end




