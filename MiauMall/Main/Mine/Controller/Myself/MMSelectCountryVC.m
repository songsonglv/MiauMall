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
#import <XYCountryCodeUtils.h>
#import <XYCountry.h>
#import "MMTabbarController.h"
#import "MMDMTabbarController.h"

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
@property (nonatomic, strong)  NSMutableArray *datas;//本地的国家数组
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *ukName;
@end

@implementation MMSelectCountryVC

-(NSMutableArray *)countrys{
    if(!_countrys){
        _countrys = [NSMutableArray array];
    }
    return _countrys;
}

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [NSMutableArray array];
    }
    return _datas;
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
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"gjhdq"];
    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    NSString *lang = [self.userDefaults valueForKey:@"language"];
    self.currency = [self.userDefaults valueForKey:@"cry"];
//    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
   
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
       // zh-Hant-US
        
        if([currentLanguage isEqualToString:@"zh"]){
            self.language = @"0";
        }else if ([currentLanguage isEqualToString:@"en"]){
            self.language = @"1";
        }else if ([currentLanguage isEqualToString:@"ja"]){
            self.language = @"2";
        }else if([language isEqualToString:@"zh-TW"]){
            self.language = @"3";
        }else{
            self.language = @"1";
        }
        
        if(self.currency){
            
        }else{
            self.currency = @"9";
        }
    }
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city_en" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *list = dic[@"cities"];
    
    for (NSDictionary *info in list) {
        XYCountry *c = [[XYCountry alloc] initWithDictionary:info];
        [self.datas addObject:c];
    }
    
    [ZTProgressHUD showLoadingWithMessage:@""];
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
    
    NSDictionary *dic = UserDefaultLocationDic;
    
    if(!dic){
        dic = [MMLocalTranslationData initLanguage:self
                  .language];
    }
