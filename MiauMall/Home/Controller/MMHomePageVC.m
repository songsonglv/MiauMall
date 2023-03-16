//
//  MMHomePageVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMHomePageVC.h"
#import "MMHomePageModel.h"
#import "MMHomePageItemModel.h"
#import "MMHomePageTopCell.h"
#import "MMHomeShopGoodsCell.h"
#import "MMFlowLayout.h"
#import "MMMessageCenterVC.h"
#import "MMHomeGoodsDetailController.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"
#import "MMSearchViewController.h"
#import "MMRaffleViewController.h"
#import "MMSortModel.h"


@interface MMHomePageVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HGCategoryViewDelegate>
@property (nonatomic, strong) UILabel *placeLabel;//输入框显示label
@property (nonatomic, strong) MMHomePageModel *homeModel;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, assign) CGFloat bannerHei;//banner高度
@property (nonatomic, strong) NSMutableArray *linkArr;//导航链接数组
@property (nonatomic, strong) NSMutableArray *singleHArr;//单图高度数组
@property (nonatomic, strong) NSMutableArray *singleArr;//单图数组
@property (nonatomic, strong) NSMutableArray *twoimg1Arr;//双图组合1数组
@property (nonatomic, strong) NSMutableArray *twoimg2Arr;//双图组合2数组
@property (nonatomic, strong) NSMutableArray *twoimg1HArr;//双图组合1高度数组
@property (nonatomic, strong) NSMutableArray *twoimg2HArr;//双图组合2高度数组

@property (nonatomic, strong) NSMutableArray *threeArr;//三图 一拖二数组 三图组合2
@property (nonatomic, strong) NSMutableArray *threeImgThreeArr;//三图组合3数组
@property (nonatomic, strong) NSMutableArray *threeImgThreeHArr;//三图组合3高度数组

@property (nonatomic, strong) NSMutableArray *threeImg4Arr;//三图组合4数组
@property (nonatomic, strong) NSMutableArray *threeImg4HArr;//三图组合4高度数组

@property (nonatomic, strong) NSMutableArray *nineArr;//九图数组
@property (nonatomic, strong) NSMutableArray *nineHArr;//九图高度数组

@property (nonatomic, strong) NSMutableArray *imageTwoturnArr;//两图切换数组
@property (nonatomic, strong) NSMutableArray *imageTwoturnHArr;//两图切换高度数组

@property (nonatomic, strong) NSMutableArray *recEightListArr; //推荐商品8数组
@property (nonatomic, strong) NSMutableArray *proList2Arr;//商品列表2数组

@property (nonatomic, strong) NSMutableArray *recList2Arr;//推荐列表2

@property (nonatomic, strong) NSMutableArray *zyhdArr;//左右滑动数组

@property (nonatomic, strong) NSMutableArray *rankList2Arr;//排行榜2数组

@property (nonatomic, strong) NSMutableArray *proList4Arr;//商品列表4数组

@property (nonatomic, strong) NSMutableArray *proList7Arr;//商品列表7数组

@property (nonatomic, strong) NSMutableArray *proList1Arr;//商品列表1数组

@property (nonatomic, strong) NSMutableArray *proList8Arr;//商品列表8数组

@property (nonatomic, strong) NSMutableArray *stackbannerArr;
@property (nonatomic, strong) NSMutableArray *stackbannerHArr;

@property (nonatomic, strong) NSMutableArray *tabArr;
@property (nonatomic, strong) NSMutableArray *tabHArr;
@property (nonatomic, strong) NSMutableArray *tabContArrs; //二维数组 里面是多个cont数组

@property (nonatomic, strong) NSMutableArray *storeArr;//底部商品的分类数组

@property (nonatomic, strong) NSMutableArray *limitArr;//限时抢购数组
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArr;//底部商品列表数组
@property (nonatomic, strong) NSMutableArray *goodsHArr;//底部推荐商品高度列表
@property (nonatomic, strong) NSMutableArray *datas;//二维高度数组
@property (nonatomic, assign) CGFloat hei;//上面topcell高度 topcell高度


@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *xgToken;//推送相关 设备token
@property (nonatomic, strong) NSString *deviceToken;//设备唯一标识

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗
@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;
//@property (nonatomic, strong) UITabBarItem * cartabBarItem;//购物车的tabBarItem



//修改数据源
@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, strong) NSString *isRec;//是否闪送
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, strong) HGCategoryView *categoryView;

@property (nonatomic, strong) UIButton *backTopBt;//回到顶部按钮

@property (nonatomic, strong) UIButton *hangFloatBt;
@property (nonatomic, strong) MMHomePageItemModel *hangFloatModel;



@end

@implementation MMHomePageVC

-(UIButton *)hangFloatBt{
    if(!_hangFloatBt){
        _hangFloatBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 60, self.backTopBt.y - 60, 50, 50)];
        _hangFloatBt.hidden = YES;
        [_hangFloatBt addTarget:self action:@selector(clickHangFloat) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hangFloatBt;
}

-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = NO;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}

