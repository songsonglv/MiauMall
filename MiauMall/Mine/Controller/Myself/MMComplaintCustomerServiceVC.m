//
//  MMComplaintCustomerServiceVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import "MMComplaintCustomerServiceVC.h"


@interface MMComplaintCustomerServiceVC ()

@end

@implementation MMComplaintCustomerServiceVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
  
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"客服投诉页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naView.titleLa.text = @"客服投诉";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tousu.miaumall.net/"]]];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"客服投诉页面"];
}


@end
