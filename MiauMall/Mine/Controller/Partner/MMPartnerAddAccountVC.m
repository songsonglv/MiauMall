//
//  MMPartnerAddAccountVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//  合伙人添加账号

#import "MMPartnerAddAccountVC.h"
#import "MMMemberInfoModel.h"
#import "MMSelectAccountTypePopView.h"

@interface MMPartnerAddAccountVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *typeLa;
@property (nonatomic, strong) UITextField *accountField;//账号 wx alipay

//银行卡
@property (nonatomic, strong) UITextField *bankCardField;//卡号
@property (nonatomic, strong) UITextField *nameField;//开户人
@property (nonatomic, strong) UITextField *openCardField;//开户行

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIView *view1;//wx或者alipay
@property (nonatomic, strong) UIView *view2;//银行卡
@property (nonatomic, strong) MMMemberInfoModel *infoModel;//会员信息
@property (nonatomic, strong) NSString *type;//0 aliPay 1 wxPAy 2bank
@property (nonatomic, strong) MMSelectAccountTypePopView *typePopView;
@end

@implementation MMPartnerAddAccountVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"添加提现账户页面"];
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"添加账户";
    if(self.titleStr){
        titleView.titleLa.text = self.titleStr;
    }
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    self.typePopView = [[MMSelectAccountTypePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.typePopView.selectTypeBlcok = ^(NSString * _Nonnull typeStr, NSString * _Nonnull str) {
        weakself.type = typeStr;
        weakself.typeLa.text = str;
        if([typeStr isEqualToString:@"2"]){
            weakself.view1.hidden = YES;
            weakself.view2.hidden = NO;
        }else{
            weakself.view1.hidden = NO;
            weakself.view2.hidden = YES;
        }
    };
    
    if(self.model){
        self.type = self.model.Type;
    }
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.infoModel = [MMMemberInfoModel mj_objectWithKeyValues:jsonDic[@"memberInfo"]];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UILabel *helloLa = [UILabel publicLab:@"您好，" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:25 numberOfLines:0];
    helloLa.preferredMaxLayoutWidth = 100;
    [helloLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:helloLa];
    
    [helloLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(32);
            make.top.mas_equalTo(StatusBarHeight + 88);
            make.height.mas_equalTo(25);
    }];
    
    if(self.infoModel){
        
    }
    
    UILabel *nickLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:19 numberOfLines:0];
    nickLa.preferredMaxLayoutWidth = 200;
    [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:nickLa];
    
    if(self.infoModel){
        nickLa.text = self.infoModel.Name;
    }else{
        nickLa.text = [self.userDefaults valueForKey:@"name"];
    }
    
    [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(helloLa.mas_right).offset(5);
            make.top.mas_equalTo(StatusBarHeight + 91);
            make.height.mas_equalTo(19);
    }];
    
    UILabel *typeLa1 = [UILabel publicLab:@"类型" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    [self.view addSubview:typeLa1];
    
    [typeLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(32);
            make.top.mas_equalTo(helloLa.mas_bottom).offset(50);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(17);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"right_icon_black"];
    [self.view addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-34);
            make.top.mas_equalTo(helloLa.mas_bottom).offset(53);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(14);
    }];
    
    
    UILabel *typeLa = [UILabel publicLab:@"请选择提现类型" textColor:textBlackColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    typeLa.preferredMaxLayoutWidth = 200;
    [typeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:typeLa];
    
    [typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iconImage.mas_left).offset(-12);
            make.top.mas_equalTo(helloLa.mas_bottom).offset(51);
            make.height.mas_equalTo(17);
    }];
    self.typeLa = typeLa;
    
    UIButton *selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 154, WIDTH, 42)];
    [selectBt setBackgroundColor:UIColor.clearColor];
    [selectBt addTarget:self action:@selector(clickSelectType) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:selectBt];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = TCUIColorFromRGB(0xdedede);
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(typeLa.mas_bottom).offset(14);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(0.5);
    }];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 196, WIDTH, 75)];
    view1.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view1];
    self.view1 = view1;
    
    UILabel *lab = [UILabel publicLab:@"账号" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 120;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view1 addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(32);
            make.centerY.mas_equalTo(view1);
            make.height.mas_equalTo(17);
    }];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, WIDTH - 172, 55)];
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入绑定账号" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
    field.delegate = self;
    field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    field.textColor = textBlackColor2;
    field.tintColor = TCUIColorFromRGB(0xb1b1b0);
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:field];
    self.accountField = field;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 74.5, WIDTH - 40, 0.5)];
    line2.backgroundColor = TCUIColorFromRGB(0xdedede);
    [view1 addSubview:line2];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 196, WIDTH, 225)];
    view2.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view2];
    self.view2 = view2;
    NSArray *arr = @[@"银行卡账号",@"户名",@"开户行"];
    NSArray *placehArr = @[@"请输入绑定账号",@"请输入帐号户名",@"请输入开户行名"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 75 * i, WIDTH, 75)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [view2 addSubview:view];
        
        UILabel *lab1 = [UILabel publicLab:arr[i] textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 120;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(32);
                make.centerY.mas_equalTo(view);
                make.height.mas_equalTo(17);
        }];
        
        UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, WIDTH - 172, 55)];
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placehArr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
        field1.delegate = self;
        field1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        field1.textColor = textBlackColor2;
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentRight;
        [view addSubview:field1];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 74.5, WIDTH - 40, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdedede);
        [view addSubview:line];
        
        if(i == 0){
            self.bankCardField = field1;
        }else if (i == 1){
            self.nameField = field1;
        }else{
            self.openCardField = field1;
        }
    }
    view2.hidden = YES;
    
    if(self.model){
        if([self.model.Type isEqualToString:@"0"]){
            self.typeLa.text = @"支付宝";
            view1.hidden = NO;
            view2.hidden = YES;
            self.accountField.text = self.model.AccountNo;
        }else if ([self.model.Type isEqualToString:@"1"]){
            self.typeLa.text = @"微信";
            view1.hidden = NO;
            view2.hidden = YES;
            self.accountField.text = self.model.AccountNo;
        }else{
            self.typeLa.text = @"银行卡";
            view1.hidden = YES;
            view2.hidden = NO;
            self.bankCardField.text = self.model.AccountNo;
            self.nameField.text = self.model.AccountName;
            self.openCardField.text =  self.model.AccountBank;
        }
       
    }
    
    UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT - 116 - 60, WIDTH - 20, 60)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [addBt setBackgroundImage:[UIImage imageNamed:@"add_account_bg"] forState:(UIControlStateNormal)];
    [addBt setTitle:@"添加" forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBt];
}

