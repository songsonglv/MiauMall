//
//  MMOrderListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//  订单列表

#import "MMOrderListViewController.h"
#import "MMOrderDetailViewController.h"
#import "MMOrderChangeAddressVC.h"
#import "MMOrderListCell.h"
#import "MMOrderRemindPopView.h"
#import "MMLogisticsInfomoationVC.h"
#import "MMOrderAfterSalesVC.h"
#import "MMAfterSalesResultVC.h"
#import "MMMyAssessViewControllerView.h"
#import "MMCalendarViewController.h"
#import "MMAfterSalesAssessVC.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"

@interface MMOrderListViewController ()<HGCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSString *typeid; //0全部 1待付款 2待发货 3待收货 4待评价 5售后
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *keyword;//关键字
@property (nonatomic, strong) HGCategoryView *cateView;
@property (nonatomic, strong) NSMutableArray *orderArr;//订单数组
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UITextField *searchField;//订单搜索输入框
@property (nonatomic, strong) NSMutableArray *vacationArr;//日本假期时间数组
@property (nonatomic, strong) NSString *timePic;//发货时间早知道
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) UIImageView *timeImage;
@property (nonatomic, strong) MMOrderRemindPopView *popView;
@property (nonatomic, strong) MMOrderAfterSalesTipPopView *tipsPopView;//售后提示弹窗
@property (nonatomic, strong) MMOrderListModel *seleModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger endpage;

//@property (nonatomic, assign) CGFloat topHei;//顶部tableview的高度 超过屏幕高度时tableview可滚动 否则不可滚动


@end

@implementation MMOrderListViewController

-(NSMutableArray *)orderArr{
    if(!_orderArr){
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 64) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(HGCategoryView *)cateView{
    if(!_cateView){
        _cateView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 25)];
        _cateView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        _cateView.delegate = self;
        _cateView.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"售后"];
        _cateView.selectedIndex = self.index;
        _cateView.alignment = HGCategoryViewAlignmentLeft;
        _cateView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _cateView.titleNormalColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _cateView.vernier.backgroundColor = TCUIColorFromRGB(0x2e2e2e);
        _cateView.topBorder.hidden = YES;
        _cateView.bottomBorder.hidden = YES;
        _cateView.vernier.height = 2.0f;
        _cateView.vernierWidth = 15;
    }
    return _cateView;
}

-(SDCycleScrollView *)cycle{
    if(!_cycle){
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 10, WIDTH - 20, 78)];
        _cycle.backgroundColor = TCUIColorFromRGB(0xffffff);
        _cycle.delegate = self;
        _cycle.layer.masksToBounds = YES;
        _cycle.layer.cornerRadius = 8;
        _cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycle.showPageControl = NO;
    }
    return _cycle;
}

-(UIImageView *)timeImage{
    if(!_timeImage){
        _timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycle.frame) + 10, WIDTH - 20, 32)];
        _timeImage.layer.masksToBounds = YES;
        _timeImage.layer.cornerRadius = 4;
    }
    return _timeImage;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"订单列表页面"];
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    self.typeid = [NSString stringWithFormat:@"%ld",self.index];
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshOrderList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refundSuccess" object:nil];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 64)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(38, 17, WIDTH - 46, 30)];
    bgView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 15;
    [titleView addSubview:bgView];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 12, 12)];
    iconImage.image = [UIImage imageNamed:@"order_search_icon"];
    [bgView addSubview:iconImage];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(26, 7, WIDTH - 80, 16)];
    field.textColor = TCUIColorFromRGB(0x565656);
    field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    field.delegate = self;
    field.returnKeyType = UIReturnKeySearch;
    [bgView addSubview:field];
    self.searchField = field;
