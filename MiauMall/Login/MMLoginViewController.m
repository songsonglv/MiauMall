//
//  MMLoginViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/12.
//  登录页面

#import "MMLoginViewController.h"
#import "XYCountryCodeViewController.h"
#import "MMRegisterViewController.h"
#import "MMForgetPWDViewController.h"
#import "MMSelectAreaViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "MiauMall-Swift.h"
#import "MMClauseDetailVC.h"



@interface MMLoginViewController ()<UITextFieldDelegate,WXApiDelegate,GIDSignInDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *phoneField;//手机号输入
@property (nonatomic, strong) UITextField *pwField;//密码输入框
@property (nonatomic, strong) UILabel *areaLabel;//地区
@property (nonatomic, strong) UIButton *areaBt;
@property (nonatomic, strong) UILabel *countryCodeLa;//国家区号标签
@property (nonatomic, strong) NSString *countryCode;//国家编号 默认86
@property (nonatomic, strong) UIButton *countryCodeBt;//国家区号按钮
@property (nonatomic, strong) UIImageView *bgImage;//背景图片
@property (nonatomic, strong) UIButton *loginBt;
@property (nonatomic, strong) NSString *isSelect;//是否选中 默认1 已选中

@property (nonatomic, strong) NSString *isPhone;//手机号登陆 默认1


@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailField;//邮箱输入框
@property (nonatomic, strong) UITextField *epwdField;//邮箱密码输入框
@property (nonatomic, strong) MMMemberInfoModel *userInfo;//用户信息
@property (nonatomic, strong) NSDictionary *wxInfoDic;//微信返回的accesstoken和其他信息
@property (nonatomic, strong) NSString *RegCode;
@property (nonatomic, strong) NSString *deviceToken;
@end

@implementation MMLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.RegCode = [self.userDefaults valueForKey:@"webRegCode"];
    [TalkingDataSDK onPageBegin:@"登录页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSelect = @"1";
    self.isPhone = @"1";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLoginResult:) name:@"WXLoginResult" object:nil];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.countryCode = [self.userDefaults valueForKey:@"areaCode"];
    self.deviceToken = [self.userDefaults valueForKey:@"deviceToken"];
    self.RegCode = [self.userDefaults valueForKey:@"webRegCode"];
    
    // 设置代理
    [GIDSignIn sharedInstance].delegate = self;
    // 必须设置 否则会Crash
    [GIDSignIn sharedInstance].presentingViewController = self;

//    [LineSDKLogin sharedInstance].delegate = self;
    
    [self setUI];
    // Do any additional setup after loading the view.
}

#pragma mark -- Google登录delegate
- (void)signIn:(GIDSignIn*)signIn didSignInForUser:(GIDGoogleUser*)user withError:(NSError*)error
{
    NSLog(@"signIn user  %@ %@",user,error);
    if(user){
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:email forKey:@"email"];
        [param setValue:@"" forKey:@"photoUrl"];
        [param setValue:fullName forKey:@"name"];
        [param setValue:userId forKey:@"unionId"];
        [param setValue:userId forKey:@"openId"];
        [param setValue:@"" forKey:@"sex"];
        [param setValue:self.tempcart forKey:@"tempcart"];
        [param setValue:@"0" forKey:@"RegSource"];
        [param setValue:@"4" forKey:@"type"];
        [param setValue:self.deviceToken forKey:@"SSID"];
        if(self.RegCode){
            [param setValue:self.RegCode forKey:@"RegCode"];
        }
        [self threeLoginSave:param];
    }else{
        NSLog(@"signIn error == %@",error);
    }
    
}


