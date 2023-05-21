//
//  MMOrderPayWebVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/20.
//

#import "MMOrderPayWebVC.h"

@interface MMOrderPayWebVC ()

@end

@implementation MMOrderPayWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naView.titleLa.text = self.titleStr;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrlStr]]];
    
    // Do any additional setup after loading the view.
}



@end