-(NSMutableArray *)limitArr{
    if(!_limitArr){
        _limitArr = [NSMutableArray array];
    }
    return _limitArr;
}

-(NSMutableArray *)items{
    if(!_items){
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [[NSMutableArray alloc]init];
    }
    return _bannerArr;
}

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

-(NSMutableArray *)singleArr{
    if(!_singleArr){
        _singleArr = [[NSMutableArray alloc]init];
    }
    return _singleArr;
}

-(NSMutableArray *)singleHArr{
    if(!_singleHArr){
        _singleHArr = [[NSMutableArray alloc]init];
    }
    return _singleHArr;
}

-(NSMutableArray *)twoimg1Arr{
    if(!_twoimg1Arr){
        _twoimg1Arr = [[NSMutableArray alloc]init];
    }
    return _twoimg1Arr;
}

-(NSMutableArray *)twoimg2Arr{
    if(!_twoimg2Arr){
        _twoimg2Arr = [NSMutableArray array];
    }
    return _twoimg2Arr;
}

-(NSMutableArray *)twoimg1HArr{
    if(!_twoimg1HArr){
        _twoimg1HArr = [[NSMutableArray alloc]init];
    }
    return _twoimg1HArr;
}

-(NSMutableArray *)twoimg2HArr{
    if(!_twoimg2HArr){
        _twoimg2HArr = [NSMutableArray array];
    }
    return _twoimg2HArr;
}

-(NSMutableArray *)threeArr{
    if(!_threeArr){
        _threeArr = [[NSMutableArray alloc]init];
    }
    return _threeArr;
}

-(NSMutableArray *)threeImgThreeArr{
    if(!_threeImgThreeArr){
        _threeImgThreeArr = [NSMutableArray array];
    }
    return _threeImgThreeArr;
}

-(NSMutableArray *)threeImgThreeHArr{
    if(!_threeImgThreeHArr){
        _threeImgThreeHArr = [NSMutableArray array];
    }
    return _threeImgThreeHArr;
}

-(NSMutableArray *)threeImg4Arr{
    if(!_threeImg4Arr){
        _threeImg4Arr = [NSMutableArray array];
    }
    return _threeImg4Arr;
}

-(NSMutableArray *)threeImg4HArr{
    if(!_threeImg4HArr){
        _threeImg4HArr = [NSMutableArray array];
    }
    return _threeImg4HArr;
}

-(NSMutableArray *)nineArr{
    if(!_nineArr){
        _nineArr = [NSMutableArray array];
    }
    return _nineArr;
}

-(NSMutableArray *)nineHArr{
    if(!_nineHArr){
        _nineHArr = [NSMutableArray array];
    }
    return _nineHArr;
}

-(NSMutableArray *)imageTwoturnArr{
    if(!_imageTwoturnArr){
        _imageTwoturnArr = [NSMutableArray array];
    }
    return _imageTwoturnArr;
}

-(NSMutableArray *)imageTwoturnHArr{
    if(!_imageTwoturnHArr){
        _imageTwoturnHArr = [NSMutableArray array];
    }
    return _imageTwoturnHArr;
}

-(NSMutableArray *)recEightListArr{
    if(!_recEightListArr){
        _recEightListArr = [NSMutableArray array];
    }
    return _recEightListArr;
}

-(NSMutableArray *)proList2Arr{
    if(!_proList2Arr){
        _proList2Arr = [NSMutableArray array];
    }
    return _proList2Arr;
}

-(NSMutableArray *)recList2Arr{
    if(!_recList2Arr){
        _recList2Arr = [NSMutableArray array];
    }
    return _recList2Arr;
}
-(NSMutableArray *)zyhdArr{
    if(!_zyhdArr){
        _zyhdArr = [NSMutableArray array];
    }
    return _zyhdArr;
}

-(NSMutableArray *)tabArr{
    if(!_tabArr){
        _tabArr = [NSMutableArray array];
    }
    return _tabArr;
}

-(NSMutableArray *)rankList2Arr{
    if(!_rankList2Arr){
        _rankList2Arr = [NSMutableArray array];
    }
    return _rankList2Arr;
}

-(NSMutableArray *)proList4Arr{
    if(!_proList4Arr){
        _proList4Arr = [NSMutableArray array];
    }
    return _proList4Arr;
}

-(NSMutableArray *)proList7Arr{
    if(!_proList7Arr){
        _proList7Arr = [NSMutableArray array];
    }
    return _proList7Arr;
}

-(NSMutableArray *)proList1Arr{
    if(!_proList1Arr){
        _proList1Arr = [NSMutableArray array];
    }
    return _proList1Arr;
}

-(NSMutableArray *)proList8Arr{
    if(!_proList8Arr){
        _proList8Arr = [NSMutableArray array];
    }
    return _proList8Arr;
}

-(NSMutableArray *)stackbannerArr{
    if(!_stackbannerArr){
        _stackbannerArr = [NSMutableArray array];
    }
    return _stackbannerArr;
}

