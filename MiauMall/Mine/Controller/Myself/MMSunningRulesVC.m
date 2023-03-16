//
//  MMSunningRulesVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//  晒单规则

#import "MMSunningRulesVC.h"

@interface MMSunningRulesVC ()

@end

@implementation MMSunningRulesVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [TalkingDataSDK onPageBegin:@"晒单规则"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
//    [self setUI];
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetQuestionInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"4256" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
           
            NSString *str = [NSString stringWithFormat:@"%@,%@",jsonDic[@"Conts"],s];
            weakself.naView.titleLa.text = @"晒单规则";
            [weakself.webView loadHTMLString:str baseURL:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
      
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"晒单页面"];
}

@end
