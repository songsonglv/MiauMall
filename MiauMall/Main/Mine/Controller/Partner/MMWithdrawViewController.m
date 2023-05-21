//
//  MMWithdrawViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMWithdrawViewController.h"
#import "MMPartnerAccountModel.h"
#import "MMSelectAccountModel.h"
#import "MMWithDrawPopView.h"
#import "MMPartnerAddAccountVC.h"

@interface MMWithdrawViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *Type;//账户type与ID拼接 如1_39
@property (nonatomic, strong) NSMutableArray *accountArr;//账户数组
@property (nonatomic, strong) MMSelectAccountModel *selectModel;
@property (nonatomic, strong) MMPartnerAccountModel *model;//选择的账户
@property (nonatomic, strong) UIImageView *payIcon;
@property (nonatomic, strong) UILabel *accountNameLa;
@property (nonatomic, strong) UILabel *accontNoLa;
@property (nonatomic, strong) UILabel *banlanceLa;
@property (nonatomic, strong) UILabel *feeLa;
@property (nonatomic, strong) UILabel *minMoneyLa;
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) MMWithDrawPopView *popView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//单选，当前选中的

@end

@implementation MMWithdrawViewController

-(NSMutableArray *)accountArr{
    if(!_accountArr){
        _accountArr = [NSMutableArray array];
    }
    return _accountArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"提现页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addCountSuccess" object:nil];
    self.view.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"tiXian"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self setUI];
    
//    [self requestAccountList];
}

-(void)refreshData{
    [self requestAccountList];
}

-(void)requestAccountList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];//搜索可以传name
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyAccountList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPartnerAccountModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.accountArr = [NSMutableArray arrayWithArray:arr];
            NSDictionary *dic = @{@"ID":@"0",@"Type":@"3"};
            MMPartnerAccountModel *model = [MMPartnerAccountModel mj_objectWithKeyValues:dic];
            [weakself.accountArr addObject:model];
            if(arr.count > 0){
                MMPartnerAccountModel *model = arr[0];
                weakself.model = model;
                if([model.Type isEqualToString:@"0"]){
                    weakself.payIcon.image = [UIImage imageNamed:@"ali_pay_icon"];
                    weakself.accountNameLa.text = [UserDefaultLocationDic valueForKey:@"zfbAccount"];
                    weakself.accontNoLa.text= model.AccountNo;
                }else if ([model.Type isEqualToString:@"1"]){
                    weakself.payIcon.image = [UIImage imageNamed:@"wx_pay_icon"];
                    weakself.accountNameLa.text = [UserDefaultLocationDic valueForKey:@"weChatAccount"];
                    weakself.accontNoLa.text= model.AccountNo;
                }else if ([model.Type isEqualToString:@"2"]){
                    weakself.payIcon.image = [UIImage imageNamed:@"pal_pay_icon"];
                    weakself.accountNameLa.text = [UserDefaultLocationDic valueForKey:@"bankAccount"];
                    weakself.accontNoLa.text= model.AccountNo;
                }else{
                    
                }
            }
            
            [weakself requestSelectData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestSelectData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    if(self.model){
        if([self.model.Type isEqualToString:@"3"]){
            [param setValue:@"3" forKey:@"Type"];
        }else{
            self.Type = [NSString stringWithFormat:@"%@_%@",self.model.Type,self.model.ID];
            [param setValue:self.Type forKey:@"Type"];
        }
    }else{
        [param setValue:@"3" forKey:@"Type"];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSelectAccount"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.selectModel = [MMSelectAccountModel mj_objectWithKeyValues:jsonDic];
            weakself.banlanceLa.text = [NSString stringWithFormat:@"%@JPY%@",[UserDefaultLocationDic valueForKey:@"nowMoney"],weakself.selectModel.YongBalance];
            weakself.feeLa.text = [NSString stringWithFormat:@"(%@%@JPY",[UserDefaultLocationDic valueForKey:@"tixianServiceMoney"],weakself.selectModel.ExtractFees];
            weakself.minMoneyLa.text = [NSString stringWithFormat:@"%@JPY)",weakself.selectModel.Extract];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(27, StatusBarHeight + 76, 60, 60)];
    iconImage.image = [UIImage imageNamed:@"miau_pay_icon"];
    [self.view addSubview:iconImage];
    self.payIcon = iconImage;
    
    UILabel *nameLa = [UILabel publicLab:@"MIAU钱包" textColor:TCUIColorFromRGB(0x494645) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:nameLa];
    self.accountNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(StatusBarHeight + 82);
            make.height.mas_equalTo(16);
    }];
    
    UILabel *noLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x5a5a5a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    noLa.preferredMaxLayoutWidth = 200;
    [noLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:noLa];
    self.accontNoLa = noLa;
    
    [noLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(18);
            make.height.mas_equalTo(12);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:@"right_icon_black"];
    [self.view addSubview:rightImage];
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-32);
            make.top.mas_equalTo(StatusBarHeight + 92);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(16);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 76, WIDTH, 60)];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UILabel *lab1 = [UILabel publicLab:@"提现金额" textColor:TCUIColorFromRGB(0x52504f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    [self.view addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.top.mas_equalTo(StatusBarHeight + 168);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(17);
    }];
    
    UILabel *signLa = [UILabel publicLab:@"JPY" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:19 numberOfLines:0];
    signLa.frame = CGRectMake(26, StatusBarHeight + 232, 37, 17);
    [self.view addSubview:signLa];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(68, StatusBarHeight + 215, WIDTH - 90, 48)];
