//
//  MMSetUpViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//  设置页面

#import "MMSetUpViewController.h"
#import "MMMineMainDataModel.h"
#import "MMAddressListViewController.h"
#import "MMSelectCountryVC.h"
#import "MMNotificationSetupView.h"
#import "MMResetPassWordVC.h"
#import "MMAccountManageVC.h"
#import "MMMemberInfoViewController.h"

@interface MMSetUpViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *vipLa;
@property (nonatomic, strong) UILabel *IDLabel;
@property (nonatomic, strong) UILabel *editionLa;//版本号
@property (nonatomic, strong) MMMineMainDataModel *model;
@property (nonatomic, strong) MMNotificationSetupView *popView;

@end

@implementation MMSetUpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"设置页面"];
    [self requestData];
}

-(MMNotificationSetupView *)popView{
    KweakSelf(self);
    if(!_popView){
        _popView = [[MMNotificationSetupView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.model];
        _popView.saveNotificationBlock = ^(NSString * _Nonnull str1, NSString * _Nonnull str2, NSString * _Nonnull str3, NSString * _Nonnull str4) {
            [weakself SaveTips:str1 andTipsSys:str2 andTipsWulu:str3 andTipsOrder:str4];
        };
    }
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"iset"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    [self setUI];
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMMineMainDataModel mj_objectWithKeyValues:jsonDic];
            [weakself.headImage sd_setImageWithURL:[NSURL URLWithString:weakself.model.memberInfo.Picture]];
            weakself.nameLa.text = weakself.model.memberInfo.Name;
            weakself.IDLabel.text = [NSString stringWithFormat:@"ID：%@",weakself.model.memberInfo.ID];
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetVersion{
    KweakSelf(self);
//    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetVersion"];
//    if(self.memberToken){
//        [param setValue:self.memberToken forKey:@"membertoken"];
//    }
//    [param setValue:self.tempcart forKey:@"tempcart"];
//    [param setValue:self.lang forKey:@"lang"];
//    [param setValue:self.cry forKey:@"cry"];
//    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
//        weakself.editionLa.text = [NSString stringWithFormat:@"V%@",jsonDic[@"IOSVersion"]];
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];//
    NSString *applocalversion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.editionLa.text = applocalversion;
}

