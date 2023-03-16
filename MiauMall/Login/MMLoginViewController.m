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



@interface MMLoginViewController ()<UITextFieldDelegate>
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
@end

@implementation MMLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"登录页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSelect = @"1";
    self.isPhone = @"1";
    self.countryCode = @"86";
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, WIDTH, HEIGHT + 10)];
    bgImage.image = [UIImage imageNamed:@"login_bg"];
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
    [rightBt setTitle:@"注册" forState:(UIControlStateNormal)];
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
    
    NSArray *arr = @[@"国家/地区",@"+86  ",@"登陆密码"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        view.backgroundColor = UIColor.clearColor;
        [self.phoneView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(30, 23, 75, 14);
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
            UILabel *areaLa = [UILabel publicLab:@"中国" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
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
            
            
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            self.phoneField = field;
        }else{
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
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
    
    NSArray *eArr = @[@"邮箱",@"密码"];
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
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入邮箱地址" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            self.emailField = field;
            
        }else{
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
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
    [loginBt setTitle:@"登陆" forState:(UIControlStateNormal)];
    [loginBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [loginBt addTarget:self action:@selector(clickLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:loginBt];
    self.loginBt = loginBt;
    
    
    UIButton *emailBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(loginBt.frame) + 20, 66, 13)];
    [emailBt setTitle:@"邮箱登陆" forState:(UIControlStateNormal)];
    [emailBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [emailBt addTarget:self action:@selector(emailLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    emailBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [bgImage addSubview:emailBt];
    
    UIButton *forgetBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 90, CGRectGetMaxY(loginBt.frame) + 20, 66, 13)];
    [forgetBt setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    [forgetBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [forgetBt addTarget:self action:@selector(ForgetPwd) forControlEvents:(UIControlEventTouchUpInside)];
    forgetBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [bgImage addSubview:forgetBt];
    
    
    NSArray *arr1 = @[@"WXLogin",@"GoogleLogin",@"FaceLogin",@"AppleLogin"];
    CGFloat spacing = (WIDTH - 192 - 90)/2;
    for (int i = 0; i < arr1.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(spacing + 78 * i, HEIGHT - 168, 48, 48)];
        [btn setImage:[UIImage imageNamed:arr1[i]] forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickThree:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgImage addSubview:btn];
    }
    
    UILabel *textLabel = [UILabel publicLab:@"登录即代表您已同意我们的《用户协议》和《隐私政策》" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    textLabel.frame = CGRectMake((WIDTH - 300)/2, HEIGHT - 78, 280, 10);
    [bgImage addSubview:textLabel];
    [textLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"登录即代表您已同意我们的").font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff));
        confer.text(@"《用户协议》").font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff)).tapActionByLable(@"1");
        confer.text(@"和").font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff));
        confer.text(@"《隐私政策》").font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0xffffff)).tapActionByLable(@"2");
    }];
    
    [textLabel rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        NSLog(@"%@",tapActionId);
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
    if(sender.tag == 100){
        [ZTProgressHUD showMessage:@"点击wx"];
    }else if (sender.tag == 101){
        [ZTProgressHUD showMessage:@"点击google"];
    }else if (sender.tag == 102){
        [ZTProgressHUD showMessage:@"点击face"];
    }else if (sender.tag == 103){
        [ZTProgressHUD showMessage:@"点击apple"];
    }
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
            [ZTProgressHUD showMessage:@"请输入正确的邮箱地址"];
        }
    }
}

-(void)requestLogin:(NSString *)account andPWD:(NSString *)password andType:(NSString *)type{
    KweakSelf(self);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempcart = [userDefaults valueForKey:@"tempcart"];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoginSub"];
    NSDictionary *param = @{@"tempcart":tempcart,@"AccountName":account,@"AccountPassword":password,@"Currency_Bind":@"中国",@"Currency":@"9",@"AreaCode":self.countryCode,@"type":type,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
           [userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
            MMMemberInfoModel *model = [MMMemberInfoModel mj_objectWithKeyValues:jsonDic[@"memberInfo"]];
            [userDefaults setValue:model.ID forKey:@"userID"];
            [userDefaults setValue:model.Name forKey:@"name"];
            weakself.userInfo = model;
            [userDefaults synchronize];
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
    [TalkingDataSDK onPageEnd:@"登录页面"];
}

@end