-(NSMutableArray *)stackbannerHArr{
    if(!_stackbannerHArr){
        _stackbannerHArr = [NSMutableArray array];
    }
    return _stackbannerHArr;
}

-(NSMutableArray *)tabHArr{
    if(!_tabHArr){
        _tabHArr = [NSMutableArray array];
    }
    return _tabHArr;
}
-(NSMutableArray *)tabContArrs{
    if(!_tabContArrs){
        _tabContArrs = [NSMutableArray array];
    }
    return _tabContArrs;
}

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [[NSMutableArray alloc]init];
    }
    return _goodsArr;
}

-(NSMutableArray *)goodsHArr{
    if(!_goodsHArr){
        _goodsHArr = [[NSMutableArray alloc]init];
    }
    return _goodsHArr;
}

-(NSMutableArray *)storeArr{
    if(!_storeArr){
        _storeArr = [NSMutableArray array];
    }
    return _storeArr;
}

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

-(HGCategoryView *)categoryView{
    if(!_categoryView){
        _categoryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 46)];
        _categoryView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _categoryView.delegate = self;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.storeArr.count; i++) {
            MMSortModel *model = self.storeArr[i];
            [arr addObject:model.Name];
        }
        _categoryView.titles = arr;
        _categoryView.alignment = HGCategoryViewAlignmentCenter;
        _categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleNormalColor = TCUIColorFromRGB(0x282828);
        _categoryView.titleSelectedColor = TCUIColorFromRGB(0x282828);
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
        _categoryView.vernier.backgroundColor = redColor2;
        _categoryView.itemSpacing = 24;
        _categoryView.topBorder.hidden = YES;
        _categoryView.bottomBorder.hidden = YES;
        _categoryView.vernier.height = 2.0f;
        _categoryView.vernierWidth = 20;
    }
    return _categoryView;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionHeadersPinToVisibleBounds = YES;
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
//        layout.headerReferenceSize = CGSizeMake(WIDTH,46);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight + 12, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - 12) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_mainCollectionView registerClass:[MMHomePageTopCell class]
        forCellWithReuseIdentifier:@"topcell"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        }
    return _mainCollectionView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [TalkingDataSDK onPageBegin:@"首页"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.xgToken = [self.userDefaults valueForKey:@"xgToken"];
    self.deviceToken = [self.userDefaults valueForKey:@"deviceToken"];
    self.page = 1;
    self.isRec = @"1";
    self.storeID = @"1058";
   
    if(self.xgToken && self.deviceToken){
        [self SetSSIDtoken];
    }
    
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }

    
    
    
    [kNotificationCenter addObserver:self selector:@selector(jumpOrRequest) name:@"selectCountry" object:nil];
    
    [self jumpOrRequest];
    // Do any additional setup after loading the view.
}

-(void)jumpOrRequest{
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    if(!self.lang){
        [self RouteJump:@"/member/home/currency"];
    }else{
        [self requestHttp];
    }
}

-(void)requestHttp{
    [self requestData];
    
//        [self requestGoodsData];
    [self GetStoreRecommendAndTypeID:self.storeID AndIsRec:self.isRec];
    
    [self GetStores];
    
    [self GetVersion];
    
}

-(void)SetSSIDtoken{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetSSIDtoken"];
    NSDictionary *param = @{@"type":@"2",@"SSID":self.deviceToken,@"token":self.xgToken};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)setUI{
    UIView *naView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight + 12)];
    naView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:naView];
    
    UIButton *scanBt = [[UIButton alloc]initWithFrame:CGRectMake(15,StatusBarHeight + 18, 18, 18)];
    [scanBt setBackgroundImage:[UIImage imageNamed:@"scanicon"] forState:(UIControlStateNormal)];
    [scanBt addTarget:self action:@selector(clickScan) forControlEvents:(UIControlEventTouchUpInside)];
    scanBt.timeInterval = 2.0;
    [naView addSubview:scanBt];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 260)/2, StatusBarHeight + 11, 260, 32)];
    searchView.backgroundColor = TCUIColorFromRGB(0xf7f6f5);
    searchView.layer.cornerRadius = 16;
    searchView.layer.masksToBounds = YES;
    [naView addSubview:searchView];
    
    UIImageView *searchIcon = [[UIImageView alloc]init];
    searchIcon.image = [UIImage imageNamed:@"homesearch"];
    [searchView addSubview:searchIcon];
    
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(16);
    }];
    
    UILabel *placeLabel = [UILabel publicLab:@"疯狂购物节，黑五狂欢购！" textColor:TCUIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    [searchView addSubview:placeLabel];
    self.placeLabel = placeLabel;

    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(searchIcon.mas_right).mas_offset(6);
            make.centerY.mas_equalTo(searchView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(14);
    }];
    
    UIButton *searchBt = [[UIButton alloc]init];
    [searchBt setBackgroundColor:UIColor.clearColor];
    searchBt.timeInterval = 2.0;
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [searchView addSubview:searchBt];
    
    [searchBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UIButton *notifiBt = [[UIButton alloc]init];
    [notifiBt setBackgroundImage:[UIImage imageNamed:@"smallbell"] forState:(UIControlStateNormal)];
    notifiBt.timeInterval = 2.0;
    [notifiBt addTarget:self action:@selector(clickNotification) forControlEvents:(UIControlEventTouchUpInside)];
    [naView addSubview:notifiBt];
    
    [notifiBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(StatusBarHeight + 18);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.view addSubview:self.mainCollectionView];
    
    [self.view addSubview:self.backTopBt];
    
    [self.view addSubview:self.hangFloatBt];
    
    [self setupRefresh];
    NSLog(@"ui创建完成");
}


