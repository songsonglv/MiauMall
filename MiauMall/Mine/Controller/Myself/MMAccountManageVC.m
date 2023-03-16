//
//  MMAccountManageVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//  账号管理

#import "MMAccountManageVC.h"
#import "MMMineMainDataModel.h"

@interface MMAccountManageVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMMineMainDataModel *model;
@property (nonatomic, strong) UIButton *phoneBt;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UIButton *emailBt;
@property (nonatomic, strong) UILabel *emailLa;
@property (nonatomic, strong) UIButton *wxBt;
@property (nonatomic, strong) UIButton *appleBt;
@end

@implementation MMAccountManageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"账号管理页面"];
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
    titleView.titleLa.text = @"账号管理";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
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
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    NSArray *arr = @[@"手机",@"邮箱",@"微信",@"Apple ID"];
    NSArray *imgArr = @[@"phone_icon",@"email_icon",@"wx_icon",@"apple_icon"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 288)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    [self.view addSubview:bgView];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 72 * i, WIDTH - 20, 72)];
        [bgView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 24, 24, 24)];
        iconImage.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:iconImage];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 120;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(54);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(15);
        }];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
        [btn setTitle:@"更换" forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x828282) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:6];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(37);
        }];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x828282) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 200;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(btn.mas_left).offset(-12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 71.5, view.width - 16, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
        [view addSubview:line];
        
        if(i == 0){
            self.phoneBt = btn;
            self.phoneLa = lab1;
            if(self.model.memberInfo.MobilePhone.length > 0){
                self.phoneLa.text = self.model.memberInfo.MobilePhone;
                [btn setTitle:@"更换" forState:(UIControlStateNormal)];
            }else{
                [btn setTitle:@"添加" forState:(UIControlStateNormal)];
            }
        }else if (i == 1){
            self.emailBt = btn;
            self.emailLa = lab1;
            if(self.model.memberInfo.Email.length > 0){
                self.emailLa.text = self.model.memberInfo.Email;
                [btn setTitle:@"更换" forState:(UIControlStateNormal)];
            }else{
                [btn setTitle:@"添加" forState:(UIControlStateNormal)];
            }
        }else if (i == 2){
            lab1.hidden = YES;
            self.wxBt = btn;
            if([self.model.memberInfo.CanWxBind isEqualToString:@"1"]){
                [btn setTitle:@"解绑" forState:(UIControlStateNormal)];
            }else{
                [btn setTitle:@"绑定" forState:(UIControlStateNormal)];
            }
        }else{
            lab1.hidden = YES;
            self.appleBt = btn;
            [btn setTitle:@"绑定" forState:(UIControlStateNormal)];//没字段判断是否绑定
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"账号管理页面"];
}
@end
