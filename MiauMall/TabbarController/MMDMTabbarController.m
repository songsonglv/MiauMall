//
//  MMDMTabbarController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//

#import "MMDMTabbarController.h"
#import "MMDMHomeViewController.h"
#import "MMDMSiteViewController.h"
#import "MMDMShoppingBagViewController.h"
#import "MMDMOrderViewController.h"
#import "MMDMMineViewController.h"
#import "JLRoutes.h"
#import "MMNavigationController.h"
#import <objc/runtime.h>
#import "UIImage+LSSGImage.h"
#import "MiauMall-Swift.h"
#import "MMCustomerServiceVC.h"
#import "MMLocalTransLation.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface MMDMTabbarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *memberToken;
@end

@implementation MMDMTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.userID = [self.userDefaults valueForKey:@"userID"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"home"],@"站点",[UserDefaultLocationDic valueForKey:@"payCart"],[UserDefaultLocationDic valueForKey:@"my"]];
    
    [self addChildVC:[MMDMHomeViewController new] title:arr[0] normalImageName:@"dm_home" selectedImageName:@"dm_home_select" isRequiredNavController:YES];
    [self addChildVC:[MMDMSiteViewController new] title:arr[1] normalImageName:@"dm_site" selectedImageName:@"dm_site_select" isRequiredNavController:YES];
//    [self addChildVC:[MMDMOrderViewController new] title:arr[2] normalImageName:@"dm_order" selectedImageName:@"dm_order_select" isRequiredNavController:YES];
    [self addChildVC:[MMDMShoppingBagViewController new] title:arr[2] normalImageName:@"dm_shopcar" selectedImageName:@"dm_shopcar_select" isRequiredNavController:YES];
    [self addChildVC:[MMDMMineViewController new] title:arr[3] normalImageName:@"dm_mine" selectedImageName:@"dm_mine_select" isRequiredNavController:YES];
    // Do any additional setup after loading the view.
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
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x2a2a2a),NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        self.tabBar.tintColor = TCUIColorFromRGB(0x2a2a2a);
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
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x2a2a2a),NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        self.tabBar.tintColor = TCUIColorFromRGB(0x2a2a2a);

    };
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

@end
