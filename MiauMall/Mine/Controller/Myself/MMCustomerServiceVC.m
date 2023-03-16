//
//  MMCustomerServiceVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import "MMCustomerServiceVC.h"
#import "MMComplaintCustomerServiceVC.h"

@interface MMCustomerServiceVC ()

@end

@implementation MMCustomerServiceVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
   
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"客服页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naView.titleLa.text = @"客服";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://hecong.miaumall.net/chat.html"]]];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"客服页面"];
}






@end
