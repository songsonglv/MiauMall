//
//  MMTabbarController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/5.
//

#import "MMTabbarController.h"
#import "MMHomePageVC.h"
#import "MMMineVC.h"
#import "MMClassifyVC.h"
#import "MMStrollVC.h"
#import "MMShopCarVC.h"
#import "JLRoutes.h"
#import "MMNavigationController.h"
#import <objc/runtime.h>
#import "UIImage+LSSGImage.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface MMTabbarController ()<UITabBarControllerDelegate>

@end

@implementation MMTabbarController

-(void)viewDidLoad{
    [self addChildVC:[MMHomePageVC new] title:@"首页" normalImageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected" isRequiredNavController:YES];
    
    [self addChildVC:[MMClassifyVC new] title:@"分类" normalImageName:@"tabbar_classify" selectedImageName:@"tabbar_classify_selected" isRequiredNavController:YES];
    [self addChildVC:[MMStrollVC new] title:@"逛逛" normalImageName:@"tabbar_stroll" selectedImageName:@"tabbar_stroll_selected" isRequiredNavController:YES];
    [self addChildVC:[MMShopCarVC new] title:@"购物车" normalImageName:@"tabbar_shopcar" selectedImageName:@"tabbar_shopcar_selected" isRequiredNavController:YES];
    [self addChildVC:[MMMineVC new] title:@"我的" normalImageName:@"tabbar_mine" selectedImageName:@"tabbar_mine_selected" isRequiredNavController:YES];
    
    
    
    self.delegate = self;
    
    NSString *time = [self getCurrentTimes];
    NSString *str1 = [time substringFromIndex:8];

}

+ (instancetype)shareInstance {
    
    static MMTabbarController *tabbarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarC = [[MMTabbarController alloc] init];
    });
    return tabbarC;
}

+ (instancetype)tabBarControllerWithAddChildVCsBlock: (void(^)(MMTabbarController *tabBarC))addVCBlock {
    MMTabbarController *tabbarVC = [[MMTabbarController alloc] init];
    if (addVCBlock) {
        addVCBlock(tabbarVC);
    }
    
    return tabbarVC;
}

#pragma mark - <UITabBarControllerDelegate>
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSDictionary *dic = @{@"source":@"antRebate",@"tabName":tabBarController.tabBar.selectedItem.title};
//    [MobClick event:@"bottom_tab_click_event" attributes:dic];
    
   
    
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"我的"] || [tabBarController.tabBar.selectedItem.title isEqualToString:@"赚钱"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               NSString *loginFlag = [userDefaults valueForKey:@"loginFlag"];
               if (loginFlag) {
                   return YES;
               }else{
//                   AntLoginViewController *loginVC = [[AntLoginViewController alloc]init];
//                   loginVC.modalPresentationStyle = 0;
//                   [self presentViewController:loginVC animated:YES completion:nil];
                    return YES;//为NO就不会切换tab
               }
       
    }else{
        return YES;
    }
    
}


/**
 *  根据参数, 创建并添加对应的子控制器
 *
 *  @param vc                需要添加的控制器(会自动包装导航控制器)
 *  @param isRequired             标题
 *  @param normalImageName   一般图片名称
 *  @param selectedImageName 选中图片名称
 */
- (void)addChildVC: (UIViewController *)vc title: (NSString *)title normalImageName: (NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController: (BOOL)isRequired {
    
    
    
    if (isRequired) {
        MMNavigationController *nav = [[MMNavigationController alloc] initWithRootViewController:vc];
        vc.title = title;
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage originImageWithName:normalImageName] selectedImage:[UIImage originImageWithName:selectedImageName]];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        
        [self addChildViewController:nav];
    }else {
        
        [self addChildViewController:vc];
    }
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
     UIGraphicsBeginImageContext(rect.size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
     CGContextFillRect(context, rect);
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    
    if (@available(iOS 15.0, *)) {
           UITabBarAppearance * appearance = [UITabBarAppearance new];
           UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
           appearance.backgroundImage = img;//把毛玻璃View转成Image
           self.tabBar.scrollEdgeAppearance = appearance;
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        self.tabBar.tintColor = selectColor;
       }else if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [self.tabBar.standardAppearance copy];
        [tabBarAppearance setBackgroundImage:img];
        [tabBarAppearance setShadowColor:[UIColor clearColor]];
        [self.tabBar setStandardAppearance:tabBarAppearance];

        UITabBarAppearance *apperance= self.tabBar.standardAppearance;

        apperance.backgroundImage=[self imageWithColor:[UIColor whiteColor]];

        apperance.shadowImage = [self imageWithColor:[UIColor whiteColor]];

        [apperance setShadowColor:UIColor.blackColor];
        
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  blackColor],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
           self.tabBar.tintColor = UIColor.blackColor;
    } else {
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *apperance= self.tabBar.standardAppearance;
            [apperance setShadowColor:UIColor.clearColor];
//            [[UITabBarItem appearance] setShadowColor:[UIColor clearColor]];
        } else {
            // Fallback on earlier versions
        }
        self.tabBar.backgroundImage = [self imageWithColor:[UIColor whiteColor]];
        self.tabBar.shadowImage = [self imageWithColor:[UIColor whiteColor]];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        self.tabBar.tintColor = selectColor;

    };
}

-(void)paramToVc:(MMBaseViewController *) vC param:(NSDictionary<NSString *,NSString *> *)parameters{
    //        runtime将参数传递至需要跳转的控制器
    unsigned int outCount = 0;
    
    objc_property_t * properties = class_copyPropertyList(vC.class , &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *param = parameters[key];
        vC.param = parameters;
        if (param != nil) {
            [vC setValue:param forKey:key];
        }
    }
}

/**
 *          获取当前控制器
 */
-(UINavigationController *)currentViewController{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMTabbarController *WZXTabBar = (MMTabbarController *)window.rootViewController;
    return WZXTabBar.selectedViewController;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
    
#pragma mark - JLRoutes（默认的Scheme）
    
    return [[JLRoutes globalRoutes] routeURL:url];
}





//自定义颜色生产UIImage，对象

- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0, 0, 1, 1);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    [color setFill];

    UIRectFill(rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;

}

//获取现在时间
-(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;

}


@end
