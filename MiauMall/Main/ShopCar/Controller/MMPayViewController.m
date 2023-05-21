//
//  MMPayViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMPayViewController.h"
#import "MMPassWordPopView.h"
#import "MMPaySuccessVC.h"
#import <WXApi.h>
#import "MMOrderPayWebVC.h"
#import "MMPayTipsPopView.h"
#import "MMCardPayInfoModel.h"
#import "MMCardPayTipPopView.h"

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
@property (nonatomic, assign) NSInteger type;//支付方式
@property (nonatomic, strong) NSString *payMethod; //支付方式icon
@property (nonatomic, strong) NSString *PaymentPassword;//余额密码

@property (nonatomic, strong) MMTitleContentPopView *popView;
@property (nonatomic, strong) MMPassWordPopView *passPopView;
@property (nonatomic, strong) MMPayTipsPopView *payTipView;//支付提示 加拿大必弹 信用卡 paypal必弹 两者都有内容拼接
@property (nonatomic, strong) MMCardPayTipPopView *cardPayPopView;

@property (nonatomic, strong) NSMutableArray *iconArr;
@property (nonatomic, strong) NSString *payTips;
@property (nonatomic, strong) NSString *PayLink;
@end

@implementation MMPayViewController

-(NSMutableArray *)payArr{
    if(!_payArr){
        _payArr = [NSMutableArray array];
    }
    return _payArr;
}

