//
//  MMRegisterViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/12.
//  注册页面 f 1 注册 2 找回密码 type 手机 1 邮箱 0

#import "MMRegisterViewController.h"
#import "XYCountryCodeViewController.h"//国家地区选择页面
#import "MMRegistTwoVC.h"

@interface MMRegisterViewController ()<UITextFieldDelegate>
{
    NSInteger timeCount;
    NSTimer *timer;
    NSInteger timeCount1;
    NSTimer *timer1;
}
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UIButton *registBt;

@property (nonatomic, strong) NSString *isPhone;//是否手机号注册 默认1
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *areaCodeLa;//国家区号
@property (nonatomic, strong) UITextField *phoneField;//手机号输入框
@property (nonatomic, strong) UITextField *codeField;//验证码输入框
@property (nonatomic, strong) UIButton *getCodeBt1;//获取手机号验证码

@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailField;//邮箱输入框
@property (nonatomic, strong) UITextField *ecodeField;//邮箱验证码输入框
@property (nonatomic, strong) UIButton *getCodeBt2;//获取邮箱验证码


@end

@implementation MMRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [TalkingDataSDK onPageBegin:@"注册第一步页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPhone = @"1";
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, WIDTH, HEIGHT + 10)];
    bgImage.image = [UIImage imageNamed:@"login_bg"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(24, StatusBarHeight + 14, 12, 18)];
    [returnBt setBackgroundImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickBack) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:returnBt];
    
    UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 74, StatusBarHeight + 16, 74, 16)];
//    [rightBt setBackgroundColor:UIColor.blueColor];
    [rightBt setTitle:@"邮箱注册" forState:(UIControlStateNormal)];
    [rightBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    rightBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [rightBt addTarget:self action:@selector(changeMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:rightBt];
    
    UILabel *lab1 = [UILabel publicLab:@"手机账号注册" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:26 numberOfLines:0];
    lab1.frame = CGRectMake(0, StatusBarHeight + 121, WIDTH, 26);
    [bgImage addSubview:lab1];
    self.titleLa = lab1;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLa.frame) + 30, WIDTH, 120)];
    [bgImage addSubview:view1];
    self.phoneView = view1;
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [self.phoneView addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            UILabel *codeLa = [UILabel publicLab:@"+86" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
            codeLa.frame = CGRectMake(24, 23, 52, 14);
            [view addSubview:codeLa];
            self.areaCodeLa = codeLa;
            
            UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(codeLa.frame), 27.5, 10, 5)];
            downImage.image = [UIImage imageNamed:@"down_while"];
            [view addSubview:downImage];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(24, 0, 62, 60)];
            [btn addTarget:self action:@selector(clickArea) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(downImage.frame) + 40, 22, 180, 16)];
