//
//  MMAccountManageVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//  账号管理

#import "MMAccountManageVC.h"
#import "MMMineMainDataModel.h"
#import "MMBindEmialVC.h"

@interface MMAccountManageVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMMineMainDataModel *model;
@property (nonatomic, strong) UIButton *phoneBt;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UIButton *emailBt;
@property (nonatomic, strong) UILabel *emailLa;
@property (nonatomic, strong) UIButton *wxBt;
@property (nonatomic, strong) UIButton *appleBt;
@end

@implementation MMAccountManageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"账号管理页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"account"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuccess) name:@"BindEmailSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLoginResult:) name:@"WXLoginResult" object:nil];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)bindSuccess{
    KweakSelf(self);
   // [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMMineMainDataModel mj_objectWithKeyValues:jsonDic];
            weakself.emailBt.hidden = YES;
            weakself.emailLa.text = weakself.model.memberInfo.Email;
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMMineMainDataModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    //[UserDefaultLocationDic valueForKey:@"phoneNum"],,@"Apple ID" @"phone_icon",,@"apple_icon"
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"imailbox"],[UserDefaultLocationDic valueForKey:@"iwechat"]];
    NSArray *imgArr = @[@"email_icon",@"wx_icon"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 144)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    [self.view addSubview:bgView];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 72 * i, WIDTH - 20, 72)];
        [bgView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 24, 24, 24)];
        iconImage.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:iconImage];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 120;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(54);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(15);
        }];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
        [btn setTitle:@"" forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x828282) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:6];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:200];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(37);
        }];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x828282) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 200;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 71.5, view.width - 16, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
        [view addSubview:line];
        
//        if(i == 0){
//            self.phoneBt = btn;
//            self.phoneLa = lab1;
//            if(self.model.memberInfo.em.length > 0){
//                self.phoneLa.text = self.model.memberInfo.MobilePhone;
//                [btn setTitle:@"更换" forState:(UIControlStateNormal)];
//            }else{
//                [btn setTitle:@"添加" forState:(UIControlStateNormal)];
//            }
//        }else
        if (i == 0){
            self.emailBt = btn;
            self.emailLa = lab1;
            if(self.model.memberInfo.Email.length > 0 && self.model.memberInfo.PaymentPassword.length > 0){
                self.emailLa.text = self.model.memberInfo.Email;
                self.emailBt.hidden = YES;
//                [btn setTitle:@"更换" forState:(UIControlStateNormal)];
            }else{
                self.emailLa.text = [UserDefaultLocationDic valueForKey:@"toAdd"];
//                [btn setTitle:[] forState:(UIControlStateNormal)];
            }
        }else {
//            lab1.hidden = YES;
            self.wxBt = btn;
            if([self.model.memberInfo.CanWxBind isEqualToString:@"1"]){
//                [btn setTitle:[UserDefaultLocationDic valueForKey:@"wxBound"] forState:(UIControlStateNormal)];
            }else{
                lab1.text = [UserDefaultLocationDic valueForKey:@"wxBound"];
                self.wxBt.hidden = YES;
//                [btn setTitle:@"" forState:(UIControlStateNormal)];
            }
        }
//        else{
//            lab1.hidden = YES;
//            self.appleBt = btn;
//            [btn setTitle:@"绑定" forState:(UIControlStateNormal)];//没字段判断是否绑定
//        }
    }
}

-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        if(self.model.memberInfo.Email.length > 0 && self.model.memberInfo.AccountPassword.length > 0){
            
        }else{
            MMBindEmialVC *bindVC = [[MMBindEmialVC alloc]init];
            bindVC.model = self.model;
            [self.navigationController pushViewController:bindVC animated:YES];
        }
    }else{
        if([self.model.memberInfo.CanWxBind isEqualToString:@"1"]){
            [self sendAuthRequest];
        }
    }
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo"; // 只能填 snsapi_userinfo
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:nil];
}

-(void)wxLoginResult:(NSNotification *)noti{
    KweakSelf(self);
    SendAuthResp *resp = noti.object;
    if(resp.errCode == 0){
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%@&grant_type=authorization_code",WXAppid,WXSecret,resp.code];
       
        [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *access_token = [NSString stringWithFormat:@"%@",jsonDic[@"access_token"]];
            if(access_token.length > 0){
                [weakself refresh_token:jsonDic];
            }
        } RequestFaile:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        
    }
}

//无论是否超时都刷新下accesstoken避免token过期
-(void)refresh_token:(NSDictionary *)dic{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%s&grant_type=refresh_token&refresh_token=%@",WXAppid,dic[@"refresh_token"]];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *access_token = [NSString stringWithFormat:@"%@",jsonDic[@"access_token"]];
        if(access_token.length > 0){
            [weakself snsUserInfo:jsonDic];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)snsUserInfo:(NSDictionary *)dic{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",dic[@"access_token"],dic[@"openid"]];
    
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [weakself setWxBind:jsonDic];
//        [weakself WxLoginSaveCode:jsonDic];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setWxBind:(NSDictionary *)dic{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"WxBind"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:dic[@"unionid"] forKey:@"unionid"];
    [param setValue:dic[@"openid"] forKey:@"openid"];
    [param setValue:dic[@"nickname"] forKey:@"name"];
    [param setValue:dic[@"headimgurl"] forKey:@"photoUrl"];
    [param setValue:dic[@"sex"] forKey:@"sex"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
   

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"账号管理页面"];
}
@end