-(NSMutableArray *)iconArr{
    if(!_iconArr){
        _iconArr = [NSMutableArray array];
    }
    return _iconArr;
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"orderPayment"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    self.payTips = [UserDefaultLocationDic valueForKey:@"huiShuoXuFei"];
    self.payTipView = [[MMPayTipsPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.payTipView.returnTipBlcok = ^(NSString * _Nonnull str) {
        if([weakself.payMethod isEqualToString:@"balance_pay_icon"]){
            [weakself CheckBalancePay];
        }else if ([weakself.payMethod isEqualToString:@"wx_pay_icon1"]){
            [weakself WxPay];
        }else if ([weakself.payMethod isEqualToString:@"ali_pay_icon"]){
            [weakself AliPay];
        }else{
            NSString *payType;
            if([weakself.payMethod isEqualToString:@"union_pay_icon1"]){
                payType = @"UnionPay";
            }else if ([weakself.payMethod isEqualToString:@"card_pay_icon"]){
                payType = @"CardPay";
            }else if ([weakself.payMethod isEqualToString:@"paypal_pay_icon"]){
                payType = @"PayPal";
            }
            [weakself GetPayLink:payType];
        }
    };
    
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
    
    self.cardPayPopView = [[MMCardPayTipPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.cardPayPopView.returnSelectBlock = ^(NSString * _Nonnull str) {
        [weakself h5CardPay:str];
    };
    
    
    //支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPaySuccess) name:@"AliPayResultSuccess" object:nil];
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)AliPaySuccess{
//    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
//    [navigationArray removeObjectAtIndex: [navigationArray count]-1];
//    [self.navigationController setViewControllers: navigationArray animated:NO];
    MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
    successVC.ID = self.model.ID;
    [self.navigationController pushViewController:successVC animated:YES];
    [TalkingDataSDK onEvent:@"iOS原生-支付宝支付成功" parameters:nil];
}



-(void)WXPayResult:(NSNotification *)noti{
    PayResp *resp = noti.object;
    if(resp.errCode == 0){
//        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
//        [navigationArray removeObjectAtIndex: [navigationArray count]-1];
//        [self.navigationController setViewControllers: navigationArray animated:NO];
        MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
        successVC.ID = self.model.ID;
        [self.navigationController pushViewController:successVC animated:YES];
        [TalkingDataSDK onEvent:@"iOS原生-微信支付成功" parameters:nil];
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"payFailed"]];
    }
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
    
    double OrderInte = [self.model.OrderInte doubleValue];
    if(OrderInte > 0){
        UILabel *inteLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",self.model.OrderInte,[UserDefaultLocationDic valueForKey:@"integral"]] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        inteLa.frame = CGRectMake(0, CGRectGetMaxY(moneyLa.frame) + 12, WIDTH, 14);
        [self.view addSubview:inteLa];
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(moneyLa.frame) + 42, WIDTH - 10, 500)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 7.5;
    [self.view addSubview:bgView];
    
   
    if([self.model.CanWeixinPay isEqualToString:@"1"]){
        [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"wechatPay"]];
        [self.iconArr addObject:@"wx_pay_icon1"];
    }
    
    if([self.model.CanAlipayPay isEqualToString:@"1"]){
        [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"zhiFuBaoZhiFu"]];
        [self.iconArr addObject:@"ali_pay_icon"];
    }
    
    if([self.model.CanUnionPay isEqualToString:@"1"]){
        [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"unionPayPay"]];
        [self.iconArr addObject:@"union_pay_icon1"];
    }
    
    if([self.model.CanCardPay isEqualToString:@"1"]){
        [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"creditCardsAccepted"]];
        [self.iconArr addObject:@"card_pay_icon"];
    }
    
    if([self.model.CanBalancePay isEqualToString:@"1"]){
        if([self.isBalance isEqualToString:@"1"]){
            
        }else{
            [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"balancePay"]];
            [self.iconArr addObject:@"balance_pay_icon"];
        }
        
    }
    
    if([self.model.CanPayPal isEqualToString:@"1"]){
        [self.payArr addObject:[UserDefaultLocationDic valueForKey:@"paypalPay"]];
        [self.iconArr addObject:@"paypal_pay_icon"];
    }
    
   
    
    float balance = [self.model.MyBalance floatValue];
    float payMoney = [self.model.PayMoney floatValue];
    
    for (int i = 0; i < self.payArr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * i, WIDTH - 10, 50)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [bgView addSubview:view];
        
        UIImageView *payIcon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 11, 28, 28)];
        payIcon.image = [UIImage imageNamed:self.iconArr[i]];
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
        [rightBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
        [view addSubview:rightBt];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 49.5, WIDTH - 34, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
        [view addSubview:line];
        
       
        if([self.isBalance isEqualToString:@"1"]){
            [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            if(i == 0){
                rightBt.selected = YES;
                self.selectBt = rightBt;
                self.type = i;
                self.payMethod = self.iconArr[i];
            }
            
        }else{
            if(balance < payMoney){
                
                if(i == 0){
                    rightBt.selected = YES;
                    self.selectBt = rightBt;
                }
            }
            
            if([self.model.CanBalancePay isEqualToString:@"1"]){
                if([self.model.CanPayPal isEqualToString:@"1"]){
                    if(i == self.payArr.count - 2){
                        UILabel *balanceLa = [UILabel publicLab:[NSString stringWithFormat:@"（%@%@）",[UserDefaultLocationDic valueForKey:@"availableBalance"],self.model.MyBalanceShow] textColor:TCUIColorFromRGB(0x7f7f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
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
                            self.payMethod = self.iconArr[i];
                        }
                    }else{
                        [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                    }
                }else{
                    if(i == self.payArr.count - 1){
                        UILabel *balanceLa = [UILabel publicLab:[NSString stringWithFormat:@"（%@%@）",[UserDefaultLocationDic valueForKey:@"availableBalance"],self.model.MyBalanceShow] textColor:TCUIColorFromRGB(0x7f7f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
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
                            self.payMethod = self.iconArr[i];
                        }
                    }else{
                        [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                    }
                }
                
            }else{
                [rightBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                if(i == 0){
                    rightBt.selected = YES;
                    self.selectBt = rightBt;
                    self.type = i;
                    self.payMethod = self.iconArr[i];
                }
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
   
    if([self.isCombined isEqualToString:@"1"]){
        //先验证余额密码 后调三方支付
    }else{
        NSString *icon = self.iconArr[self.type];
        self.payMethod = icon;
        [self CheckInte];
        if([self.model.CanBalancePay isEqualToString:@"1"]){
            if([icon isEqualToString:@"ali_pay_icon"]){
//                [ZTProgressHUD showMessage:@"支付宝支付"];
            }else if ([icon isEqualToString:@"wx_pay_icon1"]){
//                [ZTProgressHUD showMessage:@"微信支付"];
            }else if ([icon isEqualToString:@"union_pay_icon1"]){
//                [ZTProgressHUD showMessage:@"银联支付"];
            }else if ([icon isEqualToString:@"paypal_pay_icon"]){
//                [ZTProgressHUD showMessage:@"paypal支付"];
            }else if ([icon isEqualToString:@"card_pay_icon"]){
//                [ZTProgressHUD showMessage:@"信用卡支付"];
            }else if ([icon isEqualToString:@"balance_pay_icon"]){
//                [ZTProgressHUD showMessage:@"余额支付"];
//                [self CheckBalancePay];
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
            [[UIApplication sharedApplication].keyWindow addSubview:self.passPopView];
            [self.passPopView showView];
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
            if([weakself.countryID isEqualToString:@"3361"]){
                if([weakself.payMethod isEqualToString:@"card_pay_icon"] || [weakself.payMethod isEqualToString:@"paypal_pay_icon"]){
                    NSString *tips = [NSString stringWithFormat:@"1.%@\n2.%@",weakself.model.Taxation,weakself.model.PayChargeTips];
                    weakself.payTipView.content = tips;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakself.payTipView];
                    [weakself.payTipView showView];
                }else{
                    weakself.payTipView.content = weakself.model.Taxation;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakself.payTipView];
                    [weakself.payTipView showView];
                }
            }else{
                if([weakself.payMethod isEqualToString:@"paypal_pay_icon"]){
                    weakself.payTipView.content = weakself.model.PayChargeTips;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakself.payTipView];
                    [weakself.payTipView showView];
                }else{
                    if([weakself.payMethod isEqualToString:@"balance_pay_icon"]){
                        [weakself CheckBalancePay];
                    }else if ([weakself.payMethod isEqualToString:@"wx_pay_icon1"]){
                        [weakself WxPay];
                    }else if ([weakself.payMethod isEqualToString:@"ali_pay_icon"]){
                        [weakself AliPay];
                    }else{
                        NSString *payType;
                        if([weakself.payMethod isEqualToString:@"union_pay_icon1"]){
                            payType = @"UnionPay";
                        }else if ([weakself.payMethod isEqualToString:@"card_pay_icon"]){
                            payType = @"CardPay";
                        }else if ([weakself.payMethod isEqualToString:@"PayPal"]){
                            payType = @"PayPal";
                        }
                        [weakself GetPayLink:payType];
                    }
                }
                
            }
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 测完改
-(void)GetPayLink:(NSString *)payType{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayLink"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"PayType":payType};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *PayLink = [NSString stringWithFormat:@"%@",jsonDic[@"PayLink"]];
            weakself.PayLink = PayLink;
            if([weakself.payMethod isEqualToString:@"card_pay_icon"]){
                if([weakself.model.IsStripeType isEqualToString:@"1"]){
                    [weakself GetStripePay];
                }else{
                    [weakself h5CardPay:@"0"];
                }
            }else{
                if([PayLink isEqualToString:@"Payment\/PayPal?id="]){
                    PayLink = @"Payment\/PayPal_PC?id=";
                }
                [weakself h5Pay:PayLink];
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//选择本地货币或者日元弹窗
-(void)GetStripePay{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStripePay"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.memberToken forKey:@"membertoken"];
    [param setValue:self.model.ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        MMCardPayInfoModel *model = [MMCardPayInfoModel mj_objectWithKeyValues:jsonDic];
        weakself.cardPayPopView.model = model;
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.cardPayPopView];
        [weakself.cardPayPopView showView];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)h5CardPay:(NSString *)StripeType{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&StripeType=%@",@"https://www.app.miau2020.com/",self.PayLink,self.model.ID,StripeType];
    MMOrderPayWebVC *payVC = [[MMOrderPayWebVC alloc]init];
    payVC.titleStr = @"MiauMall";
    payVC.orderID = self.model.ID;
    if([self.isEnter isEqualToString:@"1"]){
        payVC.isEnter = self.isEnter;
    }
    
    payVC.loadUrlStr = url;
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)h5Pay:(NSString *)payType{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",@"https://www.app.miau2020.com/",payType,self.model.ID];
    MMOrderPayWebVC *payVC = [[MMOrderPayWebVC alloc]init];
    payVC.orderID = self.model.ID;
    if([self.isEnter isEqualToString:@"1"]){
        payVC.isEnter = self.isEnter;
    }
    payVC.titleStr = @"MiauMall";
    payVC.loadUrlStr = url;
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)AliPay{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AliPay"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [[AlipaySDK defaultService] payOrder:key fromScheme:@ALIPayAPPScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"%@",resultDic);
                NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                if([resultStatus isEqualToString:@"9000"]){
                    [weakself AliPaySuccess];
                }else{
                    [ZTProgressHUD showMessage:@"支付失败"];
                }
                        }];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
//微信支付
-(void)WxPay{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"WxPay"];
    NSDictionary *param = @{@"id":self.model.ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            
            
            NSDictionary *params = jsonDic[@"key"][@"sdk_params"];
            PayReq *req         = [[PayReq alloc] init];
            
            req.partnerId           = params[@"partnerid"];
            req.prepayId            = params[@"prepayid"];
            req.nonceStr            = params[@"noncestr"];
            req.timeStamp           = (UInt32)[params[@"timestamp"] intValue];
            req.package             = params[@"package"];
            req.sign                = params[@"sign"];
            
            [WXApi sendReq:req completion:^(BOOL success) {
                if(success == YES){
                    NSLog(@"支付成功");
                }else{
                    NSLog(@"支付失败");
                }
               
            }];
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
//            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
//            [navigationArray removeObjectAtIndex: [navigationArray count]-1];
//            [weakself.navigationController setViewControllers: navigationArray animated:NO];
            MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
            successVC.ID = weakself.model.ID;
            [weakself.navigationController pushViewController:successVC animated:YES];
            [TalkingDataSDK onEvent:@"iOS原生-余额支付成功" parameters:nil];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickReturn{
    if([self.isEnter isEqualToString:@"1"]){
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
        [self.popView showView];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"支付页面"];
}

@end
