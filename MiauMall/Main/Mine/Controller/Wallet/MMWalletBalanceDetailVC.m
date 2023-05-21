//
//  MMWalletBalanceDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//  余额变动明细

#import "MMWalletBalanceDetailVC.h"
#import "MMBalanceRecordModel.h"
#import "MMCommissionDetailCell.h"
#import "MMBalanceDetailInfoVC.h"

@interface MMWalletBalanceDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *selectBtn;//选中按钮
@property (nonatomic, strong) NSString *type;//1 2 3按顺序对应
@property (nonatomic, strong) UIView *redView;

@property (nonatomic, assign) NSInteger endpage;

@end

@implementation MMWalletBalanceDetailVC

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
    
    [TalkingDataSDK onPageBegin:@"余额变动明细页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.type = @"1";
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"balanceDetail"];
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
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"czRecord"],[UserDefaultLocationDic valueForKey:@"xfRecord"],[UserDefaultLocationDic valueForKey:@"tixianLog"]];
    CGFloat wid = WIDTH/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 17, wid, 15)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x2a2b2a) forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xe1321a) forState:(UIControlStateSelected)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        btn.tag = 100 + i;
        btn.selected = NO;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        if(i == 0){
            self.selectBtn = btn;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
            
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
    
    [self requestShopDataPage:1];
    
    [self setupRefresh];
    
}

-(void)setupRefresh{
    
    KweakSelf(self);
    __block NSInteger page = 1;
    
    //下拉
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //刷新
        page = 1;
        [self requestShopDataPage:1];
        
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.mainTableView.mj_header = header;
    [header beginRefreshing];
    //上拉
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        page++;
        if(page <= weakself.endpage){
            [self requestLoadMoreShopDataPage:page];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
            [self.mainTableView.mj_footer endRefreshing];
        }
       
        
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainTableView.mj_footer = footer;
}

-(void)requestShopDataPage:(NSInteger )page{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBalanceRecord"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.type forKey:@"Type"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            NSArray *arr = [MMBalanceRecordModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
            [self.mainTableView.mj_header endRefreshing];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            [self.mainTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestLoadMoreShopDataPage:(NSInteger )page{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBalanceRecord"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.type forKey:@"Type"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMBalanceRecordModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.dataArr addObjectsFromArray:arr];
                [weakself.mainTableView reloadData];
            }
            
            [self.mainTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [self.mainTableView.mj_footer endRefreshing];

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MMBalanceRecordModel *model = self.dataArr[indexPath.row];
//    MMBalanceDetailInfoVC*infoVC = [[MMBalanceDetailInfoVC alloc]init];
//    infoVC.model = model;
//    [self.navigationController pushViewController:infoVC animated:YES];
}


-(void)clickBtn:(UIButton *)sender{
    KweakSelf(self);
    NSString *index = [NSString stringWithFormat:@"%ld",sender.tag - 99];
    self.type = index;
    
    if (![self.selectBtn isEqual:sender]) {
        self.selectBtn.selected = NO;
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
    sender.selected = YES;
    self.selectBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.redView.centerX = sender.centerX;
    }];
    
    [self requestShopDataPage:1];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"余额变动明细页面"];
}
@end
