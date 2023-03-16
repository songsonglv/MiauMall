//
//  ViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "ViewController.h"
#import "MMTabbarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, WIDTH - 20, 50)];
    [btn setTitle:@"跳过" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(jump) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

-(void)jump{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMTabbarController *rootVC = [[MMTabbarController alloc]init];
    window.rootViewController = rootVC;
    rootVC.modalPresentationStyle = 0;
    [self presentViewController:rootVC animated:YES completion:nil];
}


@end
