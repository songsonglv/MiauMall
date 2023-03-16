//
//  MMWalletViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//  我的钱包页面

#import "MMWalletViewController.h"
#import "MMRechargeModel.h"// 充值奖励数据模型
#import "MMBalanceRecordModel.h"
#import "MMWalletDataModel.h"
#import "MMRechargeView.h"
#import "MMCommissionDetailCell.h"
#import "MMWalletBalanceDetailVC.h"
#import "MMOpenWalletPopView.h"
#import "MMEmailOpenWalletPopView.h"
#import "MMPayResultModel.h"
#import "MMBalanceRulesVC.h"
#import "MMOtherBalanceRechargeVC.h"
#import "MMWalletSetUpPopView.h"
#import "MMWalletChangePwdVC.h"
#import "MMWalletRetrievePwdVC.h"

@interface MMWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMWalletDataModel *model;
@property (nonatomic, strong) NSMutableArray *rechArr;
@property (nonatomic, strong) UILabel *balanceLa;
@property (nonatomic, strong) UILabel *faMoneyLa;//法币余额
@property (nonatomic, strong) MMRechargeView *rechView;//选中充值的标签
@property (nonatomic, strong) UIButton *selectBt;//选中按钮
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) MMOpenWalletPopView *popView;
@property (nonatomic, strong) MMEmailOpenWalletPopView *popView1;
@property (nonatomic, strong) MMWalletSetUpPopView *setUpView;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *codeStr;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *agaPwd;
@property (nonatomic, strong) NSString *moneys;
@property (nonatomic, strong) MMPayResultModel *payModel;


@end

