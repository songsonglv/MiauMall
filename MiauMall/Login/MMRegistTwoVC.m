//
//  MMRegistTwoVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/13.
//

#import "MMRegistTwoVC.h"
#import "BRStringPickerView.h"

@interface MMRegistTwoVC ()<UITextFieldDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *invitationField;//邀请码
@property (nonatomic, strong) UITextField *pwdField;//邀请码
@property (nonatomic, strong) UITextField *againPwdField;//邀请码
@property (nonatomic, strong) UITextField *birthdayField;//邀请码
@property (nonatomic, strong) UITextField *sexField;//邀请码
@property (nonatomic, strong) UIButton *uploadBt;
@property (nonatomic, strong) NSString *isSelected;//是否选中 默认未选中 0

@end

@implementation MMRegistTwoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [TalkingDataSDK onPageBegin:@"注册第二步"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = @"0";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.areaCode = [self.userDefaults valueForKey:@"areaCode"];
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
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"RegistXin"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:26 numberOfLines:0];
    lab1.frame = CGRectMake(0, StatusBarHeight + 122, WIDTH, 26);
    [bgImage addSubview:lab1];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"yqCode"],[UserDefaultLocationDic valueForKey:@"ipassword"],[UserDefaultLocationDic valueForKey:@"ipassword"],[UserDefaultLocationDic valueForKey:@"ibirthday"],[UserDefaultLocationDic valueForKey:@"igender"]];
    NSArray *arr1 = @[[UserDefaultLocationDic valueForKey:@"noLimitCoupon"],[UserDefaultLocationDic valueForKey:@"inputPwd"],[UserDefaultLocationDic valueForKey:@"inputComPwd"],[UserDefaultLocationDic valueForKey:@"mustBirth"],[UserDefaultLocationDic valueForKey:@"igender"]];
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame) + 30, WIDTH, 300)];
    [bgImage addSubview:infoView];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60 * i, WIDTH, 60)];
        [infoView addSubview:view];
        
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(25, 22, size.width, 15);
        [view addSubview:lab];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 22, 185, 16)];
        field.delegate = self;
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr1[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xeeeeee)}];
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0xffffff);
        field.tintColor = TCUIColorFromRGB(0xffffff);
//        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        field.keyboardType = UIKeyboardTypeDefault;
        [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
        [view addSubview:field];
        
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 45, 27, 14, 7)];
        rightImage.image = [UIImage imageNamed:@"down_while"];
        [view addSubview:rightImage];
        
        UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 48, 24, 18, 12)];
        rightBt.selected = YES;
        [rightBt setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
        [view addSubview:rightBt];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 59, WIDTH - 48, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view addSubview:line];
        
        if(i == 0){
            field.width = 210;
            self.invitationField = field;
            rightBt.hidden = YES;
            rightImage.hidden = YES;
        }else if (i == 1){
            [field setSecureTextEntry:YES];
            self.pwdField = field;
            rightImage.hidden = YES;
            [rightBt addTarget:self action:@selector(changeEye1:) forControlEvents:(UIControlEventTouchUpInside)];
        }else if (i == 2){
            [field setSecureTextEntry:YES];
            self.againPwdField = field;
            rightImage.hidden = YES;
            [rightBt addTarget:self action:@selector(changeEye2:) forControlEvents:(UIControlEventTouchUpInside)];
        }else if (i == 3){
            [field setEnabled:NO];
            self.birthdayField = field;
            rightBt.hidden = YES;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, WIDTH - 100, 60)];
            [btn addTarget:self action:@selector(selectBirthday) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }else{
            [field setEnabled:NO];
            self.sexField = field;
            rightBt.hidden = YES;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, WIDTH - 100, 60)];
            [btn addTarget:self action:@selector(selectSex) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(lab1.frame) + 391, WIDTH - 48, 44)];
    sureBt.alpha = 0.5;
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 7;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    sureBt.userInteractionEnabled = NO;
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"icomplete"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickUpload) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:sureBt];
    self.uploadBt = sureBt;
    
    UILabel *textLabel = [UILabel publicLab:@"注册即代表您已同意我们的《用户协议》和《隐私政策》" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
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
        NSLog(@"%@",tapActionId);
    }];
    
    UIButton *selectBt = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 300)/2 - 20, HEIGHT - 80, 14, 14)];
    [selectBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    selectBt.selected = NO;
    [selectBt setImage:[UIImage imageNamed:@"select_normal"] forState:(UIControlStateNormal)];
    [selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:selectBt];
}


-(void)clickSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.isSelected){
        [sender setImage:[UIImage imageNamed:@"selected"] forState:(UIControlStateNormal)];
        self.isSelected = @"1";
    }else{
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:(UIControlStateNormal)];
        self.isSelected = @"0";
    }
    [self isEnClick];
}

#pragma mark uitextfield delegate
-(void)alueChange:(UITextField *)textField{
    [self isEnClick];
}


-(void)changeEye1:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.pwdField.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.pwdField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}

-(void)changeEye2:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.againPwdField.secureTextEntry = YES;
    [sender setImage:[UIImage imageNamed:@"eye_no"] forState:(UIControlStateNormal)];
    }else{
        self.againPwdField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eye"] forState:(UIControlStateNormal)];
    }
}

