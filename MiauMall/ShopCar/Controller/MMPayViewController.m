//
//  MMPayViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMPayViewController.h"
#import "MMPassWordPopView.h"
#import "MMPaySuccessVC.h"

@interface MMPayViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *isCombined; //是否组合支付
@property (nonatomic, strong) UIButton *selectBt; //选中按钮
@property (nonatomic, strong) UIButton *balanceBt; //余额支付按钮
@property (nonatomic, strong) NSMutableArray *payArr;
@property (nonatomic, assign) NSInteger type;//支付方式 支付宝 0 微信1 信用卡2 余额3
@property (nonatomic, strong) NSString *PaymentPassword;//余额密码
@property (nonatomic, strong) MMTitleContentPopView *popView;
@property (nonatomic, strong) MMPassWordPopView *passPopView;
@end

@implementation MMPayViewController

-(NSMutableArray *)payArr{
    if(!_payArr){
        _payArr = [NSMutableArray array];
    }
    return _payArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"支付页面"];
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"待支付";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    NSString *str = [NSString stringWithFormat:@"您的订单在%@内未支付将被取消，请尽快完成支付。",self.model.PayTime];
    self.popView = [[MMTitleContentPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:@"确认要放弃付款？" andContent:str andCancleText:@"残忍取消" andSureText:@"继续支付"];
    
    self.popView.tapCancleBlcok = ^(NSString * _Nonnull index) {
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.popView.tapGoonBlock = ^(NSString * _Nonnull index) {
       
    };
    self.passPopView = [[MMPassWordPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.passPopView.returnPassBlock = ^(NSString * _Nonnull password) {
        weakself.PaymentPassword = password;
        [weakself CheckPaymentPassword];
    };
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UILabel *moneyLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    moneyLa.frame = CGRectMake(0, StatusBarHeight + 86, WIDTH, 30);
    [self.view addSubview:moneyLa];
    
    NSArray *temp = [self.model.PayMoneyShow componentsSeparatedByString:@" "];
    NSString *str = temp[0];
    NSString *str1 = temp[1];
    NSArray *temp1 = [str1 componentsSeparatedByString:@"."];
    NSString *str2 = temp1[0];
    NSString *str3 = [NSString stringWithFormat:@".%@",temp1[1]];
    [moneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(str).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        confer.text(str2).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:36]);
        confer.text(str3).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
    }];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(moneyLa.frame) + 42, WIDTH - 10, 500)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 7.5;
    [self.view addSubview:bgView];
    
   
    NSMutableArray *iconArr = [NSMutableArray array];
    if([self.model.CanAlipayPay isEqualToString:@"1"]){
        [self.payArr addObject:@"支付宝"];
        [iconArr addObject:@"ali_pay_icon"];
    }
    if([self.model.CanWeixinPay isEqualToString:@"1"]){
        [self.payArr addObject:@"微信支付"];
        [iconArr addObject:@"wx_pay_icon1"];
    }
    if([self.model.CanUnionPay isEqualToString:@"1"]){
        [self.payArr addObject:@"银联支付"];
        [iconArr addObject:@"union_pay_icon1"];
    }
    if([self.model.CanPayPal isEqualToString:@"1"]){
        [self.payArr addObject:@"PayPal支付"];
        [iconArr addObject:@"paypal_pay_icon"];
    }
    if([self.model.CanCardPay isEqualToString:@"1"]){
        [self.payArr addObject:@"信用卡支付"];
        [iconArr addObject:@"card_pay_icon"];
    }
    if([self.model.CanBalancePay isEqualToString:@"1"]){
        [self.payArr addObject:@"余额支付"];
        [iconArr addObject:@"balance_pay_icon"];
    }
    
    float balance = [self.model.MyBalance floatValue];
    float payMoney = [self.model.PayMoney floatValue];
    
    for (int i = 0; i < self.payArr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * i, WIDTH - 10, 50)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [bgView addSubview:view];
        
        UIImageView *payIcon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 11, 28, 28)];
        payIcon.image = [UIImage imageNamed:iconArr[i]];
        payIcon.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:payIcon];
        
        UILabel *lab = [UILabel publicLab:self.payArr[i] textColor:TCUIColorFromRGB(0x111111) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(58);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(15);
        }];
        
        UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 48, 16, 18, 18)];
        [rightBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [rightBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        rightBt.tag = 100 + i;
//        [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [rightBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:30];
        [view addSubview:rightBt];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 49.5, WIDTH - 34, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
        [view addSubview:line];
        
        if(balance < payMoney){
            
            if(i == 0){
                rightBt.selected = YES;
                self.selectBt = rightBt;
            }
        }
        
        if([self.model.CanBalancePay isEqualToString:@"1"]){
            if(i == self.payArr.count - 1){
                UILabel *balanceLa = [UILabel publicLab:[NSString stringWithFormat:@"（可用%@）",self.model.MyBalanceShow] textColor:TCUIColorFromRGB(0x7f7f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
                balanceLa.preferredMaxLayoutWidth = 200;
                [balanceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:balanceLa];
                
                [balanceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(lab.mas_right).offset(2);
                                    make.centerY.mas_equalTo(view);
                                    make.height.mas_equalTo(11);
                }];
                
                UILabel *tipLa = [UILabel publicLab:@"按组合支付" textColor:TCUIColorFromRGB(0x7f7f7f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
                tipLa.preferredMaxLayoutWidth = 180;
                [tipLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:tipLa];
                
                [tipLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.right.mas_equalTo(-40);
                                    make.centerY.mas_equalTo(view);
                                    make.height.mas_equalTo(11);
                }];
               
                
                if(balance < payMoney){
                    tipLa.hidden = NO;
                    rightBt.selected = YES;
                    self.balanceBt = rightBt;
                    self.isCombined = @"1";
                    [rightBt addTarget:self action:@selector(clickBnlance:) forControlEvents:(UIControlEventTouchUpInside)];
                }else{
                    [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                    tipLa.hidden = YES;
                    rightBt.selected = YES;
                    self.selectBt = rightBt;
                    self.type = i;
                }
            }else{
                [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            }
        }else{
            [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            if(i == 0){
                rightBt.selected = YES;
                self.selectBt = rightBt;
                self.type = i;
            }
        }
    }
    
    UIImageView *tipIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 50 * self.payArr.count + 32, 12, 12)];
    tipIcon.image = [UIImage imageNamed:@"tip_icon1"];
    [bgView addSubview:tipIcon];
    
    
    NSString *tipStr = [NSString stringWithFormat:@"    %@",self.model.PayPriceTips];
    CGSize size = [NSString sizeWithText:tipStr font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(WIDTH - 34,MAXFLOAT)];
    
    
    UILabel *tipsLa = [UILabel publicLab:tipStr textColor:TCUIColorFromRGB(0xa18158) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    tipsLa.frame = CGRectMake(12, 50 * self.payArr.count + 32, WIDTH - 34, size.height);
    [bgView addSubview:tipsLa];
    
    bgView.height = CGRectGetMaxY(tipsLa.frame) + 30;
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 87, WIDTH, 87)];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:bottomV];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, WIDTH - 30, 40)];
    [btn setBackgroundColor:redColor2];
    [btn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:btn];
}

