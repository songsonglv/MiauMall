//
//  MMAgainSetPassWordVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/13.
//  重新设置密码

#import "MMAgainSetPassWordVC.h"

@interface MMAgainSetPassWordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *pwdFied;//新密码输入框
@property (nonatomic, strong) UITextField *againField;//确认密码输入框
@property (nonatomic, strong) UIButton *saveBt;//保存按钮

@end

@implementation MMAgainSetPassWordVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [TalkingDataSDK onPageEnd:@"重新设置密码页面"];
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
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"pwdReset"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:26 numberOfLines:0];
    lab1.frame = CGRectMake(0, StatusBarHeight + 122, WIDTH, 26);
    [bgImage addSubview:lab1];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame) + 30, WIDTH, 120)];
    [bgImage addSubview:infoView];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"inputNewPwd"],[UserDefaultLocationDic valueForKey:@"inputAgainPwd"]];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [infoView addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(35, 22, 180, 16)];
        [field setSecureTextEntry:YES];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeDefault;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0xffffff);
        field.tintColor = TCUIColorFromRGB(0xffffff);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
        [view addSubview:field];
        
        UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 64, 22, 24, 16)];
        rightBt.selected = YES;
        [rightBt setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
        [view addSubview:rightBt];
        
        if(i == 0){
            self.pwdFied = field;
            [rightBt addTarget:self action:@selector(changeEye1:) forControlEvents:(UIControlEventTouchUpInside)];
        }else{
            self.againField = field;
            [rightBt addTarget:self action:@selector(changeEye2:) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    UILabel *tipsLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"pwdRange"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    tipsLa.frame = CGRectMake(36, CGRectGetMaxY(lab1.frame) + 170, WIDTH - 72, 12);
    [bgImage addSubview:tipsLa];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(tipsLa.frame) + 20, WIDTH - 48, 44)];
    sureBt.alpha = 0.5;
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 7;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    sureBt.userInteractionEnabled = NO;
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"isave"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:sureBt];
    self.saveBt = sureBt;
}

-(void)changeEye1:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.pwdFied.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.pwdFied.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}

-(void)changeEye2:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.againField.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.againField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}

-(void)clickSave{
    if([self.pwdFied.text isEqualToString:self.againField.text]){
        [self requestSave];
      }else{
        [ZTProgressHUD showMessage: [UserDefaultLocationDic valueForKey:@"erroPwd"]];
    }
}

-(void)requestSave{
    NSDictionary *param = @{@"AccountPassword":self.pwdFied.text,@"AccountPassword1":self.againField.text,@"AccountName":self.accountName,@"VerifyCode":self.VerifyCode,@"AreaCode":@"86",@"type":self.type,@"lang":@"0",@"cry":@"9"};
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ResetPass"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"setSuccess"]];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)alueChange:(UITextField *)fied{
    if(self.pwdFied.text.length > 0 && self.againField.text.length > 0 ){
        [self.saveBt setBackgroundColor:selectColor];
        [self.saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        self.saveBt.alpha = 1;
        self.saveBt.userInteractionEnabled = YES;
    }else{
        [self.saveBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.saveBt.alpha = 0.5;
        [self.saveBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        self.saveBt.userInteractionEnabled = NO;
    }
}

-(void)clickBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"重新设置密码页面"];
}
@end
