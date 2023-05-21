//
//  MMIntegarlDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import "MMIntegarlDetailVC.h"
#import "MMPointsDetailsModel.h"
#import "MMIntegralDetailCell.h"

@interface MMIntegarlDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@end

@implementation MMIntegarlDetailVC


-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 64, WIDTH, HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
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
    [TalkingDataSDK onPageBegin:@"积分明细页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"integralDetails"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.view addSubview:self.mainTableView];
    [self requestData];
    [self setupRefresh];
}

-(void)requestData{
    KweakSelf(self);
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyLogList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"curr":@"1",@"limit":@"20",@"wtid":@"2"};
   
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPointsDetailsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
       
    }];
}

#pragma mark -- 上拉加载
-(void)setupRefresh{
    __block NSInteger page = 1;
    //上拉 加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        page++;
        [self requestLoadMoreGoodsDataPage:(long)page];
        
    }];
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainTableView.mj_footer = footer;
}

-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyLogList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"curr":pageStr,@"limit":@"20",@"wtid":@"2"};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPointsDetailsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.dataArr addObjectsFromArray:arr];
                [weakself.mainTableView reloadData];
                [weakself.mainTableView.mj_footer endRefreshing];
            }else{
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
                weakself.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
           
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark -- uitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMIntegralDetailCell*cell = [[MMIntegralDetailCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    
    return cell;
}

#pragma mark -- sdcycledelegate

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"积分明细页面"];
}

@end
