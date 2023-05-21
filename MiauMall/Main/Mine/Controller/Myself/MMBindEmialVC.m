//
//  MMBindEmialVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/19.
//

#import "MMBindEmialVC.h"

@interface MMBindEmialVC () <UITextFieldDelegate>
{
    NSInteger timeCount;
    NSTimer *timer;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UITextField *psField;
@property (nonatomic, strong) UITextField *againPsField;
@property (nonatomic, strong) UIButton *codeBt;//验证码按钮
@end

@implementation MMBindEmialVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"绑定邮箱页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"emailBind"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UILabel *tiLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"emailBind"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    tiLa.frame = CGRectMake(35, StatusBarHeight + 80, WIDTH - 70, 16);
    [self.view addSubview:tiLa];
    
    NSArray *arr;
    if(self.model.memberInfo.AccountPassword.length > 0){
        arr = @[[UserDefaultLocationDic valueForKey:@"inputEmail"],[UserDefaultLocationDic valueForKey:@"checkEmail"]];
    }else{
        arr = @[[UserDefaultLocationDic valueForKey:@"inputEmail"],[UserDefaultLocationDic valueForKey:@"checkEmail"],[UserDefaultLocationDic valueForKey:@"inputPwd"],[UserDefaultLocationDic valueForKey:@"inputPwdAgain"]];
    }
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(tiLa.frame) + 32 + 74 * i, WIDTH - 44, 42)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 21;
        view.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
        view.layer.borderWidth = 0.5;
        [self.view addSubview:view];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 44, 22)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xa09f9f)}];
        field.delegate = self;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = textBlackColor2;
        field.textAlignment = NSTextAlignmentLeft;
        [view addSubview:field];
        
        if(i == 0){
            self.emailField = field;
            if(self.model.memberInfo.Email.length > 0){
                self.emailField.text = self.model.memberInfo.Email;
            }
        }else if (i == 1){
            field.width = 200;
            self.codeField = field;
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:[UserDefaultLocationDic valueForKey:@"getCode"] forState:(UIControlStateNormal)];
            [btn setTitleColor:redColor2 forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            btn.titleLabel.textAlignment = NSTextAlignmentRight;
            [btn addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(10);
                            make.top.mas_equalTo(15);
                            make.width.mas_equalTo(180);
                            make.height.mas_equalTo(12);
            }];
            self.codeBt = btn;
            
        }
        
        if(self.model.memberInfo.AccountPassword.length == 0){
            if(i == 2){
                self.psField = field;
            }else if (i == 3){
                self.againPsField = field;
            }
        }
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(tiLa.frame) + 74 * (arr.count + 1), WIDTH - 44, 42)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"emailBind"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    sureBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 21;
    [self.view addSubview:sureBt];
    
}


-(void)getCode1{
    timeCount = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
}

-(void)getCode{
    BOOL isRight = [ZTBSUtils checkEmail:self.emailField.text];
    if(isRight == YES){
        KweakSelf(self);
        self.codeBt.userInteractionEnabled = NO;
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCode"];
        
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [param setValue:self.emailField.text forKey:@"AccountName"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"yzmSon"]];
                [self getCode1];
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
                weakself.codeBt.userInteractionEnabled = YES;
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputCorEmail"]];
    }
    
}


//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    timeCount--;
    if (timeCount == 0) {
        [self.codeBt setTitle:[UserDefaultLocationDic valueForKey:@"reacquire"] forState:UIControlStateNormal];
        self.codeBt.userInteractionEnabled = YES;
        [self.codeBt addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        //停止定时器
        [timer invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"%lus%@", (long)timeCount,[UserDefaultLocationDic valueForKey:@"reacquire"]];
        [self.codeBt setTitle:str forState:UIControlStateNormal];
    }
}

-(void)clickSave{
    BOOL isRight = [ZTBSUtils checkEmail:self.emailField.text];
    if(isRight == NO){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputCorEmail"]];
        return;
    }else if (self.codeField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"checkEmail"]];
        return;
    }else if(self.model.memberInfo.AccountPassword.length == 0){
        if(self.psField.text.length == 0){
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputPwd"]];
        }else if (self.againPsField.text.length == 0){
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputPwdAgain"]];
        }else if ([self.psField.text isEqualToString:self.againPsField.text]){
            [self EmailBind];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"erroPwd"]];
        }
    }else{
        [self EmailBind];
    }
        
}

-(void)EmailBind{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"EmailBind"];
    
    [param setValue:self.memberToken forKey:@"membertoken"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.emailField.text forKey:@"Email"];
    [param setValue:self.codeField.text forKey:@"VerifyCode"];
    if(self.model.memberInfo.AccountPassword.length == 0){
        [param setValue:self.psField.text forKey:@"AccountPassWord"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BindEmailSuccess" object:nil];
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
    [TalkingDataSDK onPageEnd:@"绑定邮箱页面"];
}


@end
