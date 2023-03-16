//
//  MMPromiseVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/23.
//

#import "MMPromiseVC.h"

@interface MMPromiseVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) CGFloat hei;
@end

@implementation MMPromiseVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"蜜柚承诺页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
//    titleView.titleLa.text = @"蜜柚承诺";
//    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:titleView];
//    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
//    self.lang = [self.userDefaults valueForKey:@"language"];
//    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    [self requestData];
//    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSingle"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"685" forKey:@"id"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
           
            NSString *str = [NSString stringWithFormat:@"%@,%@",jsonDic[@"Conts"],s];
            [weakself.webView loadHTMLString:str baseURL:nil];
            weakself.naView.titleLa.text = jsonDic[@"Name"];
            [weakself setUI];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    KweakSelf(self);
    UIButton *readBt = [[UIButton alloc]init];
    readBt.backgroundColor = selectColor;
    readBt.layer.masksToBounds = YES;
    readBt.layer.cornerRadius = 10;
    [readBt setTitle:@"已阅读" forState:(UIControlStateNormal)];
    readBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [readBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [readBt addTarget:self action:@selector(clickRead) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:readBt];
    
    [readBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakself.view);
            make.bottom.mas_equalTo(-36);
            make.width.mas_equalTo(72);
            make.height.mas_equalTo(20);
    }];
}

-(void)clickRead{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定已阅读吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself requestRead];
    }]];
    
    

    [self presentViewController:alert animated:true completion:nil];
}

-(void)requestRead{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"HadRead"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"685" forKey:@"id"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself returnBack];
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"蜜柚承诺页面"];
}
@end
