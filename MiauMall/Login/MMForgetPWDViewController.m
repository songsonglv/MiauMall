//
//  MMForgetPWDViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/13.
//  忘记密码

#import "MMForgetPWDViewController.h"
#import "MMAgainSetPassWordVC.h"

@interface MMForgetPWDViewController ()<UITextFieldDelegate>
{
    NSInteger timeCount;
    NSTimer *timer;
}
@property (nonatomic, strong) UITextField *accountField;//账号输入框
@property (nonatomic, strong) UITextField *codeField;//验证码输入框
@property (nonatomic, strong) UIButton *getCodeBt;//获取验证码
@property (nonatomic, strong) UIButton *sureBt;//确定按钮
@property (nonatomic, strong) NSString *isPhone;
@property (nonatomic, strong) NSString *type;//1 手机 0 邮箱
@end

@implementation MMForgetPWDViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [TalkingDataSDK onPageBegin:@"忘记密码页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, WIDTH, HEIGHT + 10)];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:@"https://app.miau2020.com/down/appview/login.jpg"] placeholderImage:[UIImage imageNamed:@"login_bg"]];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(24, StatusBarHeight + 14, 12, 18)];
    [returnBt setBackgroundImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickBack) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:returnBt];
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"zhPwd"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:26 numberOfLines:0];
    lab1.frame = CGRectMake(0, StatusBarHeight + 122, WIDTH, 26);
    [bgImage addSubview:lab1];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame) + 30, WIDTH, 120)];
    [bgImage addSubview:infoView];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"inputPhoneEmail"],[UserDefaultLocationDic valueForKey:@"verifyCode"]];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [infoView addSubview:view];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(35, 22, WIDTH - 70, 16)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
//        field.placeholder = arr[i];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeDefault;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0xffffff);
        field.tintColor = TCUIColorFromRGB(0xffffff);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
        [view addSubview:field];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            self.accountField = field;
        }else{
            field.frame = CGRectMake(35, 22, 150, 16);
            self.codeField = field;
            
            UIButton *getCodeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 204, 11, 180, 38)];
            getCodeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            getCodeBt.layer.masksToBounds = YES;
            getCodeBt.layer.cornerRadius = 19;
            getCodeBt.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
            getCodeBt.layer.borderWidth = 1;
            [getCodeBt setTitle:[UserDefaultLocationDic valueForKey:@"getCode"] forState:(UIControlStateNormal)];
            [getCodeBt addTarget:self action:@selector(clickGetCode:) forControlEvents:(UIControlEventTouchUpInside)];
            [getCodeBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            [view addSubview:getCodeBt];
            self.getCodeBt = getCodeBt;
        }
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(lab1.frame) + 184, WIDTH - 48, 44)];
    sureBt.alpha = 0.5;
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 7;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    sureBt.userInteractionEnabled = NO;
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:sureBt];
    self.sureBt = sureBt;
    
    UIButton *questionBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 125, CGRectGetMaxY(sureBt.frame) + 22, 90, 14)];
    questionBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [questionBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [questionBt setTitle:@"收不到验证吗?" forState:(UIControlStateNormal)];
    [questionBt addTarget:self action:@selector(clickQuestion) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:questionBt];
    questionBt.hidden = YES;
    
}

-(void)clickQuestion{
    [ZTProgressHUD showMessage:@"点击了收不到验证吗？请求接口？？？"];
}

-(void)clickSure{
    MMAgainSetPassWordVC *againVC = [[MMAgainSetPassWordVC alloc]init];
    againVC.accountName = self.accountField.text;
    againVC.VerifyCode = self.codeField.text;
    againVC.type = self.type;
    againVC.modalPresentationStyle = 0;
    [self presentViewController:againVC animated:NO completion:nil];
}

//获取验证码
-(void)clickGetCode:(UIButton *)sender{
    [self getCode];
    
    if(self.accountField.text.length > 0){
        timeCount = 60;
        sender.userInteractionEnabled = NO;
        sender.titleLabel.textAlignment = NSTextAlignmentRight;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
    }
    
}

//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    timeCount--;
    if (timeCount == 0) {
        [self.getCodeBt setTitle:[UserDefaultLocationDic valueForKey:@"reacquire"] forState:UIControlStateNormal];
        self.getCodeBt.userInteractionEnabled = YES;
        [self.getCodeBt addTarget:self action:@selector(clickGetCode:) forControlEvents:(UIControlEventTouchUpInside)];
        //停止定时器
        [timer invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"   %lus%@", (long)timeCount,[UserDefaultLocationDic valueForKey:@"reacquire"]];
        [self.getCodeBt setTitle:str forState:UIControlStateNormal];
        self.getCodeBt.userInteractionEnabled = NO;
    }
}

-(void)getCode{
    KweakSelf(self);
    NSDictionary *param = @{@"lang":@"0",@"cry":@"9"};
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCheckCode"];
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
    NSString *checkCodeStr = [AESCipher aesEncryptString:checkCode];
    NSString *isPhone;
    NSDictionary *param;
    
    if([ZTBSUtils checkEmail:self.accountField.text]){
        self.isPhone = @"0";
        self.type = @"1";
    }else{
        self.isPhone = @"1";
        self.type = @"0";
    }
    
    if([self.isPhone isEqualToString:@"1"]){
        param = @{@"AccountName":self.accountField.text,@"f":@"2",@"type":@"1",@"AreaCode":@"86",@"CheckCode":checkCodeStr,@"lang":@"0",@"cry":@"9"};
    }else{
        param = @{@"AccountName":self.accountField.text,@"f":@"2",@"type":@"0",@"AreaCode":@"86",@"CheckCode":checkCodeStr,@"lang":@"0",@"cry":@"9"};
    }
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCode"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"yzmSon"]];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)alueChange:(UITextField *)textField{
    [self isEnClick];
}

-(void)isEnClick{
    if(self.accountField.text.length > 0 && self.codeField.text.length > 0 ){
        [self.sureBt setBackgroundColor:selectColor];
        [self.sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.sureBt.alpha = 1;
        self.sureBt.userInteractionEnabled = YES;
    }else{
        [self.sureBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.sureBt.alpha = 0.5;
        [self.sureBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.sureBt.userInteractionEnabled = NO;
    }
}

-(void)clickBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"忘记密码页面"];
}

@end
