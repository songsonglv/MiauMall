//
//  MMMyTeamViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//  我的团队

#import "MMMyTeamViewController.h"
#import "MMTeamVipCell.h"
#import "MMMyTeamListModel.h"
#import "MMTeamPartnerCell.h"
#import "MMSetUpRatePopView.h"

@interface MMMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *selectBtn;//选中按钮
@property (nonatomic, strong) NSString *wtid;//  2 1 0按顺序对应
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *maxRate;
@property (nonatomic, strong) NSString *SubYongRate;//分佣比例
@property (nonatomic, strong) MMSetUpRatePopView *popView;

@end

@implementation MMMyTeamViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 100, WIDTH, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 100) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"我的团队页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.wtid = @"2";
    self.SubYongRate = @"0";
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"我的团队";
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, 48)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    
    NSArray *arr = @[@"全部",@"合伙人",@"会员"];
    CGFloat wid = WIDTH/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 17, wid, 17)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x2a2b2a) forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xe1321a) forState:(UIControlStateSelected)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        btn.tag = 100 + i;
        btn.selected = NO;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        if(i == 0){
            self.selectBtn = btn;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:17];
            
            UIView *redV = [[UIView alloc]initWithFrame:CGRectMake(0, 46, 32, 2)];
            redV.backgroundColor = TCUIColorFromRGB(0xe1321a);
            redV.layer.masksToBounds = YES;
            redV.layer.cornerRadius = 1;
            redV.centerX = btn.centerX;
            [view addSubview:redV];
            self.redView = redV;
        }
        
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 47.5, WIDTH - 36, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [view addSubview:line];
    
    [self.view addSubview:self.mainTableView];
    [self requestData];
}

-(void)clickBtn:(UIButton *)sender{
    KweakSelf(self);
    if(sender.tag == 100){
        self.wtid = @"2";
    }else if (sender.tag == 101){
        self.wtid = @"1";
    }else{
        self.wtid = @"0";
    }
    
    if (![self.selectBtn isEqual:sender]) {
        self.selectBtn.selected = NO;
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:17];
    sender.selected = YES;
    self.selectBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.redView.centerX = sender.centerX;
    }];
    
    [self requestData];
}

-(void)requestData{
    
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];//搜索可以传name
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetUnderMember"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"99" forKey:@"limit"];
    [param setValue:self.wtid forKey:@"wtid"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMMyTeamListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.maxRate = jsonDic[@"MaxRate"];
            [weakself.dataArr removeAllObjects];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uitableiewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMMyTeamListModel *model = self.dataArr[indexPath.row];
    if([model.SalesLevel isEqualToString:@"2"]){
        return 244;;
    }
    return 188;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMMyTeamListModel *model = self.dataArr[indexPath.row];
    if([model.SalesLevel isEqualToString:@"2"]){
        MMTeamPartnerCell *cell = [[MMTeamPartnerCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArr[indexPath.row];
        cell.clickEditBlcok = ^(NSString * _Nonnull ID) {
            weakself.ID = ID;
            [weakself showEditPopView:model];
        };
        return  cell;
    }
    MMTeamVipCell *cell = [[MMTeamVipCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.clickUpBlock = ^(NSString * _Nonnull ID) {
        [weakself updatePartner:ID];
    };
    return  cell;
}

-(void)updatePartner:(NSString *)ID{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级为合伙人"
                                                                   message:@"切换下级类型后该用户将作为您的下级合伙人参与分销，切换后不可再更改！"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself updataID:ID];
    }]];
    
    

    [self presentViewController:alert animated:true completion:nil];
}

-(void)showEditPopView:(MMMyTeamListModel *)model{
    KweakSelf(self);
    self.popView = [[MMSetUpRatePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andMaxRate:self.maxRate];
    self.popView.model = model;
    self.popView.setUpRateBlcok = ^(NSString * _Nonnull rateStr) {
        weakself.SubYongRate = rateStr;
        [weakself editRate];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)editRate{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetRate"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.ID forKey:@"id"];
    [param setValue:self.SubYongRate forKey:@"SubYongRate"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        [weakself requestData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)updataID:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetPartner"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:ID forKey:@"id"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        [weakself requestData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
  ;
}


-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"我的团队页面"];
}
@end