-(void)selectBirthday{
    [self.invitationField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    [self.againPwdField resignFirstResponder];
    KweakSelf(self);
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeDate;
    datePickerView.title = [UserDefaultLocationDic valueForKey:@"ibirthday"];
    datePickerView.pickerStyle.doneTextColor = selectColor;
    datePickerView.pickerStyle.doneBtnTitle = [UserDefaultLocationDic valueForKey:@"iconfirm"];
    
    // datePickerView.selectValue = @"2019-10-30";
    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        weakself.birthdayField.text = selectValue;
        [weakself isEnClick];
    };
    // 设置自定义样式
//    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
//    customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
//    customStyle.pickerTextColor = [UIColor redColor];
//    customStyle.separatorColor = [UIColor redColor];
//    datePickerView.pickerStyle = customStyle;

    // 3.显示
    [datePickerView show];
}

-(void)selectSex{
    KweakSelf(self);
    [self.invitationField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    [self.againPwdField resignFirstResponder];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.pickerStyle.doneTextColor = selectColor;
    stringPickerView.pickerStyle.doneBtnTitle = [UserDefaultLocationDic valueForKey:@"iconfirm"];
    stringPickerView.title = [UserDefaultLocationDic valueForKey:@"igender"];
    stringPickerView.dataSourceArr = @[[UserDefaultLocationDic valueForKey:@"imale"], [UserDefaultLocationDic valueForKey:@"ifemale"]];
    stringPickerView.selectIndex = 2;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        weakself.sexField.text = resultModel.value;
        [weakself isEnClick];
    };

    [stringPickerView show];
}

-(void)isEnClick{
    KweakSelf(self);
    if(weakself.pwdField.text.length > 0 && weakself.againPwdField.text.length > 0 && weakself.birthdayField.text.length > 0 && weakself.sexField.text.length > 0 && [self.isSelected isEqualToString:@"1"]){
        [weakself.uploadBt setBackgroundColor:selectColor];
        [weakself.uploadBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        weakself.uploadBt.alpha = 1;
        weakself.uploadBt.userInteractionEnabled = YES;
    }else{
        [weakself.uploadBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        weakself.uploadBt.alpha = 0.5;
        [weakself.uploadBt setTitleColor:TCUIColorFromRGB(0x626261) forState:(UIControlStateNormal)];
        weakself.uploadBt.userInteractionEnabled = NO;
    }
}

-(void)clickUpload{
    KweakSelf(self);
    NSString *sex;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    
    if([self.sexField.text isEqualToString:[userDefaults valueForKey:@"imale"]]){
        sex = @"1";
    }else{
        sex = @"2";
    }
    NSDictionary *param = @{@"Sex":sex,@"Sex_Bind    ":self.sexField.text,@"RegCode":self.invitationField.text,@"AccountName":self.AccountName,@"AccountPassword":self.pwdField.text,@"AccountPassword1":self.againPwdField.text,@"Birth":self.birthdayField.text,@"Currency":self.cry,@"type":@"1",@"AreaCode":self.areaCode,@"tempcart":self.tempcart,@"RegSource":@"0",@"lang":self.lang,@"cry":self.cry};
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"RegSub"];
    if([self.pwdField.text isEqualToString:self.againPwdField.text] ){
        if(self.pwdField.text.length >= 6){
            [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
                NSLog(@"%@",jsonDic);
                NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                if([code isEqualToString:@"1"]){
                    [ZTProgressHUD showMessage:jsonDic[@"msg"]];
                    [userDefaults setValue:jsonDic[@"key"] forKey:@"membertoken"];
                    [userDefaults synchronize];
//                    TalkingDataProfile *talkprofile = [TalkingDataProfile createProfile];
//                    talkprofile.type = TalkingDataProfileTypeRegistered;
//                    if([weakself.sexField.text isEqualToString:[UserDefaultLocationDic valueForKey:@"imale"]]){
//                        talkprofile.gender = TalkingDataGenderMale;
//                    }else if ([weakself.sexField.text isEqualToString:[UserDefaultLocationDic valueForKey:@"ifemale"]]){
//                        talkprofile.gender = TalkingDataGenderFemale;
//                    }else{
//                        talkprofile.gender = TalkingDataGenderUnknown;
//                    }
//                    talkprofile.name = weakself.AccountName;
//
//                    [TalkingDataSDK onRegister:jsonDic[@"key"] profile:talkprofile invitationCode:weakself.invitationField.text];
                    [TalkingDataSDK onEvent:@"iOS-注册" parameters:@{@"membertoken":jsonDic[@"key"]}];
                    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [ZTProgressHUD showMessage:jsonDic[@"msg"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else{
            [ZTProgressHUD showMessage:[userDefaults valueForKey:@"miniSixPass"]];
        }
        
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"diffPass"]];
    }
}

-(void)clickBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark -- 生成随机数

- (NSString *)generateTradeNO:(NSInteger )num

{
    NSString *sourceStr = @"0123456789abcdef";

    NSMutableString *resultStr = [[NSMutableString alloc] init];

    srand((unsigned)time(0));

    for (int i = 0; i < num; i++)

    {

        unsigned index = rand() % [sourceStr length];

        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];

        [resultStr appendString:oneStr];

    }

    return resultStr;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"注册第二步"];
}

@end