#pragma mark -- requestData
//好多页面都有用到的接口 目前取购物车数量
-(void)GetVersion{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetVersion"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        MMVersionModel *model = [MMVersionModel mj_objectWithKeyValues:jsonDic];
        weakself.cartabBarItem.badgeValue = model.CartCount;
        if([model.CartCount isEqualToString:@"0"]){
            weakself.cartabBarItem.badgeValue = nil;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//获取首页底部商品分类
-(void)GetStores{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStores"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMSortModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            NSDictionary *dic = @{@"ID":@"1058",@"Name":@"48h"};
            MMSortModel *model = [MMSortModel mj_objectWithKeyValues:dic];
            [weakself.storeArr addObject:model];
            [weakself.storeArr addObjectsFromArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//获取底部商品数据
-(void)GetStoreRecommendAndTypeID:(NSString *)ID AndIsRec:(NSString *)isRec{
    KweakSelf(self);
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:ID forKey:@"StoreID"];
    [param setValue:isRec forKey:@"isrec"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [weakself.goodsArr removeAllObjects];
        NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        weakself.goodsArr = [NSMutableArray arrayWithArray:goodsArr];
        NSString *endPage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
        weakself.endpage = [endPage integerValue];
        
        [weakself setUI];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refresh{
    KweakSelf(self);
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:self.storeID forKey:@"StoreID"];
    [param setValue:self.isRec forKey:@"isrec"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [weakself.goodsArr removeAllObjects];
        NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        weakself.goodsArr = [NSMutableArray arrayWithArray:goodsArr];
        NSString *endPage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
        weakself.endpage = [endPage integerValue];
        
        [weakself.mainCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求装修模块

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_queue_t q = dispatch_queue_create("request", DISPATCH_QUEUE_CONCURRENT);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPageIndex"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"0" forKey:@"app"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];

//    NSDictionary *param = @{@"app":@"0",@"membertoken":@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDEzMTAwODksIm1pZCI6ODEzODl9.2UAcb_PjQZHXSbY6F2pkgYHLFg5Tsna2IiTdwRrj7oM",@"lang":@"0",@"cry":@"9"};
    dispatch_async(q, ^{
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([codeStr isEqualToString:@"1"]){//请求成功
                weakself.homeModel = [MMHomePageModel mj_objectWithKeyValues:jsonDic];
                NSArray *items = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
                for (MMHomePageItemModel*itemModel in items) {
                    if([itemModel.type isEqualToString:@"banner"]){
                        [self.bannerArr addObject:itemModel];
                    }else if([itemModel.type isEqualToString:@"nav"]){
                        [weakself.linkArr addObject:itemModel];
                    }else if([itemModel.type isEqualToString:@"iadvimg"]){
                        [weakself.singleArr addObject:itemModel];
                    }else if([itemModel.type isEqualToString:@"twoimg1"]){
                        [weakself.twoimg1Arr addObject:itemModel];
                    }else if([itemModel.type isEqualToString:@"twoimg2"]){
                        [weakself.twoimg2Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"threeimg2"]){
                        [weakself.threeArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"limit1"]){
                        [weakself.limitArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"threeimg3"]){
                        [weakself.threeImgThreeArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"threeimg4"]){
                        [weakself.threeImg4Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"jiutu"]){
                        [weakself.nineArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"twoimgturn"]){
                        [weakself.imageTwoturnArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"reclist8"]){
                        [weakself.recEightListArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"prolist2"]){
                        [weakself.proList2Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"reclist2"]){
                        [weakself.recList2Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"zuoyouhd"]){
                        [weakself.zyhdArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"ranklist2"]){
                        [weakself.rankList2Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"prolist4"]){
                        [weakself.proList4Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"prolist7"]){
                        [weakself.proList7Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"prolist1"]){
                        [weakself.proList1Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"prolist8"]){
                        [weakself.proList8Arr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"stackbanners"]){
                        [weakself.stackbannerArr addObject:itemModel];
                    }else if ([itemModel.type isEqualToString:@"hangfloat2"]){
                        weakself.hangFloatModel = itemModel;
                    }
                    else if ([itemModel.type isEqualToString:@"classtab"]){
                        NSLog(@"%@",itemModel);
                        [weakself.tabArr addObject:itemModel];
                        for (int i = 0; i < weakself.homeModel.list.count; i++) {
                            NSDictionary *dic = weakself.homeModel.list[i];
                            NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                            if([type isEqualToString:@"classtab"]){
                                NSArray *arr = [MMHomePageContModel mj_objectArrayWithKeyValuesArray:dic[@"cont"]];
                                [weakself.tabContArrs addObject:arr];
                            }
                        }
                    }
                }
                
                weakself.items = [NSMutableArray arrayWithArray:items];
                
                
                dispatch_queue_t q1 = dispatch_queue_create("hei1", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(q1, ^{
                    //banner高度
                    for ( MMHomePageItemModel *model in items) {
                        if([model.type isEqualToString:@"banner"]){
                            
                            NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                            MMHomeImageModel *model1 = imgArr[0];
                            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                            weakself.hei = WIDTH/(size.width/size.height);
                            weakself.bannerHei = weakself.hei;
                       
                        }
                    }
                    //导航链接高度
                    for (MMHomePageItemModel *model in weakself.linkArr) {
                        if(model.cont.imglist.count > 5){
                            weakself.hei += 192;
                        }else{
                            weakself.hei += 96;
                        }
                    }
                    
                    //单图高度
                    for (MMHomePageItemModel *model in weakself.singleArr) {
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.cont.image]];
                        CGFloat height = WIDTH/(size.width/size.height);
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.singleHArr addObject:heiStr];
                        weakself.hei += height;
                    }
                    
                    //双图1高度
                    for (MMHomePageItemModel *model in weakself.twoimg1Arr) {
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        CGFloat wid = WIDTH/imgArr.count;
                        //(WIDTH - 10 * (imgArr.count + 1))/imgArr.count;
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = wid/(size.width/size.height);
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.twoimg1HArr addObject:heiStr];
                        weakself.hei += height;
                    }
                    
                    //双图组合2高度
                    for (MMHomePageItemModel *model in weakself.twoimg2Arr) {
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        
                        CGFloat top = [model.margin1 floatValue];
                        CGFloat bottom = [model.margin3 floatValue];
                        
                        CGFloat wid = (WIDTH - 20)/2;
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = wid/(size.width/size.height);
                        NSInteger column = imgArr.count/2;
                        CGFloat allHei = (height + 10) * column + top + bottom;
                        
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.twoimg2HArr addObject:heiStr];
                        weakself.hei += allHei;
                    }
                    
                    //两图切换高度
                    for (MMHomePageItemModel *model in weakself.imageTwoturnArr) {
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = WIDTH/(size.width/size.height) + [model.margin1 floatValue];
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.imageTwoturnHArr addObject:heiStr];
                        weakself.hei += height;
                    }
                    
                    //三图2高度
                    
                    double scale1 = 1.43; //左右图片的宽度比
                    double scale2 = 0.9; //左边图片的长宽比
                    float wid1 = (WIDTH - 30)/(1 + scale1);//左边图片宽度
                    float hei1 = wid1 / scale2;//左边图片高度
                    
                    for (int i = 0; i < weakself.threeArr.count; i++) {
                        weakself.hei += hei1;
                    }
                    
                    //三图三高度
                    for (MMHomePageItemModel *model in weakself.threeImgThreeArr) {
                        float top = [model.margin1 floatValue] > 0 ? [model.margin1 floatValue] : 0;
                        float bottom = [model.margin3 floatValue] > 0 ? [model.margin3 floatValue] : 0;
                        
                        float wid3 = (WIDTH - 30)/3;
                        NSInteger row = model.cont.imglist.count/3;
                        row = model.cont.imglist.count % 3 > 0 ? row + 1: row;
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = wid3/(size.width/size.height);
                        float hei = (height + 10) * row + top + bottom;
                        NSString *heiStr = [NSString stringWithFormat:@"%f",hei];
                        [weakself.threeImgThreeHArr addObject:heiStr];
                        weakself.hei += hei;
                    }
                    
                    //三图4高度
                    for (MMHomePageItemModel *model in weakself.threeImg4Arr) {
                        
                        float wid3 = WIDTH/3;
                        NSInteger row = model.cont.imglist.count/3;
                        row = model.cont.imglist.count % 3 > 0 ? row + 1: row;
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = wid3/(size.width/size.height);
                        float allHei = height * row;
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.threeImg4HArr addObject:heiStr];
                        weakself.hei += allHei;
                    }
                    
                    //推荐列表8高度
                    for (MMHomePageItemModel *model in weakself.recEightListArr) {
                        weakself.hei += 216;
                    }
                    
                    //商品列表2高度
                    for (int i = 0; i < weakself.proList2Arr.count; i++) {
                        weakself.hei += 186;
                    }
                    
                    //推荐列表2高度
                    for (int i = 0; i < weakself.recList2Arr.count; i++) {
                        weakself.hei += 186;
                    }
                    
                    //左右滑动高度
                    for (int i = 0; i < weakself.zyhdArr.count; i++) {
                        weakself.hei += 440;
                    }
                    //商品列表4高度
                    for (int i = 0; i < weakself.proList4Arr.count; i++) {
                        MMHomePageItemModel *model = weakself.proList4Arr[i];
                        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
                        weakself.hei += arr.count * 134;
                    }
                    
                    //商品列表7高度
                    for (int i = 0; i < weakself.proList7Arr.count; i++) {
                        MMHomePageItemModel *model = weakself.proList7Arr[i];
                        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
                        weakself.hei += arr.count * 134;
                    }
                    //商品列表1高度
                    for (int i = 0; i < weakself.proList1Arr.count; i++) {
                        MMHomePageItemModel *model = weakself.proList1Arr[i];
                        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
                        NSInteger row = arr.count/2;
                        row = arr.count%2 > 0 ? row + 1 : row;
                        
                        weakself.hei += 10 + 325 * row;
                    }
                    
                    //商品列表8高度
                    for (int i = 0; i < weakself.proList8Arr.count; i++) {
                        MMHomePageItemModel *model = weakself.proList8Arr[i];
                        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
                        NSInteger row = arr.count/3;
                        row = arr.count%3 > 0 ? row + 1 : row;
                        
                        weakself.hei += 221 * row;
                    }
                    
                    //排行榜2高度
                    for (int i = 0; i < weakself.rankList2Arr.count; i++) {
                        weakself.hei += 254;
                    }
                    //限时抢购高度
                    for (int i = 0; i < weakself.limitArr.count; i++) {
                        MMHomePageItemModel *model = weakself.limitArr[i];
                        float top = [model.margin1 floatValue];
                        float bottom = [model.margin3 floatValue];
                        weakself.hei += 264 + top + bottom;
                    }
                    
                    //九图轮播高度
                    for (MMHomePageItemModel *model in weakself.nineArr) {
                        NSInteger pagenum = [model.pagenum integerValue];
                        NSInteger row = pagenum/3;
                        float hei = row * 200;
                        NSString *heiStr = [NSString stringWithFormat:@"%f",hei];
                        [weakself.nineHArr addObject:heiStr];
                        weakself.hei += hei;
                    }
                    
                    //堆叠轮播高度
                    for (MMHomePageItemModel *model in weakself.stackbannerArr) {
                        float wid3 = WIDTH/2;
                        NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                        MMHomeImageModel *model1 = imgArr[0];
                        CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                        CGFloat height = wid3/(size.width/size.height);
                        NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                        [weakself.stackbannerHArr addObject:heiStr];
                        weakself.hei += height;
                    }
                    
                    //tab分类高度
                    for (NSArray *arr in weakself.tabContArrs) {
                        MMHomePageContModel *model = arr[0];
                        NSInteger num = model.prolist.count/2;
                        num = model.prolist.count%2 > 0 ? num + 1 : num;
                        CGFloat hei = num * ((WIDTH - 30)/2 + 153);
                        CGFloat hei1 = HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin;
                        hei = hei > hei1 ? hei1 : hei;
                        NSString *heiStr = [NSString stringWithFormat:@"%f",hei];
                        [weakself.tabHArr addObject:heiStr];
                        weakself.hei += hei;
                    }
                    
                    NSString *heiStr = [NSString stringWithFormat:@"%.2f",weakself.hei];
                    NSArray *heiArr1 = @[heiStr];
                    [weakself.datas addObject:heiArr1];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //请求成功 回到主线程 刷新UI
                        [ZTProgressHUD hide];
                        weakself.placeLabel.text = self.homeModel.keyword;
                        if(weakself.hangFloatModel){
                            [weakself.hangFloatBt sd_setImageWithURL:[NSURL URLWithString:weakself.hangFloatModel.havedian] forState:(UIControlStateNormal)];
                            weakself.hangFloatBt.hidden = NO;
                        }
                        [weakself.mainCollectionView reloadData];
                    });
                });
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    
}

//刷新
-(void)setupRefresh{
    
    KweakSelf(self);
    
    //上拉 加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            [self requestLoadMoreGoodsDataPage:(long)weakself.page];
        }else{
            [ZTProgressHUD showMessage:@"没有更多类似商品"];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
    }];
    
    
    self.mainCollectionView.mj_footer = footer;

}