//            field.placeholder = @"";
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入联系电话" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.keyboardType = UIKeyboardTypeNumberPad;
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            field.textColor = TCUIColorFromRGB(0xffffff);
            field.tintColor = TCUIColorFromRGB(0xffffff);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
            [view addSubview:field];
            self.phoneField = field;
        }else{
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(35, 22, 120, 16)];
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.keyboardType = UIKeyboardTypeNumberPad;
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            field.textColor = TCUIColorFromRGB(0xffffff);
            field.tintColor = TCUIColorFromRGB(0xffffff);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
            [view addSubview:field];
            self.codeField = field;
            
            UIButton *getCodeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 134, 11, 110, 38)];
            getCodeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            getCodeBt.layer.masksToBounds = YES;
            getCodeBt.layer.cornerRadius = 19;
            getCodeBt.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
            getCodeBt.layer.borderWidth = 1;
            [getCodeBt setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [getCodeBt addTarget:self action:@selector(clickGetCode1:) forControlEvents:(UIControlEventTouchUpInside)];
            [getCodeBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            [view addSubview:getCodeBt];
            self.getCodeBt1 = getCodeBt;
        }
    }
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLa.frame) + 30, WIDTH, 120)];
    [bgImage addSubview:view2];
    self.emailView = view2;
    self.emailView.hidden = YES;
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [self.emailView addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            UILabel *codeLa = [UILabel publicLab:@"邮箱" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
            codeLa.frame = CGRectMake(24, 23, 52, 14);
            [view addSubview:codeLa];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(130, 22, 180, 16)];
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入电子邮箱" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.keyboardType = UIKeyboardTypeDefault;
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            field.textColor = TCUIColorFromRGB(0xffffff);
            field.tintColor = TCUIColorFromRGB(0xffffff);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [field addTarget:self  action:@selector(alueChange1:)  forControlEvents:UIControlEventEditingChanged];
            [view addSubview:field];
            self.emailField = field;
        }else{
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(35, 22, 120, 16)];
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
            field.keyboardType = UIKeyboardTypeNumberPad;
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            field.textColor = TCUIColorFromRGB(0xffffff);
            field.tintColor = TCUIColorFromRGB(0xffffff);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [field addTarget:self  action:@selector(alueChange1:)  forControlEvents:UIControlEventEditingChanged];
            [view addSubview:field];
            self.ecodeField = field;
            
            UIButton *getCodeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 134, 11, 110, 38)];
            getCodeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            getCodeBt.layer.masksToBounds = YES;
            getCodeBt.layer.cornerRadius = 19;
            getCodeBt.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
            getCodeBt.layer.borderWidth = 1;
            [getCodeBt setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [getCodeBt addTarget:self action:@selector(clickGetCode2:) forControlEvents:(UIControlEventTouchUpInside)];
            [getCodeBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            [view addSubview:getCodeBt];
            self.getCodeBt2 = getCodeBt;
        }
    }
    
    
    
    UIButton *registBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(self.titleLa.frame) + 184, WIDTH - 48, 44)];
    registBt.alpha = 0.5;
    registBt.layer.masksToBounds = YES;
    registBt.layer.cornerRadius = 7;
    [registBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    registBt.userInteractionEnabled = NO;
    registBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [registBt setTitle:@"确定" forState:(UIControlStateNormal)];
    [registBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [registBt addTarget:self action:@selector(clickRegist) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:registBt];
    self.registBt = registBt;
}

//获取验证码
-(void)clickGetCode1:(UIButton *)sender{
    [self getCode];
    timeCount = 60;
    sender.userInteractionEnabled = NO;
    sender.titleLabel.textAlignment = NSTextAlignmentRight;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
}

//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    timeCount--;
    if (timeCount == 0) {
        [self.getCodeBt1 setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeBt1.userInteractionEnabled = YES;
        [self.getCodeBt1 addTarget:self action:@selector(clickGetCode1:) forControlEvents:(UIControlEventTouchUpInside)];
        //停止定时器
        [timer invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"   %lus重新获取", (long)timeCount];
        [self.getCodeBt1 setTitle:str forState:UIControlStateNormal];
        self.getCodeBt1.userInteractionEnabled = NO;
    }
}

//获取验证码
-(void)clickGetCode2:(UIButton *)sender{
    if([ZTBSUtils checkEmail:self.emailField.text]){
        [self getCode];
        timeCount1 = 60;
        sender.userInteractionEnabled = NO;
        sender.titleLabel.textAlignment = NSTextAlignmentRight;
        timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime1:) userInfo:nil repeats:YES];
    }else{
        [ZTProgressHUD showMessage:@"请输入正确的邮箱地址"];
    }
    
}

