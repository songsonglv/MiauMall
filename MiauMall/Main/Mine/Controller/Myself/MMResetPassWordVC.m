//
//  MMResetPassWordVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//  重置密码

#import "MMResetPassWordVC.h"
#import "PooCodeView.h"
#import "MMForgetPWDViewController.h"

@interface MMResetPassWordVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *oldPwdField;
@property (nonatomic, strong) UITextField *nePwdField;
@property (nonatomic, strong) UITextField *againPwdField1;
@property (nonatomic, strong) UITextField *codePwdField;
@property (nonatomic, strong) PooCodeView *codeView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@end

@implementation MMResetPassWordVC

-(PooCodeView *)codeView{
    if(!_codeView){
        NSArray *randomArr = @[@"H",@"j",@"q",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        _codeView = [[PooCodeView alloc] initWithFrame:CGRectMake(WIDTH - 115, 20, 84, 26) andChangeArray:randomArr];
        //注意:文字高度不能大于poocodeview高度,否则crash
        _codeView.textSize = 18;
        //不设置为blackColor
        _codeView.textColor = [UIColor redColor];
    }
    return _codeView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"重置密码页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"pwdReset"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    NSArray *imageArr = @[@"lock_icon_black",@"lock_icon_black",@"lock_icon_black",@"code_icon_black"];
    NSArray *placeArr = @[[UserDefaultLocationDic valueForKey:@"inputSourcePwd"],[UserDefaultLocationDic valueForKey:@"newPwdAgain"],[UserDefaultLocationDic valueForKey:@"inputPwdAgain"],[UserDefaultLocationDic valueForKey:@"inputImgCode"]];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 62, WIDTH - 20, 260)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    [self.view addSubview:bgView];
    
    for (int i = 0; i < placeArr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,65 * i, WIDTH, 65)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [bgView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(38, 23, 16, 20)];
        iconImage.image = [UIImage imageNamed:imageArr[i]];
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
            self.oldPwdField = field1;
            self.oldPwdField.secureTextEntry = !btn.selected;
        }else if (i == 1){
            self.nePwdField = field1;
            self.nePwdField.secureTextEntry = !btn.selected;
        }else if (i == 2){
            self.againPwdField1 = field1;
            self.againPwdField1.secureTextEntry = !btn.selected;
        }else{
            self.codePwdField = field1;
            self.codePwdField.secureTextEntry = NO;
            btn.hidden = YES;
            [view addSubview:self.codeView];
        }
    }
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"zhPwd"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    UIButton *retrieveBt = [[UIButton alloc]init];
//    [retrieveBt setBackgroundColor:TCUIColorFromRGB(0xaeaeae)];
    [retrieveBt setTitle:[UserDefaultLocationDic valueForKey:@"zhPwd"] forState:(UIControlStateNormal)];
    [retrieveBt setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
    retrieveBt.titleLabel.font = [UIFont fontWithName:@"PingfangSC-Regular" size:14];
    retrieveBt.layer.masksToBounds = YES;
    retrieveBt.layer.cornerRadius = 14;
    [retrieveBt addTarget:self action:@selector(jumpRetrieve) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:retrieveBt];
    
    [retrieveBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(CGRectGetMaxY(bgView.frame) + 24);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(28);
    }];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(30,HEIGHT - 90, WIDTH - 60, 54)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 27;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xe13916)];
    [sureBt setTitle:@"保存" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBt];
}

-(void)clickBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.tag == 100){
        self.oldPwdField.secureTextEntry = !sender.selected;
    }else if (sender.tag == 101){
        self.nePwdField.secureTextEntry = !sender.selected;
    }else if (sender.tag == 102){
        self.againPwdField1.secureTextEntry = !sender.selected;
    }
}


-(void)jumpRetrieve{
    MMForgetPWDViewController *forgetVC = [[MMForgetPWDViewController alloc]init];
    forgetVC.modalPresentationStyle = 0;
    [self presentViewController:forgetVC animated:nil completion:nil];
}

#pragma mark -- 修改密码
-(void)clickSave{
    if(self.oldPwdField.text.length > 0 && self.nePwdField.text.length > 0 && self.againPwdField1.text.length > 0 && self.codePwdField.text.length >0){
        if([self.codePwdField.text isEqualToString:self.codeView.changeString]){
            if(self.nePwdField.text.length >= 6 && self.nePwdField.text.length < 20){
                if([self.nePwdField.text isEqualToString:self.againPwdField1.text]){
                    [self requestSavePwd];
                }else{
                    [ZTProgressHUD showMessage:@"两次密码输入不相同"];
                }
            }else{
                [ZTProgressHUD showMessage:@"密码必须由6-20位字符组成"];
            }
        }else{
            [ZTProgressHUD showMessage:@"请重新输入图形验证码"];
        }
    }else{
        [ZTProgressHUD showMessage:@"请将信息填写完整"];
    }
}

-(void)requestSavePwd{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"UpdatePass"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.oldPwdField.text forKey:@"oldpass"];
    [param setValue:self.nePwdField.text forKey:@"updatepass"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
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
    [TalkingDataSDK onPageEnd:@"重置密码页面"];
}
@end
