//
//  MMOtherBalanceRechargeVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//  其他金额余额充值页面

#import "MMOtherBalanceRechargeVC.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"

@interface MMOtherBalanceRechargeVC ()<UITextFieldDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) MMPayResultModel *payModel;

@end

@implementation MMOtherBalanceRechargeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"其他金额充值页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"balanceCharge"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    KweakSelf(self);
    UILabel *textLa = [UILabel publicLab:self.model.Conts textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    textLa.preferredMaxLayoutWidth = WIDTH - 48;
    [textLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.view addSubview:textLa];
    
    [textLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(StatusBarHeight + 100);
            make.centerX.mas_equalTo(weakself.view);
            make.width.mas_equalTo(WIDTH - 48);
    }];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(60, StatusBarHeight + 180, WIDTH - 120, 40)];
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"pleaseMoney"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
    field.delegate = self;
    field.layer.masksToBounds = YES;
    field.layer.cornerRadius = 20;
    field.layer.borderWidth = 0.5;
    field.layer.borderColor = TCUIColorFromRGB(0xdedede).CGColor;
    field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    field.textColor = textBlackColor2;
    field.tintColor = TCUIColorFromRGB(0xb1b1b0);
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:field];
    self.moneyField = field;
    
    UIButton *chongBt = [[UIButton alloc]initWithFrame:CGRectMake(10,HEIGHT - 44 - TabbarSafeBottomMargin, WIDTH - 20, 44)];
    chongBt.layer.masksToBounds = YES;
    chongBt.layer.cornerRadius = 10;
    [chongBt setBackgroundColor:TCUIColorFromRGB(0xe13918)];
    [chongBt setTitle:[UserDefaultLocationDic valueForKey:@"rechargeNow"] forState:(UIControlStateNormal)];
    [chongBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    chongBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [chongBt addTarget:self action:@selector(clickChong) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:chongBt];
}

-(void)clickChong{
    KweakSelf(self);
    if(self.moneyField.text.length > 0){
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"RechargeDown"];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        [param setValue:self.moneyField.text forKey:@"Moneys"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [weakself chongStep2:jsonDic[@"key"]];
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleaseMoney"]];
    }
    
}

-(void)chongStep2:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayHandleMoreOrders"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
            MMPayViewController *payVC = [[MMPayViewController alloc]init];
            payVC.isBalance = @"1";
            payVC.model = weakself.payModel;
            payVC.isEnter = @"1";
            [weakself.navigationController pushViewController:payVC animated:YES];
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
    [TalkingDataSDK onPageEnd:@"其他金额充值页面"];
}

@end