//    [self setUI];
    
    self.popView = [[MMOrderRemindPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.tapGoonBlock = ^(NSString * _Nonnull str) {
        [ZTProgressHUD showMessage:@"估计是跳转客服了"];
    };
    
    NSString *conStr = @"售后申请期限指包裹签收7天之内，此处不包含清关异常、物流原因等导致包裹退回及美容仪保修等情况";
    self.tipsPopView = [[MMOrderAfterSalesTipPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:@"亲爱的蜜友" andConten:conStr andCancle:@"取消" andGoon:@"继续"];
    self.tipsPopView.tapGoonBlock = ^(NSString * _Nonnull str) {
        MMOrderAfterSalesVC *afterVC = [[MMOrderAfterSalesVC alloc]init];
        afterVC.model = weakself.seleModel;
        [weakself.navigationController pushViewController:afterVC animated:YES];
    };
    
    self.tipsPopView.tapQuesttBlock = ^(NSString * _Nonnull str) {
        MMProblemDetailVC *problemVC = [[MMProblemDetailVC alloc]init];
        problemVC.ID = @"2090";
        [weakself.navigationController pushViewController:problemVC animated:YES];
    };
    
    [self loadHttpRequest];
}

-(void)refreshData{
    [self requstOrderData];
}

-(void)loadHttpRequest{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求发货时间早知道图片
           [weakself getPicture];
       });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求日本假期数组
        [weakself GetCanNotShipmentDate];
    });
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求banner数组
           [weakself GetRotationPictures];
       });
    
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

-(void)setUI{
    [ZTProgressHUD hide];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 64, WIDTH, 130)];
    topV.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    [self.view addSubview:topV];
    
    NSMutableArray *picArr = [NSMutableArray array];
    for (MMRotationPicModel *picModel in self.bannerArr) {
        [picArr addObject:picModel.Picture];
    }
    self.cycle.imageURLStringsGroup = picArr;
    [topV addSubview:self.cycle];
    
    
    [self.timeImage sd_setImageWithURL:[NSURL URLWithString:self.timePic] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    [topV addSubview:self.timeImage];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycle.frame) + 10, WIDTH - 20, 32)];
    btn.frame = CGRectMake(0, CGRectGetMaxY(self.cycle.frame) + 10, WIDTH - 20, 32);
    [btn addTarget:self action:@selector(clickTime) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:btn];
    
    self.mainTableView.tableHeaderView = topV;
    [self.view addSubview:self.mainTableView];
    [self requstOrderData];
    
    [self setupRefresh];
    [self setNoneData];
}

-(void)setNoneData{
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"car_none_icon"
                                                                 titleStr:@""
                                                                detailStr:@"您还没相关的订单-"
                                                              btnTitleStr:@""
                                                            btnClickBlock:^(){
            
        }];
    emptyView.contentViewY = 250;
    emptyView.subViewMargin = 9.f;
    emptyView.detailLabFont = [UIFont systemFontOfSize:12];
    emptyView.detailLabTextColor = TCUIColorFromRGB(0xbbbbbb);
    
    self.mainTableView.ly_emptyView = emptyView;
}

#pragma mark -- 上拉加载
-(void)setupRefresh{
    KweakSelf(self);
    
    //下拉
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    //刷新
        [weakself refresh];
        
    }];
    //设置刷新标题
    self.mainTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉 加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            [self requestOrderMoreData:weakself.page];
        }else{
            [ZTProgressHUD showMessage:@"没有更多商品"];
            weakself.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    self.mainTableView.mj_footer = footer;
}

