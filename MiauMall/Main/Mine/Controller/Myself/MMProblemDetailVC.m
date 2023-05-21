//
//  MMProblemDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//

#import "MMProblemDetailVC.h"

@interface MMProblemDetailVC ()

@end

@implementation MMProblemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetQuestionInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"id"];
    }
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
           
            NSString *str = [NSString stringWithFormat:@"%@,%@",jsonDic[@"Conts"],s];
            weakself.naView.titleLa.text = jsonDic[@"Name"];
            [weakself.webView loadHTMLString:str baseURL:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
      
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