//定时器触发事件
- (void)reduceTime1:(NSTimer *)coderTimer{
    timeCount1--;
    if (timeCount1 == 0) {
        [self.getCodeBt2 setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeBt2.userInteractionEnabled = YES;
        [self.getCodeBt2 addTarget:self action:@selector(clickGetCode2:) forControlEvents:(UIControlEventTouchUpInside)];
        //停止定时器
        [timer1 invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"   %lus重新获取", (long)timeCount1];
        [self.getCodeBt2 setTitle:str forState:UIControlStateNormal];
        self.getCodeBt2.userInteractionEnabled = NO;
    }
}

-(void)getCode{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCheckCode"];
    NSDictionary *param = @{@"lang":@"0",@"cry":@"9"};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself getCode1:jsonDic[@"CheckCode"]];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)getCode1:(NSString *)checkCode{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCode"];
    NSString *checkCodeStr = [AESCipher aesEncryptString:checkCode];
    NSDictionary *param;
    
    if([self.isPhone isEqualToString:@"1"]){
        param = @{@"AccountName":self.phoneField.text,@"f":@"1",@"type":@"1",@"AreaCode":@"86",@"CheckCode":checkCodeStr,@"lang":@"0",@"cry":@"9"};
    }else{
        param = @{@"AccountName":self.emailField.text,@"f":@"1",@"type":@"0",@"AreaCode":@"86",@"CheckCode":checkCodeStr,@"lang":@"0",@"cry":@"9"};
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:@"验证码已发送"];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark uitextfield delegate
-(void)alueChange:(UITextField *)textField{
    if(self.phoneField.text.length > 0 && self.codeField.text.length > 0 ){
        [self.registBt setBackgroundColor:selectColor];
        [self.registBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.registBt.alpha = 1;
        self.registBt.userInteractionEnabled = YES;
    }else{
        [self.registBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.registBt.alpha = 0.5;
        [self.registBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.registBt.userInteractionEnabled = NO;
    }
}

-(void)alueChange1:(UITextField *)textField{
    if(self.emailField.text.length > 0 && self.ecodeField.text.length > 0 ){
        [self.registBt setBackgroundColor:selectColor];
        [self.registBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.registBt.alpha = 1;
        self.registBt.userInteractionEnabled = YES;
    }else{
        [self.registBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.registBt.alpha = 0.5;
        [self.registBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.registBt.userInteractionEnabled = NO;
    }
    
}

-(void)clickRegist{
    [self checkVercode];
}

-(void)checkVercode{
    KweakSelf(self);
    NSDictionary *param;
    if([self.isPhone isEqualToString:@"1"]){
        param = @{@"t":@"CheckCode",@"AccountName":self.phoneField.text,@"VerifyCode":self.codeField.text,@"Currency":@"0",@"AreaCode":@"86",@"type":@"1",@"lang":@"0",@"cry":@"9"};
    }else{
        param = @{@"t":@"CheckCode",@"AccountName":self.emailField.text,@"VerifyCode":self.ecodeField.text,@"Currency":@"0",@"AreaCode":@"86",@"type":@"1",@"lang":@"0",@"cry":@"9"};
    }
    [ZTNetworking FormPostRequestUrl:@BaseUrl RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                MMRegistTwoVC *twoVC = [[MMRegistTwoVC alloc]init];
                if([weakself.isPhone isEqualToString:@"1"]){
                    twoVC.AccountName = weakself.phoneField.text;
                }else{
                    twoVC.AccountName = weakself.emailField.text;
                }
                twoVC.modalPresentationStyle = 0;
                [weakself presentViewController:twoVC animated:NO completion:nil];
            }else{
                [ZTProgressHUD showMessage: jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
   
}

-(void)clickArea{
    XYCountryCodeViewController *vc = [[XYCountryCodeViewController alloc] initWithShowType:XYCountryCodeShowTypeNone];
    [vc showViewController:self];
    [vc setChooseCodeRespose:^(NSString *code, NSString *area) {
        self.areaCodeLa.text = [NSString stringWithFormat:@"+%@",code];
    }];
    
}

-(void)changeMethod:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"邮箱注册"]){
        [sender setTitle:@"手机注册" forState:(UIControlStateNormal)];
        self.isPhone = @"0";
        self.phoneView.hidden = YES;
        self.emailView.hidden = NO;
        self.titleLa.text = @"邮箱账号注册";
    }else{
        [sender setTitle:@"邮箱注册" forState:(UIControlStateNormal)];
        self.isPhone = @"1";
        self.phoneView.hidden = NO;
        self.emailView.hidden = YES;
        self.titleLa.text = @"手机账号注册";
    }
}

-(void)clickBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"注册第一步页面"];
}


@end
