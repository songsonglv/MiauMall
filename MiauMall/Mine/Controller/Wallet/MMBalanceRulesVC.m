//
//  MMBalanceRulesVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//  余额规则页面

#import "MMBalanceRulesVC.h"

@interface MMBalanceRulesVC ()
@property (nonatomic, assign) float hei;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation MMBalanceRulesVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"余额使用规则页面"];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.naView.titleLa.text = @"余额规则";
    
    [self requestData];
    
//    [self setUI];
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSingle"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"716" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *str = jsonDic[@"Conts"];
            NSString *str1 = [str stringByReplacingOccurrencesOfString:@"t=""余额使用规则.png""/>" withString:@"t=""余额使用规则.png/""/></p>"];
            NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
           
            NSString *str2 = [NSString stringWithFormat:@"%@,%@",str1,s];
            [weakself.webView loadHTMLString:str2 baseURL:nil];
            
         
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
      
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"余额使用规则"];
}

@end
