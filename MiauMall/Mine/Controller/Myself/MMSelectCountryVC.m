//
//  MMSelectCountryVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//  选择国家和地区  0 1 2 中英日文 cry 9 中国


#import "MMSelectCountryVC.h"
#import "MMCountryInfoModel.h"
#import "MMCountryPopView.h"
#import "MMSelectCountryModel.h"

@interface MMSelectCountryVC ()
@property (nonatomic, strong) UIImageView *countryLogo;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) NSString *languageStr;
@property (nonatomic, strong) NSMutableArray *countrys;//国家数组
@property (nonatomic, strong) UIButton *selectBt;

@property (nonatomic, strong) MMCountryPopView *popView;//选择弹窗

@property (nonatomic, strong) NSString *language;//0 中文 zh 1 英文 en 2 日文 ja
@property (nonatomic, strong) NSString *currency;//国家编号
@property (nonatomic, strong) NSString *img;//国旗图片
@property (nonatomic, strong) NSString *area;//地区

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//单选，当前选中的
@property (nonatomic, strong) MMSelectCountryModel *pageModel;
@end

@implementation MMSelectCountryVC

-(NSMutableArray *)countrys{
    if(!_countrys){
        _countrys = [NSMutableArray array];
    }
    return _countrys;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    [TalkingDataSDK onPageBegin:@"选择国家语言页面"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
    titleView.titleLa.text = @"国家和地区";
    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    NSString *lang = [self.userDefaults valueForKey:@"language"];
    self.currency = [self.userDefaults valueForKey:@"cry"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
   
    if(!self.tempcart){
        NSString *str1 = [self generateTradeNO:8];
        NSString *str2 = [self generateTradeNO:4];
        NSString *str3 = [self generateTradeNO:4];
        NSString *str4 = [self generateTradeNO:4];
        NSString *str5 = [self generateTradeNO:12];
        self.tempcart = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",str1,str2,str3,str4,str5];
        [self.userDefaults setValue:self.tempcart forKey:@"tempcart"];
        [self.userDefaults  synchronize];
    }
    
    if(lang){
        self.language = lang;
    }else{
        //判断当前系统语言
             
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
              
        NSArray  *array = [language componentsSeparatedByString:@"-"];
              
        NSString *currentLanguage = array[0];
        
        if([currentLanguage isEqualToString:@"zh"]){
            self.language = @"0";
        }else if ([currentLanguage isEqualToString:@"en"]){
            self.language = @"1";
        }else if ([currentLanguage isEqualToString:@"ja"]){
            self.language = @"2";
        }else{
            self.language = @"0";
        }
        
        if(self.currency){
            
        }else{
            self.currency = @"9";
        }
    }
    
    
    
    [ZTProgressHUD showLoadingWithMessage:@"加载中。。。"];
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoadCurrency2"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.language forKey:@"lang"];
    [param setValue:self.currency forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.pageModel = [MMSelectCountryModel mj_objectWithKeyValues:jsonDic];
            NSArray *countrys = [MMCountryInfoModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.countrys = [NSMutableArray arrayWithArray:countrys];
            [ZTProgressHUD hide];
            [weakself setUI];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
 
}

-(void)setUI{
    KweakSelf(self);
//    NSString *cry = [self.userDefaults valueForKey:@"cry"];
//    self.currency = cry;
    NSString *area = [self.userDefaults valueForKey:@"area"];
    NSString *img = [self.userDefaults valueForKey:@"countryimage"];
    if(self.currency){
        for (int i = 0; i < self.countrys.count; i++) {
            MMCountryInfoModel *model = self.countrys[i];
            if([self.currency isEqualToString:model.ID]){
                self.selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
            
            if(i == 0){
                self.currency = model.ID;
                self.img = model.Picture;
                self.area = model.Name;
            }
        }
    }else{
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    
    
    self.popView = [[MMCountryPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.countrys];
    self.popView.selectedIndexPath = self.selectedIndexPath;
    self.popView.clickJump = ^(NSString * _Nonnull indexStr, NSString * _Nonnull cry, NSString * _Nonnull img) {
        weakself.currency = cry;
        [weakself.countryLogo sd_setImageWithURL:[NSURL URLWithString:img]];
        weakself.countryLabel.text = indexStr;
        weakself.area = indexStr;
        weakself.img = img;
    };
    
    MMCountryInfoModel *model = self.countrys[0];
    UIImageView *countryLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, StatusBarHeight + 64, WIDTH - 30, 182)];
    if(img){
        [countryLogo sd_setImageWithURL:[NSURL URLWithString:img]];
    }else{
        [countryLogo sd_setImageWithURL:[NSURL URLWithString:model.Picture]];
    }
//    countryLogo.contentMode = UIViewContentModeScaleAspectFit;
    countryLogo.layer.masksToBounds = YES;
    countryLogo.layer.cornerRadius = 6;
    [self.view addSubview:countryLogo];
    self.countryLogo = countryLogo;
    
    UIView *conView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(countryLogo.frame) + 22, WIDTH - 30, 48)];
    conView.layer.masksToBounds = YES;
    conView.layer.cornerRadius = 6;
    conView.layer.borderColor = TCUIColorFromRGB(0xc4c4c4).CGColor;
    conView.layer.borderWidth = 0.75;
    [self.view addSubview:conView];
    
    UILabel *lab = [UILabel publicLab:@"选择国家" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    [conView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(conView);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(16);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TCUIColorFromRGB(0xc4c4c4);
    [conView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_right).offset(12);
            make.centerY.mas_equalTo(conView);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(20);
    }];
    
    UILabel *nameLa = [UILabel publicLab:self.area textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    [conView addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(12);
            make.centerY.mas_equalTo(conView);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(14);
    }];
    self.countryLabel = nameLa;
    
    if(area){
        nameLa.text = area;
    }
    
    UIImageView *downImage = [[UIImageView alloc]init];
    downImage.image = [UIImage imageNamed:@"down_black"];
    [conView addSubview:downImage];
    
    [downImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(conView);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(8);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:UIColor.clearColor];
    btn.timeInterval = 2;
    [btn addTarget:self action:@selector(selectCountry) forControlEvents:(UIControlEventTouchUpInside)];
    [conView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"选择语言" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(23, CGRectGetMaxY(conView.frame) + 45, 70, 16);
    [self.view addSubview:lab1];
    
    
    
    NSArray *arr = @[@"英文",@"简体中文",@"日文"];
    float wid = WIDTH/3;
    for(int i = 0; i < arr.count; i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, CGRectGetMaxY(lab1.frame) + 30, wid, 15)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(selectLanguage:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
        
        if([self.language isEqualToString:@"0"]){
            if(i == 1){
                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                self.selectBt = btn;
            }
        }else if([self.language isEqualToString:@"1"]){
            if(i == 0){
                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                self.selectBt = btn;
            }
        }else{
            if(i == 2){
                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                self.selectBt = btn;
            }
        }
        
        
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, HEIGHT - TabbarSafeBottomMargin - 60, WIDTH - 36, 36)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xd64f3e)];
    [sureBt setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBt];
    
    
}

-(void)selectLanguage:(UIButton *)sender{
    // 未选中
        if (self.selectBt) {
            [self.selectBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        }

    // 选中
    self.selectBt = sender;
    [self.selectBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
    if(sender.tag == 100){
        self.language = @"1";
    }else if (sender.tag == 101){
        self.language = @"0";
    }else{
        self.language = @"2";
    }
//    [self.userDefaults setValue:self.language forKey:@"language"];
//    [self.userDefaults synchronize];
}

-(void)clickSave{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetCurrency"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.currency forKey:@"Currency"];
    [param setValue:self.language forKey:@"lang"];
    [param setValue:self.currency forKey:@"cry"];

    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.userDefaults setValue:weakself.img forKey:@"countryimage"];
            [weakself.userDefaults setValue:weakself.area forKey:@"area"];
            [weakself.userDefaults setValue:weakself.currency forKey:@"cry"];
            [weakself.userDefaults setValue:weakself.language forKey:@"language"];
            [weakself.userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCountry" object:nil];
            if([weakself.currency isEqualToString:@"9"]){
                [weakself showChinaTips:jsonDic[@"msg"]];
            }else{
                [weakself jumpHome:jsonDic[@"msg"]];
            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            [weakself.userDefaults setValue:weakself.img forKey:@"countryimage"];
            [weakself.userDefaults setValue:weakself.area forKey:@"area"];
            [weakself.userDefaults setValue:weakself.currency forKey:@"cry"];
            [weakself.userDefaults setValue:weakself.language forKey:@"language"];
            [weakself.userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCountry" object:nil];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

     
-(void)showChinaTips:(NSString *)msg{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:self.pageModel.ChinaTips
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [weakself jumpHome:msg];
    }]];

    [self presentViewController:alert animated:true completion:nil];
}

-(void)jumpHome:(NSString *)msg{
    [self.userDefaults setValue:self.currency forKey:@"cry"];
    [self.userDefaults setValue:self.area forKey:@"area"];
    [self.userDefaults setValue:self.img forKey:@"countryimage"];
    [self.userDefaults setValue:self.language forKey:@"language"];
    [self.userDefaults synchronize];
    [ZTProgressHUD showMessage:msg];
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)selectCountry{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    [super viewWillDisappear: animated];
    [TalkingDataSDK onPageEnd:@"选择国家语言页面"];
}

@end
