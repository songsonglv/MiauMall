//
//  MMCustomerServiceVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//  客服页面

#import "MMCustomerServiceVC.h"
#import "MMComplaintCustomerServiceVC.h"
#import "MMKeFuModel.h"

@interface MMCustomerServiceVC ()
@property (nonatomic, strong) MMKeFuModel *kefuModel;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *today;
@end

@implementation MMCustomerServiceVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.deviceToken = [self.userDefaults valueForKey:@"deviceToken"];
    self.today = [self.userDefaults valueForKey:@"today"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"客服页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naView.titleLa.text = [UserDefaultLocationDic valueForKey:@"customerService"];
    [self GetKeFu];
    
    [self SetKeFuNoticeRead];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    // Do any additional setup after loading the view.
}

-(void)SetKeFuNoticeRead{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetKeFuNoticeRead"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [weakself.userDefaults setValue:@"0" forKey:@"NoReadMsg"];
        [weakself.userDefaults synchronize];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetKeFu{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetKeFu"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.kefuModel = [MMKeFuModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    NSString *url = self.kefuModel.IsMeiQia;
    NSString *customer;
   // url = [NSString stringWithFormat:@"%@tokenType=%@",url,@"2"];
    NSMutableDictionary *customer1 = [[NSMutableDictionary alloc]init];
    if([self.isDM isEqualToString:@"1"]){
        if([self.lang isEqualToString:@"0"]){
            url = [NSString stringWithFormat:@"%@channelId=YMm3w2",url];
        }else if ([self.lang isEqualToString:@"1"]){
            url = [NSString stringWithFormat:@"%@channelId=gzBX60",url];
        }else if ([self.lang isEqualToString:@"2"]){
            url = [NSString stringWithFormat:@"%@channelId=4DijJ9",url];
        }else if ([self.lang isEqualToString:@"3"]){
            url = [NSString stringWithFormat:@"%@channelId=2dZfA5",url];
        }
    }else{
        if([self.lang isEqualToString:@"0"]){
            url = [NSString stringWithFormat:@"%@channelId=l10iKX",url];
        }else if ([self.lang isEqualToString:@"1"]){
            url = [NSString stringWithFormat:@"%@channelId=7xVO4b",url];
        }else if ([self.lang isEqualToString:@"2"]){
            url = [NSString stringWithFormat:@"%@channelId=0yLv6X",url];
        }else if ([self.lang isEqualToString:@"3"]){
            url = [NSString stringWithFormat:@"%@channelId=Vdk02J",url];
        }
        
        
    }
    if([self.lang isEqualToString:@"1"]){
        url = [NSString stringWithFormat:@"%@&language=%@",url,@"en"];
    }else{
        url = [NSString stringWithFormat:@"%@&language=%@",url,@"cn"];
    }
    
    url = [NSString stringWithFormat:@"%@&uniqueId=%@",url,self.kefuModel.memInfo.ID];
    
    if(![self.kefuModel.LastOrderID isEqualToString:@""]){
        NSDate *datenow = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *str1 = [formatter stringFromDate:datenow];
        
        [self.userDefaults setValue:str1 forKey:@"today"];
        if([self.today isEqualToString:str1]){
            
        }else{
            
            NSString *str = [NSString stringWithFormat:@"自动消息：您需要咨询的订单号是否为%@？",self.kefuModel.LastOrderID];
            if(self.orderID){
                str = [NSString stringWithFormat:@"自动消息：您需要咨询的订单号是否为%@？",self.orderID];
            }
            NSDictionary *dic = @{@"contents":str};
            NSString *dic1 = [[self dictionaryToJson:dic] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            url = [NSString stringWithFormat:@"%@&triggerMessage=%@",url,dic1];
        }
        
        
    }
//    url = [NSString stringWithFormat:@"%@&LastOrderID=%@",url,self.kefuModel.LastOrderID];
    
    if(self.kefuModel.SalesCount){
        [customer1 setValue:self.kefuModel.SalesCount forKey:@"订单数量"];
    }
    if(self.kefuModel.SalesMoney){
        [customer1 setValue:self.kefuModel.SalesMoney forKey:@"订单金额"];
    }
    
    if(self.kefuModel.memInfo.ID){
        [customer1 setValue:self.kefuModel.memInfo.ID forKey:@"会员ID"];
    }
    
    if(self.deviceToken){
        [customer1 setValue:self.deviceToken forKey:@"token"];
    }
    
    
    if(self.kefuModel.memInfo.Email.length > 0){
        [customer1 setValue:self.kefuModel.memInfo.Email forKey:@"邮箱"];
    }
    if(self.kefuModel.memInfo.Name.length > 0){
        [customer1 setValue:self.kefuModel.memInfo.Name forKey:@"名称"];
    }
    
    if(self.kefuModel.memInfo.MobilePhone.length > 0){
        [customer1 setValue:self.kefuModel.memInfo.MobilePhone forKey:@"手机"];
    }
    
    if(self.kefuModel.memInfo.Sex_Bind.length > 0){
        [customer1 setValue:self.kefuModel.memInfo.Sex_Bind forKey:@"性别"];
    }
    
    if(self.kefuModel.memInfo.Currency_Bind.length > 0){
        [customer1 setValue:self.kefuModel.memInfo.Currency_Bind forKey:@"国家"];
    }
    [customer1 setValue:@"2" forKey:@"tokenType"];
    
    if(self.goodsName){
        [customer1 setValue:self.goodsName forKey:@"商品"];
    }
    
   
    customer = [[self dictionaryToJson:customer1]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    url = [NSString stringWithFormat:@"%@&customer=%@",url,customer];
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    [self.webView loadHTMLString:nil baseURL:[NSURL URLWithString:url]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"客服页面"];
}

//字典转字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}




@end