//请求更多底部商品数据
-(void)requestLoadMoreGoodsDataPage:(NSInteger *)curr{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)curr];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:self.storeID forKey:@"StoreID"];
    [param setValue:self.isRec forKey:@"isrec"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    [ZTNetworking postWithUrlstring:url paramter:param success:^(NSString *jsonStr, NSDictionary *jsonDic) {
//        NSLog(@"%@",jsonDic);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([codeStr isEqualToString:@"1"]){//请求成功
            NSArray *goods = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(goods.count > 0){
                [weakself.goodsArr addObjectsFromArray:goods];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [weakself.mainCollectionView reloadSections:indexSet];
                [weakself.mainCollectionView.mj_footer endRefreshing];
            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

////刷新
//-(void)setupRefresh{
//
//    __block NSInteger page = 1;
//
//    //下拉
////    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        self.isrefresh = 1;
////    //刷新
////        [self requestGoodsDataPage:1];
////
////    }];
////    //设置刷新标题
////    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
////    [header setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
////    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
////    self.mainCollectionView.mj_header = header;
////    [header beginRefreshing];
//    //上拉 加载
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        page++;
//        [self requestLoadMoreGoodsDataPage:(long)page];
//
//    }];
//
//
//    self.mainCollectionView.mj_footer = footer;
//
//}
//
////请求更多底部商品数据
//-(void)requestLoadMoreGoodsDataPage:(NSInteger *)curr{
//    KweakSelf(self);
//    NSString *currStr = [NSString stringWithFormat:@"%ld",(long)curr];
//    NSString *url = @BaseUrl;
//    NSDictionary *param = @{@"t":@"GetRecommend",@"IsMinApp":@"0",@"membertoken":@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDIwMTgyMTIsIm1pZCI6ODEzODl9.bJoFmihrypGrSa2J5P0gvV1WkGGxQs1DFqGVY_mDYj4    ",@"ItemID":@"0",@"StoreID":@"0",@"otype":@"1",@"curr":currStr,@"limit":@"20",@"pid":@"0",@"brand":@"0",@"lang":@"0",@"cry":@"9"};
//    [ZTNetworking postWithUrlstring:url paramter:param success:^(NSString *jsonStr, NSDictionary *jsonDic) {
////        NSLog(@"%@",jsonDic);
//        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
//        if([codeStr isEqualToString:@"1"]){//请求成功
//            NSArray *goods = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
//            if(goods.count > 0){
//                [weakself.goodsArr addObjectsFromArray:goods];
//                float hei = (WIDTH - 30)/2 + 153;
//                float hei1 = (WIDTH - 30)/2 + 133;
//                NSString *heiStr = [NSString stringWithFormat:@"%.2f",hei];
//                NSString *heiStr1 = [NSString stringWithFormat:@"%.2f",hei1];
//                for (MMHomeRecommendGoodsModel *model in goods) {
//                    if(model.ShortName.length > 0){
//                        [weakself.goodsHArr addObject:heiStr];
//                    }else{
//                        [weakself.goodsHArr addObject:heiStr1];
//                    }
//                }
//
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                [weakself.mainCollectionView reloadSections:indexSet];
//                [weakself.mainCollectionView.mj_footer endRefreshing];
//            }else{
//                [ZTProgressHUD showMessage:@"没有更多可推荐商品"];
//              // [weakself.mainCollectionView reloadData];
//               weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
//            }
//        }else{
//            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
//        }
//
//
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}


#pragma mark - WaterFlowLayoutDelegate
#pragma mark <XPCollectionViewWaterfallFlowLayoutDelegate>

//- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
//    if(section == 0){
//        return 1;
//    }
//    return  2;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0){
//        return self.hei;
//    }else{
//        NSString *str = self.goodsHArr[indexPath.item];
//        return [str floatValue];
//    }
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.0;
//}

#pragma mark -- uicollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(self.bannerArr.count > 0){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.bannerArr.count > 0){
        if(section == 0){
            return 1;
        }else{
            return self.goodsArr.count;
        }
    }else{
        return self.goodsArr.count;
    }
}
    
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    if(self.bannerArr.count > 0){
        if(indexPath.section == 0){
            MMHomePageTopCell *cell =
            (MMHomePageTopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.model = weakself.homeModel;
            cell.hei = weakself.hei;
            cell.bannerHei = weakself.bannerHei;
            cell.singleHArr = weakself.singleHArr;
            cell.twoimg1HArr = weakself.twoimg1HArr;
            cell.twoimg2HArr = weakself.twoimg2HArr;
            cell.threeimg3HArr = weakself.threeImgThreeHArr;
            cell.threeImg4HArr = weakself.threeImg4HArr;
            cell.nineImgHArr = weakself.nineHArr;
            cell.imageTwoTurnHArr = weakself.imageTwoturnHArr;
           
            cell.stackBannerHArr = weakself.stackbannerHArr;
            
            
            cell.BannerTapBlock = ^(NSString * _Nonnull indexStr) {
               
                [weakself RouteJump:indexStr];
            };
            cell.LinkTapBlock = ^(NSString * _Nonnull indexStr) {
                
                [weakself RouteJump:indexStr];
            };
            cell.SingleTapBlock = ^(NSString * _Nonnull indexStr) {
                
                [weakself RouteJump:indexStr];
            };
            cell.TwoTapImgBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.TwoTapImgTBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.ThreeTapLeftImgBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.ThreeTapTopImgBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.ThreeTapBottomImgBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.ThreeTapImgThreeBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.NineTapImageBlock = ^(NSString * _Nonnull indexStr) {
                [weakself RouteJump:indexStr];
            };
            cell.limitTapMoreBlock = ^(NSString * _Nonnull str) {
                [weakself RouteJump:str];
            };
            cell.tapTwoImageChangeBlock = ^(NSString * _Nonnull str) {
                [weakself RouteJump:str];
            };
            cell.tapRecEightGoodsBlock = ^(NSString * _Nonnull str) {
                [weakself RouteJump:str];
            };
            cell.tapRecEightGoodsCarBlock = ^(NSString * _Nonnull str) {
                weakself.goodsId = str;
                [weakself GetProductBuyTest:str];
            };
            cell.tapProList2GoodsBlock = ^(NSString * _Nonnull str) {
                [weakself RouteJump:str];
            };
            cell.tapProList2GoodsCarBlock = ^(NSString * _Nonnull str) {
                weakself.goodsId = str;
                [weakself GetProductBuyTest:str];
            };
           
            
            return cell;
        }else{
            MMHomeShopGoodsCell *cell =
            (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            cell.model = self.goodsArr[indexPath.item];
            cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
                weakself.goodsId = indexStr;
                [weakself GetProductBuyTest:indexStr];
            };
            return cell;
        }
    }
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.goodsArr[indexPath.item];
    return cell;
   
}
    
   


//设置区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   
    if(self.items.count > 0 && self.goodsArr.count > 0){
        if(section == 1){
            return CGSizeMake(WIDTH, 56);
        }else{
            return CGSizeZero;
        }
    }else if (self.goodsArr.count > 0){
        if(section == 0){
            return CGSizeMake(WIDTH, 56);
        }
    }
    return CGSizeMake(WIDTH, 0.01);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
    if(self.items.count > 0 && self.goodsArr.count > 0){
        if(indexPath.section == 1){
            [headV addSubview:self.categoryView];
        }
       
    }else if (self.goodsArr.count > 0){
        if(indexPath.section == 0){
            [headV addSubview:self.categoryView];
        }
    }

    
    return headV;
}


    //设置cell大小
    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if(self.bannerArr.count > 0){
            if(indexPath.section == 0){
                
                return CGSizeMake(WIDTH, self.hei);
            }else{
                MMHomeRecommendGoodsModel *model = self.goodsArr[indexPath.item];
                if([model.ShortName isEqualToString:@""]){
                    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);;
                }else{
                    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);;
                }
                
            }
        }
        return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
        
    }



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        MMHomeRecommendGoodsModel *model = self.goodsArr[indexPath.item];
        [self RouteJump:model.Url];
    }
}