-(void)clickSelectType{
    [[UIApplication sharedApplication].keyWindow addSubview:self.typePopView];
    [self.typePopView showView];
}

-(void)clickAdd{
    if(!self.type){
        [ZTProgressHUD showMessage:@"请选择提现类型"];
    }else{
        if([self.type isEqualToString:@"0"]){
            if(self.accountField.text.length == 0){
                [ZTProgressHUD showMessage:@"请输入您的支付宝账号"];
            }else{
                [self requestSaveData];
            }
        }else if ([self.type isEqualToString:@"1"]){
            if(self.accountField.text.length == 0){
                [ZTProgressHUD showMessage:@"请输入您的微信账号"];
            }else{
                [self requestSaveData];
            }
        }else if ([self.type isEqualToString:@"2"]){
            if(self.bankCardField.text.length == 0 || self.openCardField.text == 0 || self.nameField.text.length == 0){
                [ZTProgressHUD showMessage:@"请将银行卡信息填写完整"];
            }else{
                [self requestSaveData];
            }
        }
    }
}

-(void)requestSaveData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SaveMyAccount"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.model){
        [param setValue:self.model.ID forKey:@"ID"];
    }
    [param setValue:self.type forKey:@"Type"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if([self.type isEqualToString:@"2"]){
        [param setValue:self.bankCardField.text forKey:@"AccountNo"];
        [param setValue:self.nameField.text forKey:@"AccountName"];
        [param setValue:self.openCardField.text forKey:@"AccountBank"];
    }else{
        [param setValue:self.accountField.text forKey:@"AccountNo"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCountSuccess" object:nil];
        }
        
        [weakself clickReturn];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"添加提现账户页面"];
}
@end