-(void)threeLoginSave:(NSDictionary *)param{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"WxReg"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
            [weakself.userDefaults synchronize];
            TalkingDataProfile *profile = [TalkingDataProfile createProfile];
            if([param[@"type"] isEqualToString:@"4"]){
                profile.type = TalkingDataProfileTypeType1;
            }else if ([param[@"type"] isEqualToString:@"5"]){
                profile.type = TalkingDataProfileTypeType2;
            }else if ([param[@"type"] isEqualToString:@"9"]){
                profile.type = TalkingDataProfileTypeType3;
            }else if ([param[@"type"] isEqualToString:@"10"]){
                profile.type = TalkingDataProfileTypeType4;
            }
            [TalkingDataSDK onLogin:jsonDic[@"key"] profile:profile];
            [weakself dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
        [weakself WxLoginSaveCode:jsonDic];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)WxLoginSaveCode:(NSDictionary *)dic{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"WxReg"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(dic[@"unionid"]){
        [param setValue:dic[@"unionid"] forKey:@"unionId"];
        [param setValue:dic[@"openId"] forKey:@"openId"];
        [param setValue:dic[@"nickname"] forKey:@"name"];
        [param setValue:dic[@"headimgurl"] forKey:@"photoUrl"];
        [param setValue:dic[@"sex"] forKey:@"sex"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:@"8" forKey:@"type"];//微信 8 facebook 5 google 4 apple 9
    [param setValue:@"0" forKey:@"RegSource"];
    if(self.deviceToken){
        [param setValue:self.deviceToken forKey:@"SSID"];
    }
    if(self.RegCode){
        [param setValue:self.RegCode forKey:@"RegCode"];
    }
    
    
    
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
            [weakself.userDefaults synchronize];
//            TalkingDataProfile *profile = [TalkingDataProfile createProfile];
//            profile.type = TalkingDataProfileTypeWeiXin;
//            [TalkingDataSDK onLogin:jsonDic[@"key"] profile:profile ];
            [TalkingDataSDK onEvent:@"iOS原生-微信登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            [weakself dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//只有Facebook使用 其他用上面的
-(void)fbLogin:(NSDictionary *)param{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"WxLogin"];
//    NSString *url = [NSString stringWithFormat:@"%s?t=%@&RegSource=%@&name=%@&openId=%@&photoUrl=%@&tempcart=%@&type=5",baseurl,@"WxLogin",@"0",param[@"name"],param[@"openId"],param[@"photoUrl"],param[@"tempcart"]];
//    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
//        NSLog(@"%@",jsonDic);
//    } RequestFaile:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
            [weakself.userDefaults synchronize];
            if([param[@"type"] isEqualToString:@"4"]){
                [TalkingDataSDK onEvent:@"iOS原生-谷歌登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            }else if ([param[@"type"] isEqualToString:@"5"]){
                [TalkingDataSDK onEvent:@"iOS原生-Facebook登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            }else if ([param[@"type"] isEqualToString:@"9"]){
                [TalkingDataSDK onEvent:@"iOS原生-Apple登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            }else if ([param[@"type"] isEqualToString:@"10"]){
                [TalkingDataSDK onEvent:@"iOS原生-Line登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            }
//            [TalkingDataSDK onLogin:jsonDic[@"key"] profile:profile];
            [weakself dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    KweakSelf(self);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, WIDTH, HEIGHT + 10)];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:@"https://app.miau2020.com/down/appview/login.jpg"] placeholderImage:[UIImage imageNamed:@"login_bg"]];
    bgImage.userInteractionEnabled = YES;
//    bgImage.alpha = 0.3;
    [self.view addSubview:bgImage];
    self.bgImage = bgImage;
    
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(24, StatusBarHeight + 14, 12, 18)];
    [returnBt setBackgroundImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickBack) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:returnBt];
    
    UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 74, StatusBarHeight + 16, 74, 16)];
//    [rightBt setBackgroundColor:UIColor.blueColor];
    [rightBt setTitle:[UserDefaultLocationDic valueForKey:@"iregister"] forState:(UIControlStateNormal)];
    [rightBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    rightBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [rightBt addTarget:self action:@selector(jumpRegist) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:rightBt];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 80)/2, StatusBarHeight + 65, 80, 88)];
    iconImage.image = [UIImage imageNamed:@"Login_icon"];
    [bgImage addSubview:iconImage];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame) + 20, WIDTH, 180)];
    [bgImage addSubview:view];
    self.phoneView = view;
    
    NSString *code = [self.userDefaults valueForKey:@"areaCode"];
    NSString *str = [NSString stringWithFormat:@"+%@  ",code];
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"icountry"],str,[UserDefaultLocationDic valueForKey:@"ipassword"]];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        view.backgroundColor = UIColor.clearColor;
        [self.phoneView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(30, 23, 100, 14);
        [view addSubview:lab];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 30, 22, 180, 16)];
        field.delegate = self;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0xffffff);
        field.tintColor = TCUIColorFromRGB(0xffffff);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        field.keyboardType = UIKeyboardTypeDecimalPad;
        [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
        [view addSubview:field];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            field.hidden = YES;
            NSString *area = [self.userDefaults valueForKey:@"area"];
            UILabel *areaLa = [UILabel publicLab:area textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
            areaLa.frame = CGRectMake(CGRectGetMaxX(lab.frame) + 30, 22, 200, 16);
            [view addSubview:areaLa];
            self.areaLabel = areaLa;
            
            UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(130, 0, WIDTH - 130, 40)];
            [bt setBackgroundColor:UIColor.clearColor];
            [bt addTarget:self action:@selector(clickArea) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:bt];
            
            UIImageView *rightImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 43, 25, 5, 10)];
            [rightImage1 setImage:[UIImage imageNamed:@"right_while"]];
            [view addSubview:rightImage1];
            
        }else if (i == 1){
            self.countryCodeLa = lab;
            field.keyboardType = UIKeyboardTypeNumberPad;
            UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(30, 23, 75, 14)];
            [bt setBackgroundColor:UIColor.clearColor];
            [bt addTarget:self action:@selector(clickArea) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:bt];
            
            UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(78, 27, 10, 5)];
            [bottomImage setImage:[UIImage imageNamed:@"down_while"]];
            [view addSubview:bottomImage];
            
            
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inputMobile"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            self.phoneField = field;
        }else{
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inputPass"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.keyboardType = UIKeyboardTypeDefault;
            field.secureTextEntry = YES;
            UIButton *pwdBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 70, 22.5, 22, 15)];
            [pwdBt setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
            pwdBt.selected = YES;
            [pwdBt addTarget:self action:@selector(changeEyeState:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:pwdBt];
            self.pwField = field;
        }
    }
    
    NSArray *eArr = @[[UserDefaultLocationDic valueForKey:@"imailbox"],[UserDefaultLocationDic valueForKey:@"ipassword"]];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame) + 80, WIDTH, 120)];
    [bgImage addSubview:view2];
    self.emailView = view2;
    self.emailView.hidden = YES;
    
    for (int i = 0; i < eArr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [self.emailView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:eArr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(30, 23, 75, 14);
        [view addSubview:lab];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 30, 22, 220, 16)];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeDefault;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0xffffff);
        field.tintColor = TCUIColorFromRGB(0xffffff);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        [field addTarget:self  action:@selector(alueChange1:)  forControlEvents:UIControlEventEditingChanged];
        [view addSubview:field];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inputEmail"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            self.emailField = field;
            
        }else{
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inputPass"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.width = 180;
            self.epwdField = field;
            
            field.secureTextEntry = YES;
            UIButton *pwdBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 70, 22.5, 22, 15)];
            [pwdBt setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
            pwdBt.selected = YES;
            [pwdBt addTarget:self action:@selector(changeEyeState1:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:pwdBt];
        }
    }
    
    UIButton *loginBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(iconImage.frame) + 232, WIDTH - 48, 44)];
    loginBt.alpha = 0.5;
    loginBt.layer.masksToBounds = YES;
    loginBt.layer.cornerRadius = 7;
    [loginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    loginBt.userInteractionEnabled = NO;
    loginBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [loginBt setTitle:[UserDefaultLocationDic valueForKey:@"ilogin"] forState:(UIControlStateNormal)];
    [loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [loginBt addTarget:self action:@selector(clickLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:loginBt];
    self.loginBt = loginBt;
    
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"emailLogin"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *emailBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(loginBt.frame) + 20, size.width, 13)];
    [emailBt setTitle:[UserDefaultLocationDic valueForKey:@"emailLogin"] forState:(UIControlStateNormal)];
    [emailBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [emailBt addTarget:self action:@selector(emailLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    emailBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [bgImage addSubview:emailBt];
    
    
    CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"forgetPassword"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *forgetBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - size1.width - 25, CGRectGetMaxY(loginBt.frame) + 20, size1.width, 13)];
    [forgetBt setTitle:[UserDefaultLocationDic valueForKey:@"forgetPassword"] forState:(UIControlStateNormal)];
    [forgetBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [forgetBt addTarget:self action:@selector(ForgetPwd) forControlEvents:(UIControlEventTouchUpInside)];
    forgetBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [bgImage addSubview:forgetBt];
    
    
    NSArray *arr1 = @[@"WXLogin",@"GoogleLogin",@"FaceLogin",@"AppleLogin",@"line_icon1"];
                      //@"FaceLogin"];
    // 手机系统版本 不支持 时 隐藏苹果登录按钮
//    if (@available(iOS 13.0, *)) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
//    } else {
//        arr1 = @[@"WXLogin",@"GoogleLogin",@"FaceLogin"];
//    }
//
    
    CGFloat spacing = (WIDTH - 240)/6;
    for (int i = 0; i < arr1.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(spacing + (48 + spacing) * i, HEIGHT - 168, 48, 48)];
        [btn setImage:[UIImage imageNamed:arr1[i]] forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickThree:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgImage addSubview:btn];
    }
    
    UILabel *textLabel = [UILabel publicLab:@"登录即代表您已同意我们的《用户协议》和《隐私政策》" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    textLabel.preferredMaxLayoutWidth = 300;
    [textLabel setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    //textLabel.frame = CGRectMake((WIDTH - 300)/2, HEIGHT - 78, 280, 10);
    [bgImage addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((WIDTH - 300)/2);
            make.top.mas_equalTo(HEIGHT - 78);
            make.width.mas_equalTo(300);
    }];
    
    [textLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([UserDefaultLocationDic valueForKey:@"loginAgree"]).font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff));
        confer.text([UserDefaultLocationDic valueForKey:@"userAgree"]).font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff)).tapActionByLable(@"1");
        confer.text([NSString stringWithFormat:@"《%@》",[UserDefaultLocationDic valueForKey:@"yinsizc"]]).font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff)).tapActionByLable(@"2");
    }];
    
    [textLabel rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        MMClauseDetailVC *clauseVC = [[MMClauseDetailVC alloc]init];
        clauseVC.modalPresentationStyle = 0;
        clauseVC.isEnter1 = @"1";
        if([tapActionId isEqualToString:@"1"]){
            clauseVC.ID = @"4127";
        }else{
            clauseVC.ID = @"4126";
        }
        [weakself presentViewController:clauseVC animated:NO completion:nil];
    }];
    
    
    
    UIButton *selectBt = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 300)/2 - 20, HEIGHT - 80, 14, 14)];
    [selectBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    selectBt.selected = YES;
    [selectBt setImage:[UIImage imageNamed:@"selected"] forState:(UIControlStateNormal)];
    [selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:selectBt];
}