//    NSString *cry = [self.userDefaults valueForKey:@"cry"];
//    self.currency = cry;
    NSString *area = [self.userDefaults valueForKey:@"area"];
    NSString *img = [self.userDefaults valueForKey:@"countryimage"];
    if(img){
        self.img = img;
        self.area = area;
        for (int i = 0; i < self.countrys.count; i++) {
            MMCountryInfoModel *model = self.countrys[i];
            if([self.currency isEqualToString:model.ID]){
                self.selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
            
//            if(i == 0){
//                self.img = model.Picture;
//                self.area = model.Name;
//            }
        }
    }else{
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        MMCountryInfoModel *model = self.countrys[0];
        self.img = model.Picture;
        self.area = model.Name;
        self.ukName = model.UKName;
    }
    
    
    
    self.popView = [[MMCountryPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.countrys];
    self.popView.selectedIndexPath = self.selectedIndexPath;
    self.popView.clickJump = ^(NSString * _Nonnull indexStr, NSString * _Nonnull cry, NSString * _Nonnull img, MMCountryInfoModel * _Nonnull model) {
        weakself.currency = cry;
        [weakself.countryLogo sd_setImageWithURL:[NSURL URLWithString:img]];
        weakself.countryLabel.text = indexStr;
        
        NSArray *temp = [indexStr componentsSeparatedByString:@" "];
        weakself.countryName = temp[1];
        weakself.area = temp[1];
        weakself.img = img;
        weakself.ukName = model.UKName;
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
    
    UILabel *lab = [UILabel publicLab:[dic valueForKey:@"xzCountry"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 300;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(conView);
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
    
    self.countryName = self.area;
    
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
    
    CGSize size = [NSString sizeWithText:[dic valueForKey:@"xzLanguage"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
    
    UILabel *lab1 = [UILabel publicLab:[dic valueForKey:@"xzLanguage"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(23, CGRectGetMaxY(conView.frame) + 45, size.width, 16);
    [self.view addSubview:lab1];
    
    
    
    
    NSArray *arr;
    if(dic){
        arr = @[[dic valueForKey:@"ichinese"],@"English",[dic valueForKey:@"ifanti"],[dic valueForKey:@"ijapanese"]];
    }else{
        arr = @[@"中文",@"Englist",@"繁体中文",@"日文"];
    }
    
    float wid = WIDTH/2;
    
    for(int i = 0; i < arr.count; i++){
        NSInteger row = i/2;
        NSInteger column = i % 2;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * column, CGRectGetMaxY(lab1.frame) + 30 + 45 * row, wid, 17)];
        [self.view addSubview:view];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(24, 1, 15, 15)];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [btn setEnlargeEdgeWithTop:5 right:150 bottom:5 left:20];
        [btn addTarget:self action:@selector(selectLanguage:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = 100 + i;
        [view addSubview:btn];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Medium" size:15 numberOfLines:0];
        lab.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 5, 0, 120, 17);
        [view addSubview:lab];
        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100 + wid * column, CGRectGetMaxY(lab1.frame) + 30 + 45 * row, wid, 15)];
//        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
//        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
//        btn.tag = 100 + i;
//        [btn addTarget:self action:@selector(selectLanguage:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self.view addSubview:btn];
        
        
        
        if([self.language isEqualToString:@"0"]){
            if(i == 0){
                btn.selected = YES;
//                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                self.selectBt = btn;
            }
        }else if([self.language isEqualToString:@"1"]){
            if(i == 1){
//                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                btn.selected = YES;
                self.selectBt = btn;
            }
        }else if([self.language isEqualToString:@"3"]){
            if(i == 2){
//                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                btn.selected = YES;
                self.selectBt = btn;
            }
        }else if([self.language isEqualToString:@"2"]){
            if(i == 3){
//                [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
                btn.selected = YES;
                self.selectBt = btn;
            }
        }
        
        
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, HEIGHT - TabbarSafeBottomMargin - 60, WIDTH - 36, 36)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xd64f3e)];
    [sureBt setTitle:[dic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [sureBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBt];
    
    
}

-(void)selectLanguage:(UIButton *)sender{
    if([self.selectBt isEqual:sender]){
        
    }else{
        self.selectBt.selected = NO;
        sender.selected = YES;
        self.selectBt = sender;
    }
    
//    // 未选中
//        if (self.selectBt) {
//            [self.selectBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
//        }
//
//    // 选中
//    self.selectBt = sender;
//    [self.selectBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateNormal)];
    if(sender.tag == 100){
        self.language = @"0";
    }else if (sender.tag == 101){
        self.language = @"1";
    }else if(sender.tag == 103){
        self.language = @"2";
    }else if(sender.tag == 102){
        self.language = @"3";
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
            for (XYCountry *country in weakself.datas) {
                if([weakself.ukName isEqualToString:country.name]){
                    [weakself.userDefaults setValue:country.code forKey:@"areaCode"];
                }
            }
            
            [weakself.userDefaults setValue:weakself.img forKey:@"countryimage"];
            [weakself.userDefaults setValue:weakself.area forKey:@"area"];
            [weakself.userDefaults setValue:weakself.currency forKey:@"cry"];
            [weakself.userDefaults setValue:weakself.language forKey:@"language"];
            NSDictionary *dic = [MMLocalTranslationData initLanguage:weakself.language];
            [weakself.userDefaults setValue:dic forKey:@"LocalTranslation"];
            [weakself.userDefaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCountry" object:nil];
            [weakself jumpHome:jsonDic[@"msg"]];
//            if([weakself.currency isEqualToString:@"9"]){
//                [weakself showChinaTips:jsonDic[@"msg"]];
//            }else{
//
//            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
//            [weakself.userDefaults setValue:weakself.img forKey:@"countryimage"];
//            [weakself.userDefaults setValue:weakself.area forKey:@"area"];
//            [weakself.userDefaults setValue:weakself.currency forKey:@"cry"];
//            [weakself.userDefaults setValue:weakself.language forKey:@"language"];
//            [weakself.userDefaults synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCountry" object:nil];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

     
-(void)showChinaTips:(NSString *)msg{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
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
    
    
    
//    [ZTProgressHUD showMessage:msg];
    if([self.isDM isEqualToString:@"1"]){
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        MMDMTabbarController *rootVC = [[MMDMTabbarController alloc]init];
        window.rootViewController = rootVC;
        rootVC.modalPresentationStyle = 0;
        [self presentViewController:rootVC animated:YES completion:nil];
    }else{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        MMTabbarController *rootVC = [[MMTabbarController alloc]init];
        window.rootViewController = rootVC;
        rootVC.modalPresentationStyle = 0;
        [self presentViewController:rootVC animated:YES completion:nil];
    }
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
