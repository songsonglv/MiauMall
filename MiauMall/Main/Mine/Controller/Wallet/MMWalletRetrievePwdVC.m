//
//  MMWalletRetrievePwdVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/5.
//

#import "MMWalletRetrievePwdVC.h"
#import "MMWalletViewController.h"

@interface MMWalletRetrievePwdVC ()<UITextFieldDelegate>
{
    NSInteger timeCount;
    NSTimer *timer;
}
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *codePwdField;
@property (nonatomic, strong) UITextField *nePwdField;
@property (nonatomic, strong) UITextField *againPwdField1;


@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *getCodeBt1;

@end

@implementation MMWalletRetrievePwdVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"找回支付密码页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"retrievePwd"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetLiveBroadcasts"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.emailField.text = jsonDic[@"Email"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    NSArray *imgArr = @[@"email_icon_black",@"code_icon_black",@"lock_icon_black",@"lock_icon_black"];
    NSArray *placeArr = @[[UserDefaultLocationDic valueForKey:@"inputEmail"],[UserDefaultLocationDic valueForKey:@"checkEmail"],[UserDefaultLocationDic valueForKey:@"inputZfPwd"],[UserDefaultLocationDic valueForKey:@"zcinputZfPwd"]];
    for (int i = 0; i < imgArr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 87 + 65 * i, WIDTH, 65)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.view addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(38, 23, 16, 20)];
        iconImage.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:iconImage];
        
        UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(77, 23, 150, 20)];
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeArr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
        field1.delegate = self;
        field1.secureTextEntry = YES;
        field1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        field1.textColor = textBlackColor2;
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentLeft;
        [view addSubview:field1];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:@"eye_yes_black"] forState:(UIControlStateSelected)];
        [btn setImage:[UIImage imageNamed:@"eye_no_black"] forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-38);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(18);
                    make.height.mas_equalTo(12);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(30, 64.5, WIDTH - 60, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdedede);
        [view addSubview:line];
        
        if(i == 0){
            iconImage.frame = CGRectMake(37, 25, 20, 16);
            btn.hidden = YES;
            field1.width = 250;
            self.emailField = field1;
            self.emailField.secureTextEntry = NO;
            [self.emailField setEnabled:NO];
        }else if (i == 1){
            btn.hidden = YES;
            self.codePwdField = field1;
            self.codePwdField.secureTextEntry = NO;
            UIButton *codeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 130, 16, 100, 32)];
            [codeBt setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [codeBt setTitleColor:TCUIColorFromRGB(0x231815) forState:(UIControlStateNormal)];
            codeBt.titleLabel.font = [UIFont fontWithName:@"PingfangSC-Regular" size:15];
            codeBt.layer.masksToBounds = YES;
            codeBt.layer.cornerRadius = 16;
            codeBt.layer.borderColor = TCUIColorFromRGB(0x000000).CGColor;
            codeBt.layer.borderWidth = 0.5;
            [codeBt addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:codeBt];
            self.getCodeBt1 = codeBt;
        }else if (i == 2){
            self.nePwdField = field1;
        }else{
            self.againPwdField1 = field1;
        }
    }
    
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(30,HEIGHT - 140, WIDTH - 60, 54)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 27;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xe13916)];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"isubmit"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBt];
    
    [self requestData];
}

//获取验证码
-(void)clickCode{
    timeCount = 60;
    self.getCodeBt1.userInteractionEnabled = NO;
    self.getCodeBt1.titleLabel.textAlignment = NSTextAlignmentCenter;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
}

-(void)getCode{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCode"];
    [param setValue:self.emailField.text forKey:@"AccountName"];
    [param setValue:@"1" forKey:@"f"];
    [param setValue:@"0" forKey:@"type"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD hide];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"yzmSon"]];
            [weakself clickCode];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    timeCount--;
    if (timeCount == 0) {
        [self.getCodeBt1 setTitle:[UserDefaultLocationDic valueForKey:@"reacquire"] forState:UIControlStateNormal];
        self.getCodeBt1.userInteractionEnabled = YES;
        [self.getCodeBt1 addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        //停止定时器
        [timer invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"%lus%@", (long)timeCount,[UserDefaultLocationDic valueForKey:@"reacquire"]];
        [self.getCodeBt1 setTitle:str forState:UIControlStateNormal];
        self.getCodeBt1.userInteractionEnabled = NO;
    }
}

-(void)clickSave{
    if(self.codePwdField.text.length > 0 && self.nePwdField.text.length > 0 && self.againPwdField1.text.length > 0){
        if([self.nePwdField.text isEqualToString:self.againPwdField1.text]){
            [self saveData];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"diffPass"]];
        }
    }else{
        [ZTProgressHUD showMessage:@"请将信息填写完整"];
    }
}

-(void)saveData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CheckPaymentPasswordCode"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.nePwdField.text forKey:@"PaymentPassword"];
    [param setValue:self.codePwdField.text forKey:@"VerifyCode"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself clickReturn];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.tag == 102){
        self.nePwdField.secureTextEntry = !sender.selected;
    }else if (sender.tag == 103){
        self.againPwdField1.secureTextEntry = !sender.selected;
    }
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[MMWalletViewController class]]){
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"找回支付密码y页面"];
}

@end