#pragma mark -- hgcategarydelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    MMSortModel *model = self.storeArr[index];
    self.storeID = model.ID;
    if(index == 0){
        self.isRec = @"1";
    }else{
        self.isRec = @"0";
    }
    [self refresh];
}

#pragma mark -- 请求规格数据
-(void)GetProductBuyTest:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBuyTest"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"id":ID,@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.goodsSpecInfo = [MMGoodsSpecModel mj_objectWithKeyValues:jsonDic];
            weakself.attid = weakself.goodsSpecInfo.attbuying.attid;
            weakself.skuPopView = [[MMSelectSKUPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:weakself.goodsSpecInfo];
        
            self.skuPopView.SkuAndNumBlock = ^(MMGoodsAttdataModel * _Nonnull model, NSString * _Nonnull numStr) {
                weakself.attid = model.ID;
                weakself.numStr = numStr;
            };
            self.skuPopView.addCarBlock = ^(NSString * _Nonnull str) {
                [weakself requestAddCar];
            };
            
            self.skuPopView.buyNowBlock = ^(NSString * _Nonnull str) {
                [weakself requestBuyNow];
            };
            weakself.skuPopView.type = @"0";
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.skuPopView];
            [weakself.skuPopView showView];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 后面请求的接口
-(void)requestAddCar{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
   // [param setValue:@"CartPlus" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.goodsId forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:@"1" forKey:@"back"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMShopCarModel *model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.cartabBarItem.badgeValue = model.num;
            if([model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)requestBuyNow{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"FastAdd"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
   // [param setValue:@"CartPlus" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.goodsId forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:@"1" forKey:@"back"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMConfirmOrderViewController *confirmVC = [[MMConfirmOrderViewController alloc]init];
            [weakself.navigationController pushViewController:confirmVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)backTop{
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0)];
    }];
    
}

-(void)clickScan{
    [ZTProgressHUD showMessage:@"点击扫一扫"];
    [self RouteJump:@"/pages/index/page?id=1099"];
//    MMTestVC *raffleVC = [[MMTestVC alloc]init];
//    [self.navigationController pushViewController:raffleVC animated:YES];
}

-(void)goShopList{
    MMGoodsListViewController *listVC = [[MMGoodsListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}

-(void)clickNotification{
    MMMessageCenterVC *messageVC = [[MMMessageCenterVC alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)clickSearch{
    MMSearchViewController *searchVC = [[MMSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark -- uiscrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.mainCollectionView.contentOffset.y >= 300){
        self.backTopBt.hidden = NO;
    }else{
        self.backTopBt.hidden = YES;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.25 animations:^{
        self.hangFloatBt.x = WIDTH - 25;
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.25 animations:^{
        self.hangFloatBt.x = WIDTH - 60;
    }];
}

-(void)clickHangFloat{
    [self RouteJump:self.hangFloatModel.cont.link];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"首页"];
}

@end
