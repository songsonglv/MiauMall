//
//  MMCouponViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//  优惠券

#import "MMCouponViewController.h"
#import "MMCouponInfoModel.h"
#import "MMCouponCell.h"

@interface MMCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSString *type;//默认0 1 2
@end

@implementation MMCouponViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 114, WIDTH, HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"优惠券页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.type = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"icoupon"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}
    
-(void)setUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 84, WIDTH, 22)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"notUsed"],[UserDefaultLocationDic valueForKey:@"iused"],[UserDefaultLocationDic valueForKey:@"iInvalid"]];
    CGFloat wid = WIDTH/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 0, wid, 14)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        btn.tag = 100 + i;
        btn.selected = NO;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        if(i == 0){
            self.selectBtn = btn;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:17];
            UIView *redV = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 14, 2)];
            redV.backgroundColor = TCUIColorFromRGB(0x383838);
            redV.layer.masksToBounds = YES;
            redV.layer.cornerRadius = 1;
            redV.centerX = btn.centerX;
            [view addSubview:redV];
            self.redView = redV;
        }
    }
    
    [self.view addSubview:self.mainTableView];
    [self requestData];
}

-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCouponList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"curr":@"1",@"limit":@"99",@"type":self.type};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMCouponInfoModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
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


-(void)clickBtn:(UIButton *)sender{
    KweakSelf(self);
    NSString *index = [NSString stringWithFormat:@"%ld",sender.tag - 100];
    self.type = index;
    
    if (![self.selectBtn isEqual:sender]) {
        self.selectBtn.selected = NO;
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
    sender.selected = YES;
    self.selectBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.redView.centerX = sender.centerX;
    }];
    
    [self requestData];
}

#pragma mark -- uitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMCouponCell*cell = [[MMCouponCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
        cell.goHomeBlock = ^(NSString * _Nonnull str) {
            weakself.navigationController.tabBarController.selectedIndex = 0;
            [weakself.navigationController popToRootViewControllerAnimated:NO];
        };
    }
    
    return cell;
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"优惠券页面"];
}

@end
