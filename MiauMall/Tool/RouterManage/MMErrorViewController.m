//
//  MMErrorViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import "MMErrorViewController.h"

@interface MMErrorViewController ()

@end

@implementation MMErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找不到对应的VC";
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor redColor];
    label.text = @"找不到对应的VC";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
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