//    field.backgroundColor = TCUIColorFromRGB(0xffffff);
    field.delegate = self;
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inputTiXianMoney"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
    field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:20];
    field.textColor = textBlackColor2;
    field.textAlignment = NSTextAlignmentLeft;
    field.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:field];
    self.moneyField = field;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, StatusBarHeight + 265, WIDTH - 40, 0.5)];
    line1.backgroundColor = TCUIColorFromRGB(0xdedede);
    [self.view addSubview:line1];
    
    UILabel *balanceLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"nowMoney"] textColor:TCUIColorFromRGB(0x5a5a5a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    balanceLa.preferredMaxLayoutWidth = 250;
    [balanceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:balanceLa];
    self.banlanceLa = balanceLa;
    
    [balanceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(CGRectGetMaxY(line1.frame) + 20);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"allTixian"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    
    UIButton *allBt = [[UIButton alloc]init];
    [allBt setTitle:[UserDefaultLocationDic valueForKey:@"allTixian"] forState:(UIControlStateNormal)];
    [allBt setTitleColor:TCUIColorFromRGB(0xff625b) forState:(UIControlStateNormal)];
    allBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [allBt addTarget:self action:@selector(clickAll) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:allBt];
    
    [allBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(balanceLa.mas_right).offset(2);
            make.top.mas_equalTo(CGRectGetMaxY(line1.frame) + 20);
            make.width.mas_equalTo(size.width + 8);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *feeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xff655a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    feeLa.preferredMaxLayoutWidth = 180;
    [feeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:feeLa];
    self.feeLa = feeLa;
    
    [feeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(balanceLa.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"mintixianMoney"] textColor:TCUIColorFromRGB(0x727272) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = 180;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(feeLa.mas_right).offset(5);
            make.top.mas_equalTo(balanceLa.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *minLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xff625b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    minLa.preferredMaxLayoutWidth = 120;
    [minLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:minLa];
    self.minMoneyLa = minLa;
    
    [minLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab2.mas_right).offset(1);
            make.top.mas_equalTo(balanceLa.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
    }];
    
    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 350, WIDTH - 20, 72)];
    tipsView.backgroundColor = TCUIColorFromRGB(0xffffff);
    tipsView.layer.masksToBounds = YES;
    tipsView.layer.cornerRadius = 7;
    tipsView.layer.borderColor = TCUIColorFromRGB(0xdedede).CGColor;
    tipsView.layer.borderWidth = 0.5;
    [self.view addSubview:tipsView];
    
    UIImageView *tipsIcon = [[UIImageView alloc]init];
    tipsIcon.image = [UIImage imageNamed:@"tips_icon"];
    [tipsView addSubview:tipsIcon];
    
    [tipsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(12);
    }];
    
    UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"tixianTips"] textColor:TCUIColorFromRGB(0xff625b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab3.preferredMaxLayoutWidth = 300;
    [lab3 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [tipsView addSubview:lab3];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size1 = [NSString sizeWithText:[NSString stringWithFormat:@"%@ %@",[UserDefaultLocationDic valueForKey:@"tixianTipsInfo"],[UserDefaultLocationDic valueForKey:@"tixianTipsInfo2"]] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 40,MAXFLOAT)];
    
    UILabel *lab4 = [UILabel publicLab:[NSString stringWithFormat:@"%@ %@",[UserDefaultLocationDic valueForKey:@"tixianTipsInfo"],[UserDefaultLocationDic valueForKey:@"tixianTipsInfo2"]] textColor:TCUIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab4.preferredMaxLayoutWidth = WIDTH - 40;
    [lab4 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [tipsView addSubview:lab4];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(lab3.mas_bottom).offset(5);
            make.width.mas_equalTo(WIDTH - 40);
    }];
    
    tipsView.height = size1.height + 40;
    
    UIButton *withdrawBt = [[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT - 180, WIDTH - 20, 60)];
    [self setView:withdrawBt andCorlors:@[TCUIColorFromRGB(0xff7650),TCUIColorFromRGB(0xff5f5d)]];
    [withdrawBt setTitle:[UserDefaultLocationDic valueForKey:@"tiXian"] forState:(UIControlStateNormal)];
    [withdrawBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    withdrawBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    withdrawBt.layer.masksToBounds = YES;
    withdrawBt.layer.cornerRadius = 9;
    [withdrawBt addTarget:self action:@selector(clickWithdraw) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:withdrawBt];
    
    [self requestAccountList];
}

//提现请求
-(void)clickWithdraw{
    KweakSelf(self);
    float money = [self.moneyField.text floatValue];
    if(self.moneyField.text.length > 0 && money > 0){
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];//搜索可以传name
        
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ApplyExtract"];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        [param setValue:self.model.Type forKey:@"FundsType"];
        [param setValue:self.model.ID forKey:@"AccountID"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [param setValue:self.moneyField.text forKey:@"ApplyMoney"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
       
        
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputTrueMoney"]];
    }
    
}

#pragma mark -- fielddelegate
-(void)alueChange:(UITextField *)field{
    float money = [field.text floatValue];
    float banlance = [self.selectModel.YongBalance floatValue];
    if(money > banlance){
        field.text = self.selectModel.YongBalance;
    }
}

-(void)clickAll{
    self.moneyField.text = self.selectModel.YongBalance;
}

-(void)clickBtn{
    KweakSelf(self);
    self.popView = [[MMWithDrawPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.accountArr];
    self.popView.selectedIndexPath = self.selectedIndexPath;
    self.popView.addCountBlock = ^(NSString * _Nonnull str) {
        [weakself addCount];
    };
    self.popView.clickJump = ^(MMPartnerAccountModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        weakself.model = model;
        weakself.selectedIndexPath = indexPath;
        [weakself requestSelectData];
        if([model.Type isEqualToString:@"0"]){
            weakself.payIcon.image = [UIImage imageNamed:@"ali_pay_icon"];
            weakself.accountNameLa.text = @"支付宝账户";
            weakself.accontNoLa.text = model.AccountNo;
        }else if ([model.Type isEqualToString:@"1"]){
            weakself.payIcon.image = [UIImage imageNamed:@"wx_pay_icon"];
            weakself.accountNameLa.text = @"微信账户";
            weakself.accontNoLa.text = model.AccountNo;
        }else if ([model.Type isEqualToString:@"2"]){
            weakself.payIcon.image = [UIImage imageNamed:@"paypal_pay_icon"];
            weakself.accountNameLa.text = @"银行卡账户";
            weakself.accontNoLa.text = model.AccountNo;
        }else{
            weakself.payIcon.image = [UIImage imageNamed:@"miau_pay_icon"];
            weakself.accountNameLa.text = @"Miau钱包";
            weakself.accontNoLa.text = model.AccountNo;
        }
    };
  
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addCount{
    MMPartnerAddAccountVC *addVC = [[MMPartnerAddAccountVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"提现页面"];
}

@end
