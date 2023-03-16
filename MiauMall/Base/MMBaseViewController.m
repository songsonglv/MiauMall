//
//  MMBaseViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMBaseViewController.h"

@interface MMBaseViewController ()

@end

@implementation MMBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

     [self.navigationController setNavigationBarHidden:true animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