@implementation MMWalletViewController

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 52, WIDTH - 20, HEIGHT - StatusBarHeight - 112 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
        _mainTableView.layer.masksToBounds = YES;
        _mainTableView.layer.cornerRadius = 6;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(NSMutableArray *)rechArr{
    if(!_rechArr){
        _rechArr = [NSMutableArray array];
    }
    return _rechArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"我的钱包页面"];
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    
    self.setUpView = [[MMWalletSetUpPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.setUpView.clickDetailBlcok = ^(NSString * _Nonnull str) {
        [weakself clickAll];
    };
    self.setUpView.clickEditBlock = ^(NSString * _Nonnull str) {
        [weakself changePwd];
    };
    self.setUpView.clickForwardBlock = ^(NSString * _Nonnull str) {
        [weakself jumpRetrieve];
    };
    
    self.popView = [[MMOpenWalletPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.clickHome = ^(NSString * _Nonnull str) {
        [weakself goHome];
    };
    self.popView.clickGetCode = ^(NSString * _Nonnull str) {
        [weakself getCode: str];
    };
    self.popView.clickSure = ^(NSString * _Nonnull email, NSString * _Nonnull codeStr, NSString * _Nonnull pwd, NSString * _Nonnull againStr) {
        weakself.email = email;
        weakself.codeStr = codeStr;
        weakself.pwd = pwd;
        weakself.agaPwd = againStr;
        [weakself bindEmail];
    };
  
    self.popView1 = [[MMEmailOpenWalletPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView1.clickHome = ^(NSString * _Nonnull str) {
        [weakself goHome];
    };
    self.popView1.clickSure = ^(NSString * _Nonnull pwd, NSString * _Nonnull agaPwd) {
        weakself.pwd = pwd;
        weakself.agaPwd = agaPwd;
        [weakself bindEmail];
    };
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"我的钱包";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    UIButton *setUpBt = [[UIButton alloc]init];
    [setUpBt setTitle:@"设置" forState:(UIControlStateNormal)];
    [setUpBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    setUpBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [setUpBt addTarget:self action:@selector(clickSetUp) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:setUpBt];
    
    [setUpBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(18);
    }];
    
    
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    
    
  
      
    [self requestItem];
        
        
  
    
    // Do any additional setup after loading the view.
}

-(void)requestItem{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBalanceRecharge"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRechargeModel mj_objectArrayWithKeyValuesArray:jsonDic[@"key"][@"DiscRule"]];
            weakself.rechArr = [NSMutableArray arrayWithArray:arr];
            [weakself requestListData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestListData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBalanceRecord"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMBalanceRecordModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself requestMainData];
        }else{
            [ZTProgressHUD hide];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestMainData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetChongMsg"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMWalletDataModel mj_objectWithKeyValues:jsonDic];
            
            [weakself setUI];
           
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    MMRechargeModel *model1 = self.rechArr[0];
    self.moneys = model1.full;
    if([self.model.IsUseBalance isEqualToString:@"1"]){
        
    }else{
        if([self.model.Email isEmpty]){
            [self showPopView];
        }else{
            [self showPopView1];
        }
    }
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 52, WIDTH - 20, 438)];
    [self.view addSubview:topV];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 198)];
    topImage.image = [UIImage imageNamed:@"wallet_bg"];
    topImage.userInteractionEnabled = YES;
    [topV addSubview:topImage];
    
    UILabel *titleLa = [UILabel publicLab:@"当前余额" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 30, WIDTH - 20, 18);
    [topImage addSubview:titleLa];
    
    UILabel *balanceLa = [UILabel publicLab:self.model.Moneys textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:50 numberOfLines:0];
    balanceLa.preferredMaxLayoutWidth = WIDTH - 80;
    [balanceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topImage addSubview:balanceLa];
    self.balanceLa = balanceLa;
    
    [balanceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(topImage);
            make.top.mas_equalTo(72);
            make.height.mas_equalTo(44);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"JPY" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 100;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topImage addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(balanceLa.mas_left).offset(-2);
            make.top.mas_equalTo(100);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *faLa = [UILabel publicLab:self.model.MoneysShow textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    faLa.frame = CGRectMake(0, 140, WIDTH - 20, 16);
    [topImage addSubview:faLa];
    self.faMoneyLa = faLa;
    
    UIButton *detailBt = [[UIButton alloc]init];
    [detailBt setImage:[UIImage imageNamed:@"right_while"] forState:(UIControlStateNormal)];
    [detailBt setTitle:@"详细规则" forState:(UIControlStateNormal)];
    [detailBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    detailBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [detailBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [detailBt addTarget:self action:@selector(clickDetail) forControlEvents:(UIControlEventTouchUpInside)];
    [topImage addSubview:detailBt];
    
    [detailBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *lab2 = [UILabel publicLab:@"限时充值送优惠" textColor:TCUIColorFromRGB(0xfa5b34) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    lab2.frame = CGRectMake(16, CGRectGetMaxY(topImage.frame) + 18, 150, 17);
    [topV addSubview:lab2];
    self.lab = lab2;
    
    CGFloat wid = (WIDTH - 40)/3;
    
    for (int i = 0; i < self.rechArr.count; i++) {
        NSInteger scale = i /3;
        MMRechargeView *recharView = [[MMRechargeView alloc]initWithFrame:CGRectMake(10 + (wid + 10) * (i%3), CGRectGetMaxY(lab2.frame) + 70 * scale + 17, wid, 60) andModel:self.rechArr[i]];
        recharView.isSelect = @"0";
        recharView.tag = 100 + i;
        [topV addSubview:recharView];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 60)];
        [btn setBackgroundColor:UIColor.clearColor];
        btn.tag = 200 + i;
        btn.selected = NO;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [recharView addSubview:btn];
        
        if(i == 0){
            btn.selected = YES;
            recharView.isSelect = @"1";
            self.selectBt = btn;
            self.rechView = recharView;
        }
    }
    
    UIButton *otherBt = [[UIButton alloc]initWithFrame:CGRectMake(10 + (wid + 10) * 2 , CGRectGetMaxY(lab2.frame) + 87, wid, 60)];
    otherBt.layer.masksToBounds = YES;
    otherBt.layer.cornerRadius = 6;
    otherBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [otherBt setTitle:@"其他金额" forState:(UIControlStateNormal)];
    [otherBt setTitleColor:TCUIColorFromRGB(0xf1462c) forState:(UIControlStateNormal)];
    [otherBt setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
    [otherBt addTarget:self action:@selector(clickOther) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:otherBt];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImage.frame) + 194, WIDTH - 20, 47)];
    headView.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
    [topV addSubview:headView];
    
    UILabel *lab = [UILabel publicLab:@"余额变动明细" textColor:TCUIColorFromRGB(0x2a2b2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    lab.frame = CGRectMake(8, 16, 120, 17);
    [headView addSubview:lab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 70, 18, 44, 13)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [btn setTitle:@"全部" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0x919191) forState:(UIControlStateNormal)];
    [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:3];
    [btn addTarget:self action:@selector(clickAll) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 46, WIDTH - 30, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [headView addSubview:line];
    
    self.mainTableView.tableHeaderView = topV;
    
    [self.view addSubview:self.mainTableView];
    
    UIButton *chongBt = [[UIButton alloc]initWithFrame:CGRectMake(0,HEIGHT - 60 - TabbarSafeBottomMargin, WIDTH, 60)];
    [chongBt setBackgroundColor:TCUIColorFromRGB(0xe13918)];
    [chongBt setTitle:@"立即充值" forState:(UIControlStateNormal)];
    [chongBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    chongBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [chongBt addTarget:self action:@selector(clickChong) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:chongBt];
}



#pragma mark -- uitableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMCommissionDetailCell *cell = [[MMCommissionDetailCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model1 = self.dataArr[indexPath.row];
    
    return  cell;
}

-(void)showPopView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)showPopView1{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView1];
    [self.popView1 showView];
}

-(void)clickBtn:(UIButton *)sender{
    NSInteger index = sender.tag - 200;
    if (![self.selectBt isEqual:sender]) {
        self.rechView.isSelect = @"0";
    }
    
    self.selectBt = sender;
    MMRechargeView *view = (MMRechargeView *)[self.view viewWithTag:100 + index];
    view.isSelect = @"1";
    self.rechView = view;
    
    MMRechargeModel *model = self.rechArr[index];
    self.moneys = model.full;
}

-(void)clickOther{
    MMOtherBalanceRechargeVC *otherVC = [[MMOtherBalanceRechargeVC alloc]init];
    otherVC.model = self.model;
    [self.navigationController pushViewController:otherVC animated:YES];
}

-(void)clickAll{
    MMWalletBalanceDetailVC *detailVC = [[MMWalletBalanceDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)getCode:(NSString *)email{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCode"];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:email forKey:@"AccountName"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:@"验证码已发送"];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//余额规则
-(void)clickDetail{
    MMBalanceRulesVC *ruleVC = [[MMBalanceRulesVC alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

-(void)changePwd{
    MMWalletChangePwdVC *changeVC = [[MMWalletChangePwdVC alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}

-(void)jumpRetrieve{
    MMWalletRetrievePwdVC *retrieveVC = [[MMWalletRetrievePwdVC alloc]init];
    [self.navigationController pushViewController:retrieveVC animated:YES];
}

//绑定邮箱
-(void)bindEmail{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"EmailBind"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.email){
        [param setValue:self.email forKey:@"Email"];
    }
    if(self.codeStr){
        [param setValue:self.codeStr forKey:@"VerifyCode"];
    }
    if(self.pwd){
        [param setValue:self.pwd forKey:@"PassWord"];
    }
    if(self.agaPwd){
        [param setValue:self.agaPwd forKey:@"PassWord1"];
    }
    
    [param setValue:@"0" forKey:@"Currency"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            if([weakself.model.Email isEmpty]){
                [weakself.popView hideView];
            }else{
                [weakself.popView1 hideView];
            }
            [ZTProgressHUD showMessage:@"钱包开通成功"];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)clickChong{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"RechargeDown"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.moneys forKey:@"Moneys"];
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
            [ZTProgressHUD showMessage:@"跳转选择支付方式页面"];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSetUp{
    [[UIApplication sharedApplication].keyWindow addSubview:self.setUpView];
    [self.setUpView showView];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [TalkingDataSDK onPageEnd:@"我的钱包页面"];
}

@end