-(void)clickSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.isSelected){
        [sender setImage:[UIImage imageNamed:@"selected"] forState:(UIControlStateNormal)];
        self.isSelect = @"1";
    }else{
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:(UIControlStateNormal)];
        self.isSelect = @"0";
    }
    if([self.isPhone isEqualToString:@"1"]){
        if(self.phoneField.text.length > 0 && self.pwField.text.length > 0 && [self.isSelect isEqualToString:@"1"]){
            [self.loginBt setBackgroundColor:selectColor];
            [self.loginBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            self.loginBt.alpha = 1;
            self.loginBt.userInteractionEnabled = YES;
        }else{
            [self.loginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.loginBt.alpha = 0.5;
            [self.loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
            self.loginBt.userInteractionEnabled = NO;
        }
    }else{
        if(self.emailField.text.length > 0 && self.epwdField.text.length > 0 && [self.isSelect isEqualToString:@"1"]){
            [self.loginBt setBackgroundColor:selectColor];
            [self.loginBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            self.loginBt.alpha = 1;
            self.loginBt.userInteractionEnabled = YES;
        }else{
            [self.loginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.loginBt.alpha = 0.5;
            [self.loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
            self.loginBt.userInteractionEnabled = NO;
        }
    }
    
    
    
}

#pragma mark uitextfield delegate
-(void)alueChange:(UITextField *)textField{
    if(self.phoneField.text.length > 0 && self.pwField.text.length > 0 && [self.isSelect isEqualToString:@"1"]){
        [self.loginBt setBackgroundColor:selectColor];
        [self.loginBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.loginBt.alpha = 1;
        self.loginBt.userInteractionEnabled = YES;
    }else{
        [self.loginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.loginBt.alpha = 0.5;
        [self.loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.loginBt.userInteractionEnabled = NO;
    }
    
}

-(void)alueChange1:(UITextField *)textField{
    if(self.emailField.text.length > 0 && self.epwdField.text.length > 0 && [self.isSelect isEqualToString:@"1"]){
        [self.loginBt setBackgroundColor:selectColor];
        [self.loginBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.loginBt.alpha = 1;
        self.loginBt.userInteractionEnabled = YES;
    }else{
        [self.loginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.loginBt.alpha = 0.5;
        [self.loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.loginBt.userInteractionEnabled = NO;
    }
}



-(void)clickThree:(UIButton *)sender{
    KweakSelf(self);
    if(sender.tag == 100){
        [self sendAuthRequest];
    }else if (sender.tag == 101){
        [[GIDSignIn sharedInstance] signIn];
    }else if (sender.tag == 102){
        // 点击 Facebook 登录按钮的时候调用如下代码即可调用 Facebook 登录功能
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Process error");
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                [weakself getUserInfoWithResult:result];
            }
        }];
        

    }else if (sender.tag == 103){
        [self authorizationAppleID];
    }else if (sender.tag == 104){
        //line登录
        LineLogin *line = [LineLogin getSharedInstance];

        [line loginLineFromController:self completeWithError:^(LoginResultStatus loginStatus, NSString * _Nullable token, NSString * _Nullable name,NSURL * _Nullable pictureurl,  NSString * _Nullable emali ,NSError * _Nullable error) {
            if (loginStatus == LoginResultStatusSuccess) {
                NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                [param setValue:token forKey:@"openId"];
                [param setValue:self.tempcart forKey:@"tempcart"];
                [param setValue:@"0" forKey:@"RegSource"];
                [param setValue:@"7" forKey:@"type"];
                [param setValue:self.deviceToken forKey:@"SSID"];
                [param setValue:name forKey:@"name"];
                [param setValue:pictureurl forKey:@"photoUrl"];
                if(self.RegCode){
                    [param setValue:self.RegCode forKey:@"RegCode"];
                }
                [self threeLoginSave:param];
            } else if (loginStatus == LoginResultStatusCancelled) {

            } else if (loginStatus == LoginResultStatusError) {

            }
        }];
    }
}


- (void)getUserInfoWithResult:(FBSDKLoginManagerLoginResult *)result{
    KweakSelf(self);
    NSString *token = result.token.tokenString;
    NSDictionary*params= @{@"fields":@"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"};
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:result.token.userID
                                      parameters:params
                                      HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection * _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:token forKey:@"openId"];
        [param setValue:weakself.tempcart forKey:@"tempcart"];
        [param setValue:@"0" forKey:@"RegSource"];
        [param setValue:@"5" forKey:@"type"];
        [param setValue:result[@"name"] forKey:@"name"];
        [param setValue:result[@"picture"][@"data"][@"url"] forKey:@"photoUrl"];
        if(weakself.RegCode.length > 6){
            [param setValue:weakself.RegCode forKey:@"RegCode"];
        }
        [weakself fbLogin:param];
    }];
}


#pragma mark- 授权苹果ID
- (void)authorizationAppleID{
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
//        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        //如果 KeyChain 里面也有登录信息的话，可以直接使用里面保存的用户名和密码进行登录。
//        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];

        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
//        if (passwordRequest) {
//            [array addObject:passwordRequest];
//        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
         // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark- ASAuthorizationControllerDelegate
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString * userID = credential.user;
        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
//        // 苹果用户信息 如果授权过，可能无法再次获取该信息
        NSPersonNameComponents * fullName = credential.fullName;
        NSString * email = credential.email;
//
//        // 服务器验证需要使用的参数
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
//
//        // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;

        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:userID forKey:@"openId"];
        [param setValue:self.tempcart forKey:@"tempcart"];
        [param setValue:@"0" forKey:@"RegSource"];
        [param setValue:@"9" forKey:@"type"];
        [param setValue:self.deviceToken forKey:@"SSID"];
        if(self.RegCode){
            [param setValue:self.RegCode forKey:@"RegCode"];
        }
        [self threeLoginSave:param];
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = (ASPasswordCredential *)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString * user = passwordCredential.user;
        
        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
        
        // 密码凭证对象的密码
        NSString * password = passwordCredential.password;
        NSLog(@"userID: %@", user);
        NSLog(@"password: %@", password);
        
    } else {
        
    }
}
// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}
#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"%@", notification.userInfo);
}
- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
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
    

-(void)clickLogin{
    if([self.isPhone isEqualToString:@"1"]){
        if(self.pwField.text.length < 6){
            [ZTProgressHUD showMessage:@"密码错误请重新输入"];
        }else{
            [self requestLogin:self.phoneField.text andPWD:self.pwField.text andType:@"1"];
        }
    }else{
       BOOL isRight = [ZTBSUtils checkEmail:self.emailField.text];
        if(isRight){
            if(self.epwdField.text.length < 6){
                [ZTProgressHUD showMessage:@"密码错误请重新输入"];
            }else{
                [self requestLogin:self.emailField.text andPWD:self.epwdField.text andType:@"0"];
            }
            
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputConMail"]];
        }
    }
}

-(void)requestLogin:(NSString *)account andPWD:(NSString *)password andType:(NSString *)type{
    KweakSelf(self);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempcart = [userDefaults valueForKey:@"tempcart"];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoginSub"];
    NSDictionary *param = @{@"tempcart":tempcart,@"AccountName":account,@"AccountPassword":password,@"Currency_Bind":self.areaLabel.text,@"Currency":self.cry,@"AreaCode":self.countryCode,@"type":type,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
           [userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
            MMMemberInfoModel *model = [MMMemberInfoModel mj_objectWithKeyValues:jsonDic[@"memberInfo"]];
            [userDefaults setValue:model.ID forKey:@"userID"];
            [userDefaults setValue:model.Name forKey:@"name"];
            [userDefaults setValue:model.Sex_Bind forKey:@"Sex_bind"];
            [userDefaults setValue:model.Currency_Bind forKey:@"Currency_bind"];
            [userDefaults setValue:model.MobilePhone forKey:@"Phone"];
            [userDefaults setValue:model.Email forKey:@"Email"];
            weakself.userInfo = model;
            [userDefaults synchronize];
            
            [TalkingDataSDK onEvent:@"iOS原生-账号密码登录" parameters:@{@"membertoken":jsonDic[@"key"]}];
            //[TalkingDataSDK onEvent:@"" value:nice(<#int#>) parameters:nil];
//            TalkingDataProfile *profile = [TalkingDataProfile createProfile];
//            profile.type = TalkingDataProfileTypeRegistered;
//            [TalkingDataSDK onLogin:jsonDic[@"key"] profile:profile ];
            [weakself dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)emailLogin:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"邮箱登陆"]){
        [sender setTitle:@"手机登陆" forState:(UIControlStateNormal)];
        self.isPhone = @"0";
        self.phoneView.hidden = YES;
        self.emailView.hidden = NO;
    }else{
        [sender setTitle:@"邮箱登陆" forState:(UIControlStateNormal)];
        self.isPhone = @"1";
        self.phoneView.hidden = NO;
        self.emailView.hidden = YES;
    }
    
    
}

-(void)ForgetPwd{
    MMForgetPWDViewController *forgetVC = [[MMForgetPWDViewController alloc]init];
    forgetVC.modalPresentationStyle = 0;
    [self presentViewController:forgetVC animated:NO completion:nil];
}



-(void)changeEyeState:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.pwField.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.pwField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}

-(void)changeEyeState1:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.epwdField.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.epwdField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}
    


-(void)clickArea{
    KweakSelf(self);
    XYCountryCodeViewController *vc = [[XYCountryCodeViewController alloc] initWithShowType:XYCountryCodeShowTypeNone];
    [vc showViewController:self];
    [vc setChooseCodeRespose:^(NSString *code, NSString *area) {
        weakself.countryCode = code;
        weakself.areaLabel.text = area;
        weakself.countryCodeLa.text = [NSString stringWithFormat:@"+%@",code];
    }];
    
    
    
}


-(void)clickBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)jumpRegist{
    MMRegisterViewController *registVC = [[MMRegisterViewController alloc]init];
    registVC.modalPresentationStyle = 0;
    [self presentViewController:registVC animated:NO completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"登录页面"];
}

@end