-(void)clickBt:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    self.type = tag;
    if(![self.selectBt isEqual:sender]){
        self.selectBt.selected = NO;
        sender.selected = YES;
        self.selectBt = sender;
    }
}

-(void)clickBnlance:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.isCombined = @"1";
    }else{
        self.isCombined = @"0";
    }
}

-(void)clickPay{
    [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",self.type]];
    if([self.isCombined isEqualToString:@"1"]){
        //先验证余额密码 后调三方支付
    }else{
        if([self.model.CanBalancePay isEqualToString:@"1"]){
            if(self.type == self.payArr.count - 1){
                [[UIApplication sharedApplication].keyWindow addSubview:self.passPopView];
                [self.passPopView showView];
            }
        }
    }
    
    
    
}

-(void)CheckBalancePay{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CheckBalancePay"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself CheckInte];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)CheckInte{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CheckInte"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself CheckInte];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//验证余额支付密码
-(void)CheckPaymentPassword{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CheckPaymentPassword"];
    NSDictionary *param = @{@"PaymentPassword":self.PaymentPassword,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself BalancePay];
            [weakself.passPopView hideView];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)BalancePay{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"BalancePay"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
            successVC.ID = weakself.model.ID;
            [weakself.navigationController pushViewController:successVC animated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickReturn{
    if([self.isEnter isEqualToString:@"0"]){
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
        [self.popView showView];
    }else{
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"支付页面"];
}

@end
