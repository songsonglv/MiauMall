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
#import "MiauMall-Swift.h"
#import "MMHomePageVC.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()<XGPushDelegate,WXApiDelegate,GIDSignInDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *memberToken;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.userID = [self.userDefaults valueForKey:@"userID"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    
    [[XGPush defaultManager] configureClusterDomainName:@"tpns.sh.tencent.com"];
     //@"tpns.sgp.tencent.com"];
	[[XGPush defaultManager] startXGWithAccessID:1680005430 accessKey:@"ID7NX3T7O9U1" delegate:self];
    
    [Bugly startWithAppId:@BuylyID];

    [WXApi registerApp:@WXAppid universalLink:@"https://app.miau2020.com/unishop/"];
    
    //TXLiveBase 位于 "TXLiveBase.h" 头文件中
     
//    [TXLiveBase setLicenceURL:@TPLicenseURL key:@TPLicenseKey];
//    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);

    
    // 注册 FacebookAppID
//    [FBSDKSettings setAppID:@FBAppID];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //注册谷歌
    [GIDSignIn sharedInstance].clientID = @GoogleAppId;
    [LineLogin registerLine];
   
//    [GIDSignIn sharedInstance].;

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
//
    //统计后台使用时长
    [TalkingDataSDK backgroundSessionEnabled];
    //talkingdata统计
    [TalkingDataSDK init:@TALKINGAPPID channelId:@"AppStore" custom:@""];
    // 自动捕获异常信息
    [TalkingDataSDK setExceptionReportEnabled:YES];
    // 自动捕获异常信号
    [TalkingDataSDK setSignalReportEnabled:YES];

    
    
    ViewController *rootVC = [[ViewController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册网络连接回调
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(handleNetworkActive:) name:@"networkActive" object:nil];
    [ZTNetworking testNetWork];
    
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

    return YES;
}

//-(void)handleNetworkActive:(NSNotification *)notifi{
//    
//}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"becomeActive" object:nil];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    if(self.memberToken){
        [self requestNoRead];
    }
   
}


-(void)requestNoRead{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetKeFuNotice"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    NSDictionary *param = @{@"membertoken":self.memberToken};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSData *jsonData = [jsonDic[@"Conts"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSString *NoReadCount = [NSString stringWithFormat:@"%@",jsonDic[@"NoReadCount"]];
        [self.userDefaults setValue:NoReadCount forKey:@"NoReadMsg"];
        [self.userDefaults synchronize];
        if(dic){
            NSString *str = dic[@"msg"][@"body"];
           
            [EBBannerView showWithContent:str];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerViewDidClick:) name:EBBannerViewDidClickNotification object:nil];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)bannerViewDidClick:(NSNotification*)noti{

    
    [self RouteJump:@"/member/home/kefu"];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
    
//    if (@available(iOS 9.0, *)) {
//           return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//       } else {
//           // Fallback on earlier versions
//       }

    [TalkingDataSDK onReceiveDeepLink:url];
    
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                     openURL:url
                                                     options:options];
    
    if ([[url scheme] isEqualToString:@"wx0ee23c892314f6f0"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            if(resultStatus == 9000){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResultSuccess" object:nil];
            }else{
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"payFailed"]];
            }
               
        }];
    }else if ([url.scheme isEqualToString:@"com.googleusercontent.apps.331442012709-1j16s996je2lhvc1ibeps062qcr8s9oi"]){
        return  [[GIDSignIn sharedInstance] handleURL:url];;
    }else if ([url.scheme isEqualToString:@"fb753816059390757"]){
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }else if ([url.scheme isEqualToString:@GoogleToken]){
        return [[GIDSignIn sharedInstance] handleURL:url];
    }else if ([url.scheme isEqualToString:@"line3rdp.com.miau2020.apk"]) {
        return [LineLogin applicationOpenurl:app open:url];
    }else if ([TalkingDataSDK handleUrl:url]) {
        return YES;
    }

    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
        openURL:url
        sourceApplication:sourceApplication
        annotation:annotation
      ];
    
    if ([url.absoluteString containsString:@FBAppID]) {
            return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }else  if ([url.absoluteString containsString:@GoogleAppId]) {
            return [[GIDSignIn sharedInstance] handleURL:url];
        }else if ([url.absoluteString containsString:@TALKINGAPPID]){
            return YES;
        }else if ([url.absoluteString containsString:@FBAppID]){
            BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                openURL:url
                sourceApplication:sourceApplication
                annotation:annotation
              ];
            return handled;
            
        }
        return NO;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
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
    //我自己的04269b8f83416e53e905279b5c54cd7f744b //境外
    //境内 08868caf2cc11b9f9668a4b915a2501e210b
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
    BOOL isKind = [vc isKindOfClass:[MMHomePageVC class]];
    if(isKind == YES){
        MMTabbarController *rootVC = [[MMTabbarController alloc]init];
        self.window.rootViewController = rootVC;
        rootVC.modalPresentationStyle = 0;
        [[self currentViewController] presentViewController:rootVC animated:YES completion:nil];
    }else{
        [[self currentViewController] pushViewController:vc animated:YES];
    }
   
}


#pragma mark -- wxapidelegate
-(void)onReq:(BaseReq*)reqonReq{
    NSLog(@"%@",reqonReq);
}

-(void) onResp:(BaseResp*)resp{
    NSLog(@"%@",resp);
    if([resp isKindOfClass:[SendAuthResp class]]){
        //resp.errCode 0 允许 -4 拒绝 -2 取消关闭
        SendAuthResp *noti = resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLoginResult" object:noti];
    }else if([resp isKindOfClass:[PayResp class]]){
        PayResp *noti = resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPayResult" object:noti];
    }
    
   
}

@end