-(void)refresh{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.typeid forKey:@"typeid"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"2" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    if(self.keyword){
        [param setValue:self.keyword forKey:@"keyword"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.orderArr removeAllObjects];
            NSArray *arr = [MMOrderListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.orderArr = [NSMutableArray arrayWithArray:arr];

            [weakself.mainTableView reloadData];
            
            [weakself.mainTableView.mj_header endRefreshing];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [weakself.mainTableView.mj_header endRefreshing];
}

-(void)requestOrderMoreData:(NSInteger)page{
    KweakSelf(self);
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.typeid forKey:@"typeid"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    if(self.keyword){
        [param setValue:self.keyword forKey:@"keyword"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            
            NSArray *arr = [MMOrderListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.orderArr addObjectsFromArray:arr];
            [weakself.mainTableView reloadData];
            
            [weakself.mainTableView.mj_footer endRefreshing];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [weakself.mainTableView.mj_footer endRefreshing];
}

-(void)getPicture{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPicture"];
    
    [param setValue:@"170" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        dispatch_semaphore_signal(sema);
        if([code isEqualToString:@"1"]){
            weakself.timePic = jsonDic[@"Picture"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetCanNotShipmentDate{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCanNotShipmentDate"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        dispatch_semaphore_signal(sema);
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"TimeStr"];
            weakself.vacationArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetRotationPictures{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:@"9" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        dispatch_semaphore_signal(sema);
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.bannerArr = [NSMutableArray arrayWithArray:arr];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requstOrderData{
    KweakSelf(self);
    self.page = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.typeid forKey:@"typeid"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    if(self.keyword){
        [param setValue:self.keyword forKey:@"keyword"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.orderArr removeAllObjects];
            NSArray *arr = [MMOrderListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.orderArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            [weakself.mainTableView reloadData];
            weakself.mainTableView.mj_header.state = MJRefreshStateIdle;
            weakself.mainTableView.mj_footer.state = MJRefreshStateIdle;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMOrderListModel *model = self.orderArr[indexPath.row];
    if(model.EstimatedShipment.length > 0){
        return 265 + 124 * model.itemlist.count;
    }else{
        return 210 + 124 * model.itemlist.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identity = @"tableHead";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identity];
    if(!view){
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identity];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 60)];
        bgView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        [view addSubview:bgView];
        [bgView addSubview:self.cateView];
    }
   
//    [view addSubview:self.cateView];

    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMOrderListCell*cell = [[MMOrderListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MMOrderListModel *model = self.orderArr[indexPath.row];
    cell.model = model;
    cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
        [weakself RouteJump:router];
    };
    cell.tapCopyBlock = ^(NSString * _Nonnull OrderNo) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = OrderNo;
        [ZTProgressHUD showMessage:@"复制成功！"];
    };
    cell.tapRigthBlock = ^(NSString * _Nonnull btType) {
        [weakself clickRight:btType andItemID:model.ID andModel:model];
    };
    cell.tapCenterBlock = ^(NSString * _Nonnull btType) {
        weakself.seleModel = model;
        [weakself clickCenter:btType andItemID:model.ID andModel:model];
    };
    cell.tapLeftBlock = ^(NSString * _Nonnull btType) {
        weakself.seleModel = model;
        [weakself clickLeft:btType andItemID:model.ID];
    };
    return cell;
}

#pragma mark -- cateViewdelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    NSString *str = [NSString stringWithFormat:@"%ld",index];
    self.typeid = str;
    [self requstOrderData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMOrderListModel *model = self.orderArr[indexPath.row];
    MMOrderDetailViewController *detailVC = [[MMOrderDetailViewController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- sdcycledelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.bannerArr[index];
    [self RouteJump:model.LinkUrl];
}

#pragma mark -- 点击按钮
//自己定义的一个状态 0 待支付 1 待发货 2 代收货 3 待评价 4 售后 5 关闭
-(void)clickRight:(NSString *)type andItemID:(NSString *)ID andModel:(MMOrderListModel *)model{
    if([type isEqualToString:@"0"]){
        [self GetPayHandleMoreOrders:ID];
    }else if ([type isEqualToString:@"1"]){
        if([model.CanTips isEqualToString:@"1"]){
            [self tipsOrderID:ID];
        }else{
            [self requestOrderAddress:ID];
        }
    }else if ([type isEqualToString:@"2"]){
        KweakSelf(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"你确定要确认收货吗？"
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
            [weakself OrderReceipt:ID];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else if ([type isEqualToString:@"3"]){
        if([model.CanAssessOrder isEqualToString:@"1"]){
            MMMyAssessViewControllerView *assessVC = [[MMMyAssessViewControllerView alloc]init];
            [self.navigationController pushViewController:assessVC animated:YES];
        }else{
            MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
            logictisVC.orderID = ID;
            [self.navigationController pushViewController:logictisVC animated:YES];
        }
        
    }else if ([type isEqualToString:@"4"]){
        MMAfterSalesResultVC *reasultVC = [[MMAfterSalesResultVC alloc]init];
        reasultVC.orderID = ID;
        [self.navigationController pushViewController:reasultVC animated:YES];
    }else if ([type isEqualToString:@"5"]){
        [self addCar:ID];
    }
//    if([type isEqualToString:@"CanPay"]){
//        [ZTProgressHUD showMessage:@"跳付款"];
//    }else if ([type isEqualToString:@"CanAssessOrder"]){
//        MMMyAssessViewControllerView *assessVC = [[MMMyAssessViewControllerView alloc]init];
//        [self.navigationController pushViewController:assessVC animated:YES];
//    }else if ([type isEqualToString:@"CanReceiptOrder"]){
//        KweakSelf(self);
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                       message:@"你确定要确认收货吗？"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//            [action setValue:redColor2 forKey:@"titleTextColor"];
//
//        }]];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//            [action setValue:selectColor forKey:@"titleTextColor"];
//            [weakself OrderReceipt:ID];
//        }]];
//        [self presentViewController:alert animated:true completion:nil];
//    }else if ([type isEqualToString:@"CanResult"]){
//        MMAfterSalesResultVC *reasultVC = [[MMAfterSalesResultVC alloc]init];
//        reasultVC.orderID = ID;
//        [self.navigationController pushViewController:reasultVC animated:YES];
//    }else if ([type isEqualToString:@"CanTips"]){
//        [self tipsOrderID:ID];
//    }
}

//type  0 待支付 1 待发货 2 代收货 3 待评价 4 售后 5 关闭
-(void)clickCenter:(NSString *)type andItemID:(NSString *)ID andModel:(MMOrderListModel *)model{
    if([type isEqualToString:@"0"]){
        [self requestOrderAddress:ID];
    }else if ([type isEqualToString:@"1"]){
        if([model.CanTips isEqualToString:@"1"]){
            [self requestOrderAddress:ID];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
            [self.tipsPopView showView];
        }
        
    }else if ([type isEqualToString:@"2"]){
        MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
        logictisVC.orderID = ID;
        [self.navigationController pushViewController:logictisVC animated:YES];
    }else if ([type isEqualToString:@"3"]){
//        [ZTProgressHUD showMessage:@"查看物流"];
        if([model.CanAssessOrder isEqualToString:@"1"]){
            MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
            logictisVC.orderID = ID;
            [self.navigationController pushViewController:logictisVC animated:YES];
        }else{
            [self addCar:ID];
        }
        
    }else if ([type isEqualToString:@"4"]){
        if([model.CanAfterSalesEvaluation isEqualToString:@"1"]){
            MMAfterSalesAssessVC *afterAssessVC = [[MMAfterSalesAssessVC alloc]init];
            afterAssessVC.orderId = ID;
            [self.navigationController pushViewController:afterAssessVC animated:YES];
        }else{
            [self deleteOrder:ID];
        }
        
    }else if ([type isEqualToString:@"5"]){
        [self deleteOrder:ID];
    }
//    if([type isEqualToString:@"CanAddress"]){
//        [self requestOrderAddress:ID];
//    }else if ([type isEqualToString:@"CanExpress"]){
//        [ZTProgressHUD showMessage:@"查看物流"];
//        MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
//        logictisVC.orderID = ID;
//        [self.navigationController pushViewController:logictisVC animated:YES];
//    }else if([type isEqualToString:@"CanResult"]){
//        MMAfterSalesResultVC *reasultVC = [[MMAfterSalesResultVC alloc]init];
//        reasultVC.orderID = ID;
//        [self.navigationController pushViewController:reasultVC animated:YES];
//    }else{
//        [ZTProgressHUD showMessage:@"售后评价"];
//    }
}

-(void)clickLeft:(NSString *)type andItemID:(NSString *)ID{
    if([type isEqualToString:@"0"]){
        KweakSelf(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"确定取消该订单吗？"
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
            [weakself cancleOrderID:ID];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else if ([type isEqualToString:@"1"]){
        [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
        [self.tipsPopView showView];
    }else if ([type isEqualToString:@"2"]){
        [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
        [self.tipsPopView showView];
    }else if ([type isEqualToString:@"3"]){
        [self addCar:ID];
    }else if ([type isEqualToString:@"4"]){
        [self deleteOrder:ID];
    }else if ([type isEqualToString:@"5"]){
        [self deleteOrder:ID];
    }
    
//    if([type isEqualToString:@"CanCancel"]){
//        KweakSelf(self);
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                       message:@"确定取消该订单吗？"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//            [action setValue:redColor2 forKey:@"titleTextColor"];
//            
//        }]];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//            [action setValue:selectColor forKey:@"titleTextColor"];
//            [weakself cancleOrderID:ID];
//        }]];
//        [self presentViewController:alert animated:true completion:nil];
//    }else if ([type isEqualToString:@"CanRefundItem"]){
//        [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
//        [self.tipsPopView showView];
//    }else if ([type isEqualToString:@"CanExpress"]){
//        [ZTProgressHUD showMessage:@"查看物流"];
//        MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
//        logictisVC.orderID = ID;
//        [self.navigationController pushViewController:logictisVC animated:YES];
//    }else{
//        [ZTProgressHUD showMessage:@"加入购物车"];
//    }
}

-(void)clickAddCart:(NSString *)type andItemID:(NSString *)ID{
    [ZTProgressHUD showMessage:@"加入购物车"];
}

//确认收货请求
-(void)OrderReceipt:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderReceipt"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requstOrderData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求订单的收货地址 然后跳转修改地址
-(void)requestOrderAddress:(NSString *)OrderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderAddressRead"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:OrderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMOrderAddressModel *model = [MMOrderAddressModel mj_objectWithKeyValues:jsonDic];
            MMOrderChangeAddressVC *changeVC = [[MMOrderChangeAddressVC alloc]init];
            changeVC.addressModel = model;
            [weakself.navigationController pushViewController:changeVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)tipsOrderID:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderTips"];
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
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.popView];
            [weakself.popView showView];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//取消订单
-(void)cancleOrderID:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CancelOrder"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requstOrderData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//付款页面
-(void)GetPayHandleMoreOrders:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayHandleMoreOrders"];
    NSDictionary *param = @{@"id":ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMPayResultModel *payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
            MMPayViewController *payVC = [[MMPayViewController alloc]init];
            payVC.model = payModel;
            payVC.isEnter = @"0";
            [weakself.navigationController pushViewController:payVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//删除订单
-(void)deleteOrder:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"DeleteCloseOrder"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"orderID"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requstOrderData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//加入购物车
-(void)addCar:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AllCartPlus"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"1" forKey:@"back"];

    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMShopCarModel *model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.cartabBarItem.badgeValue = model.num;
            if([model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 弹出日历
-(void)clickTime{
    MMCalendarViewController *calendarVC = [[MMCalendarViewController alloc]init];
    calendarVC.timeArr = self.vacationArr;
//    calendarVC.timeStr = @"2023-02-02";
    calendarVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:calendarVC animated:YES completion:nil];
}

//路由跳转
-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"订单列表页面"];
}

@end
