//
//  MMIntegralRuleVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//  蜜柚积分规则

#import "MMIntegralRuleVC.h"


@interface MMIntegralRuleVC ()

@end

@implementation MMIntegralRuleVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"积分规则页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naView.titleLa.text = [UserDefaultLocationDic valueForKey:@"intRule"];
    
    [self requestData];

}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSingle"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"682" forKey:@"id"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *str = jsonDic[@"Conts"];
            [weakself.webView loadHTMLString:str baseURL:nil];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"积分规则页面"];
}


@end