-(void)setUI{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 506)];
    view1.backgroundColor = TCUIColorFromRGB(0xffffff);
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 6;
    [self.view addSubview:view1];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 86)];
    [view1 addSubview:infoView];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 19, 50, 50)];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 25;
    [infoView addSubview:headImage];
    
    self.headImage = headImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [infoView addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(77);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(23);
    }];
    
    UILabel *vipLa = [UILabel publicLab:@"黑卡" textColor:TCUIColorFromRGB(0xf5cd86) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    vipLa.backgroundColor = TCUIColorFromRGB(0x231815);
    vipLa.layer.masksToBounds = YES;
    vipLa.layer.cornerRadius = 4;
    vipLa.hidden = YES;
    [infoView addSubview:vipLa];
    self.vipLa = vipLa;
    
    [vipLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(5);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *codeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    //codeLa.frame = CGRectMake(86, CGRectGetMaxY(nameLa.frame) + 10, MAXFLOAT, 12);
    codeLa.preferredMaxLayoutWidth = 180;
    [codeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [infoView addSubview:codeLa];
    self.IDLabel = codeLa;
    
    [codeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(77);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"gerData"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"gerData"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xa0a0a0) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
    [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [btn addTarget:self action:@selector(setMemberInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [infoView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.centerY.mas_equalTo(infoView);
            make.width.mas_equalTo(size.width + 12);
            make.height.mas_equalTo(14);
    }];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, 85.5, infoView.width - 16, 0.5)];
    line1.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [infoView addSubview:line1];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"receiveAddress"],[UserDefaultLocationDic valueForKey:@"account"],[UserDefaultLocationDic valueForKey:@"pwdReset"],[UserDefaultLocationDic valueForKey:@"messSetting"],[UserDefaultLocationDic valueForKey:@"dqLang"],[UserDefaultLocationDic valueForKey:@"iversion"]];
    if(!self.memberToken){
        arr = @[[UserDefaultLocationDic valueForKey:@"dqLang"],[UserDefaultLocationDic valueForKey:@"iversion"]];
        view1.height = 225;
    }
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame) + 70 * i, WIDTH - 20, 70)];
        [view1 addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(17);
        }];
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(view.width - 13, 30, 5, 10)];
        rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
        [view addSubview:rightIcon];
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:view.bounds];
        [btn1 setBackgroundColor:UIColor.clearColor];
        btn1.tag = 100 + i;
        [btn1 addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn1];
     
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 69.5, infoView.width - 16, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
        [view addSubview:line];
        
        if(self.memberToken){
            if(i == 5){
                rightIcon.hidden = YES;
                line.hidden = YES;
                btn1.hidden = YES;
                UILabel *editionLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
                editionLa.preferredMaxLayoutWidth = 120;
                [editionLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:editionLa];
                
                [editionLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.mas_equalTo(-10);
                                make.centerY.mas_equalTo(view);
                                make.height.mas_equalTo(15);
                }];
                self.editionLa = editionLa;
            }
        }else{
            if(i == 1){
                rightIcon.hidden = YES;
                line.hidden = YES;
                btn1.hidden = YES;
                UILabel *editionLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
                editionLa.preferredMaxLayoutWidth = 120;
                [editionLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:editionLa];
                
                [editionLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.mas_equalTo(-10);
                                make.centerY.mas_equalTo(view);
                                make.height.mas_equalTo(15);
                }];
                self.editionLa = editionLa;
            }
        }
       
    }
    
    UIButton *outLoginBt = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame) + 24, WIDTH - 20, 64)];
    [outLoginBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    outLoginBt.layer.masksToBounds = YES;
    outLoginBt.layer.cornerRadius = 6;
    [outLoginBt setTitle:[UserDefaultLocationDic valueForKey:@"logOut"] forState:(UIControlStateNormal)];
    [outLoginBt setTitleColor:TCUIColorFromRGB(0x231815) forState:UIControlStateNormal];
    outLoginBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [outLoginBt addTarget:self action:@selector(clickOutLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:outLoginBt];
    
    if(!self.memberToken){
        outLoginBt.hidden = YES;
    }
    
    [self GetVersion];
}


-(void)setMemberInfo{
    if(self.memberToken){
        MMMemberInfoViewController *memberVC = [[MMMemberInfoViewController alloc]init];
        [self.navigationController pushViewController:memberVC animated:YES];
    }else{
        MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
        loginVC.modalPresentationStyle = 0;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
   
}

-(void)clickBt:(UIButton *)sender{
    
    if(self.memberToken){
        if(sender.tag == 100){
            MMAddressListViewController *addressVC = [[MMAddressListViewController alloc]init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }else if (sender.tag == 101){
            MMAccountManageVC *manageVC = [[MMAccountManageVC alloc]init];
            [self.navigationController pushViewController:manageVC animated:YES];
        }else if (sender.tag == 102){
            MMResetPassWordVC *resetVC = [[MMResetPassWordVC alloc]init];
            [self.navigationController pushViewController:resetVC animated:YES];
        }
        else if (sender.tag == 103){
            [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
            [self.popView showView];
        }else if (sender.tag == 104){
            MMSelectCountryVC *countryVC = [[MMSelectCountryVC alloc]init];
            if([self.isDM isEqualToString:@"1"]){
                countryVC.isDM = @"1";
            }
            [self.navigationController pushViewController:countryVC animated:YES];
        }
    }else{
        MMSelectCountryVC *countryVC = [[MMSelectCountryVC alloc]init];
        [self.navigationController pushViewController:countryVC animated:YES];
    }
    
}

-(void)clickOutLogin{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:[UserDefaultLocationDic valueForKey:@"confirmLogout"]
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself outLogin];
        
    }]];
    
    

    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)outLogin{
    [self.userDefaults removeObjectForKey:@"membertoken"];
    [self.userDefaults synchronize];
    MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
    loginVC.modalPresentationStyle = 0;
    [self presentViewController:loginVC animated:NO completion:NO];
}

-(void)SaveTips:(NSString *)IsReceiveEmail andTipsSys:(NSString *)TipsSys andTipsWulu:(NSString *)TipsWulu andTipsOrder:(NSString *)TipsOrder{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SaveTips"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:IsReceiveEmail forKey:@"IsReceiveEmail"];
    [param setValue:TipsSys forKey:@"TipsSys"];
    [param setValue:TipsWulu forKey:@"TipsWulu"];
    [param setValue:TipsOrder forKey:@"TipsOrder"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
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
    [TalkingDataSDK onPageEnd:@"设置页面"];
}

@end
