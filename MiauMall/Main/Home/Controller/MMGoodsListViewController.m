//
//  MMGoodsListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import "MMGoodsListViewController.h"
#import "MMBrandModel.h"
#import "MMSortModel.h"
#import "MMGoodsListCell.h"
#import "MMSelectBrandPopView.h"
#import "MMGoodsClassifyTopView.h"
#import "MMPriceScreenView.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

#import "MMBrandPopView.h"
#import "MMPriceFilterPopView.h"

//英文版
#import "MMShopListEnglistTopView.h"
#import "MMGoodsListEnglishCell.h"

@interface MMGoodsListViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) MMTitleView *naView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *isNew;//默认0   为1是请求新品
@property (nonatomic, strong) NSMutableArray *sortArr;//分类数组
@property (nonatomic, strong) NSMutableArray *brandArr;//品牌数组
@property (nonatomic, strong) NSMutableArray *dataArr;//商品数组
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *otype; //综合0 按销量排序为1 价格升序 4 价格降序3
@property (nonatomic, strong) NSString *isrec;//48小时发货选中时 为1 默认为0
@property (nonatomic, strong) UIButton *compBt;//综合
@property (nonatomic, strong) UIButton *speedBt;//48小时
@property (nonatomic, strong) UIButton *salesBt;//销量
@property (nonatomic, strong) UIButton *priceBt;//价格
@property (nonatomic, strong) UIButton *brandBt;//品牌
@property (nonatomic, strong) UIButton *sortBt;//分类
@property (nonatomic, strong)UIButton *screenBt;//筛选 弹出弹窗
@property (nonatomic, strong)UIButton *switchBT;//切换列表样式按钮
@property (nonatomic, strong) UIButton *neBt;

@property (nonatomic, assign) NSInteger page;//每次刷新 page都重新变为1
//@property (nonatomic, strong) NSString *pids;//分类 多选，拼接
@property (nonatomic, strong) NSString *bids;//品牌 多选，拼接

@property (nonatomic, strong) MMBrandPopView *branPopView;//品牌分类弹窗
@property (nonatomic, strong) NSString *isShow;//0 默认不显示时 1已经展示

@property (nonatomic, strong) MMGoodsClassifyTopView *topView;
@property (nonatomic, strong) NSMutableArray *screenArr;
@property (nonatomic, strong) MMPriceFilterPopView *priceScreenView;//价格筛选弹窗
@property (nonatomic, strong) NSString *isShow1;//0 没展开 1已经展开
@property (nonatomic, strong) NSString *minprice;
@property (nonatomic, strong) NSString *maxprice;

@property (nonatomic, assign) NSInteger endpage;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

@property (nonatomic, strong) UITabBarItem *cartabBarItem;

@property (nonatomic, strong) UIButton *backTopBt;

@property (nonatomic, strong) NSString *Sign;

@property (nonatomic, strong) MMShopListEnglistTopView *topViewE;
@property (nonatomic, assign) float topH;

@end

@implementation MMGoodsListViewController

-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}


-(NSMutableArray *)screenArr{
    if(!_screenArr){
        _screenArr = [NSMutableArray array];
    }
    return _screenArr;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.numberOfColumns = 2;
//        layout.insets = UIEdgeInsetsMake(0, 10, 0, 10);
//        layout.rowGap = 10;
//        layout.columnGap = 10;
//        layout.sectionCount = 2;
//        layout.itemHeights = self.goodsHArr;
        // 头部视图悬停
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.sectionHeadersPinToVisibleBounds = NO;
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 127 + 88, WIDTH, HEIGHT - 127 - 88 - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
        if([self.lang isEqualToString:@"1"]){
            _mainCollectionView.frame = CGRectMake(0,self.topH, WIDTH, HEIGHT - self.topH - TabbarSafeBottomMargin);
        }
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _mainCollectionView;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 127 + 88, WIDTH, HEIGHT - StatusBarHeight - 127 - 88 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        if([self.lang isEqualToString:@"1"]){
            _mainTableView.frame = CGRectMake(0, self.topH , WIDTH, HEIGHT - self.topH - TabbarSafeBottomMargin);
        }
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xdddddd);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}
-(MMGoodsClassifyTopView *)topView{
    if(!_topView){
        _topView = [[MMGoodsClassifyTopView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, 88)];
    }
    return _topView;
}

-(NSMutableArray *)sortArr{
    if(!_sortArr){
        _sortArr = [NSMutableArray array];
    }
    return _sortArr;
}

-(NSMutableArray *)brandArr{
    if(!_brandArr){
        _brandArr = [NSMutableArray array];
    }
    return _brandArr;
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
    [TalkingDataSDK onPageBegin:@"商品列表页面"];
    
    if(self.brandBt){
        self.brandBt.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.otype = @"0";
    self.isNew = @"0";
    self.isrec = @"0";
    self.page = 1;
    self.isShow = @"0";
    self.isShow1 = @"0";
    
    
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self requestHttpData];
    // Do any additional setup after loading the view.
}

-(void)requestHttpData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求商品详情主要数据
           [weakself requestList];
       });
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求次要数据
           [weakself requestTopData];
       });
    
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求价格筛选数组
        [weakself GetStores];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        
        if([weakself.lang isEqualToString:@"1"]){
            [weakself setUI1];
        }else{
            [weakself setUI];
        }
        
    });
}

-(void)setUI1{
    
    KweakSelf(self);
    [ZTProgressHUD hide];
    
    float hei = 0;
    for (int i = 0; i < self.sortArr.count; i++) {
        MMSortModel *model = self.sortArr[i];
        CGSize size = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] maxSize:CGSizeMake(70,MAXFLOAT)];
        if(size.height > hei){
            hei = size.height;
        }
    }
    
    self.topH = hei + StatusBarHeight + 175 + 54;
    
    
    
    [self.view addSubview:self.mainTableView];
    self.mainCollectionView.hidden = YES;
    [self.view addSubview:self.mainCollectionView];
    
    
    [self.view addSubview:self.backTopBt];
    
    
    self.branPopView = [[MMBrandPopView alloc]initWithFrame:CGRectMake(0,-HEIGHT, WIDTH, HEIGHT - TabbarSafeBottomMargin) andHei:hei + StatusBarHeight + 175 + 54 - 1];
    self.branPopView.dataArr = self.brandArr;
    self.branPopView.sureSelectBlock = ^(NSArray * _Nonnull seleArr, NSString * _Nonnull nameStr) {
               
        weakself.isShow = @"0";
        weakself.brandBt.userInteractionEnabled = YES;
        weakself.bids = [seleArr componentsJoinedByString:@","];
        
        if(seleArr.count > 0){

            weakself.brandBt.selected = YES;
            [weakself.brandBt setTitle:nameStr forState:(UIControlStateSelected)];
            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }else{
            weakself.brandBt.selected = NO;
            [weakself.brandBt setTitle:[UserDefaultLocationDic valueForKey:@"ibrand"] forState:(UIControlStateNormal)];
            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            
        }
        
        [weakself requestRefresh];
    };
    
    self.branPopView.sureHideBlock = ^(NSString * _Nonnull str) {
        weakself.brandBt.userInteractionEnabled = YES;
    };
    [self.view addSubview:self.branPopView];
//    [self.branPopView showView];
    
    self.priceScreenView = [[MMPriceFilterPopView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, HEIGHT - TabbarSafeBottomMargin) andTopHeight:StatusBarHeight + 175 + hei + 54 - 1 andPriceArr:self.screenArr andSign:self.Sign];
    
//    self.priceScreenView = [[MMPriceFilterPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - TabbarSafeBottomMargin) andDataArr:self.screenArr andHei:StatusBarHeight + 127 + 88];
    self.priceScreenView.surePriceBlock = ^(NSString * _Nonnull min, NSString * _Nonnull max) {
        weakself.isShow1 = @"0";
        weakself.screenBt.userInteractionEnabled = YES;
        weakself.brandBt.userInteractionEnabled = YES;
        weakself.minprice = min;
        weakself.maxprice = max;
        if(!min || [min isEmpty] || min == nil){
            [weakself.screenBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        }else{
            [weakself.screenBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
        }
        [weakself requestRefresh];
    };
    self.priceScreenView.sureHideBlock = ^(NSString * _Nonnull str) {
        weakself.screenBt.userInteractionEnabled = YES;
    };
    
    [self.view addSubview:self.priceScreenView];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    self.naView = titleView;
    self.naView.titleLa.text = self.titleStr;
    
   
    
    NSInteger index = 0;
    NSString *pid = self.param[@"pid"];
    if(self.pid){
        for (int i = 0; i < self.sortArr.count; i++) {
            MMSortModel *model = self.sortArr[i];
            if([self.pid isEqualToString:model.ID]){
               index = i;
            }
        }
    }else{
        for (int i = 0; i < self.sortArr.count; i++) {
            MMSortModel *model = self.sortArr[i];
            if([pid isEqualToString:model.ID]){
                index = i;
            }
        }
    }
    
    self.topViewE = [[MMShopListEnglistTopView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, hei + 100) andDataArr:self.sortArr andIndex:index andHei:hei + 82];
    [self.view addSubview:self.topViewE];
    
    self.topViewE.tapSortBlock = ^(NSString * _Nonnull ID) {
        weakself.pids = ID;
        [weakself requestRefresh];
    };
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topViewE.frame) - 1, WIDTH, 75)];
    topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topView];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"izonghe"],[UserDefaultLocationDic valueForKey:@"salesVol"],[UserDefaultLocationDic valueForKey:@"iprice"]];
    CGFloat wid = (WIDTH - 180)/3;
    CGFloat space = 20;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((wid + space) * i, 14, wid, 13)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
        [topView addSubview:btn];
        
        if(i == 0){
            self.compBt = btn;
        }else if (i == 1){
            self.salesBt = btn;
        }else{
            self.priceBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }
    }
    
    CGSize size3 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ifilter"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *screenBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceBt.frame) + 20, 14, size3.width + 16, 13)];
    [screenBt setImage:[UIImage imageNamed:@"screen_icon"] forState:(UIControlStateNormal)];
    [screenBt setTitle:[UserDefaultLocationDic valueForKey:@"ifilter"] forState:(UIControlStateNormal)];
    [screenBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    screenBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [screenBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [screenBt addTarget:self action:@selector(selectPrice) forControlEvents:(UIControlEventTouchUpInside)];
    [screenBt setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    [topView addSubview:screenBt];
    self.screenBt = screenBt;
    
    UIButton *switchBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 26, 14, 13, 13)];
    [switchBt setImage:[UIImage imageNamed:@"vp_icon"] forState:(UIControlStateNormal)];//水平
    [switchBt setImage:[UIImage imageNamed:@"hp_icon"] forState:(UIControlStateSelected)];//垂直
    switchBt.selected = NO;
    [switchBt addTarget:self action:@selector(clickSwitch:) forControlEvents:(UIControlEventTouchUpInside)];
    [switchBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [topView addSubview:switchBt];
    
    
    NSArray *arr1 = @[[UserDefaultLocationDic valueForKey:@"speed48h"],[UserDefaultLocationDic valueForKey:@"ibrand"],[UserDefaultLocationDic valueForKey:@"xinping"]];
    CGSize size00 = [NSString sizeWithText:arr1[0] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGSize size01 = [NSString sizeWithText:arr1[1] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGSize size02 = [NSString sizeWithText:arr1[2] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGFloat  wid1 = (WIDTH - 40)/3;
    CGFloat space1 = 10;
    for (int i = 0; i < arr1.count; i++) {
//        CGSize size = [NSString sizeWithText:arr1[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + (wid1 + space1) * i, 42, wid1, 22)];
        [btn setBackgroundColor:TCUIColorFromRGB(0xf1f1f1)];
        [btn setTitle:arr1[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x0e0e0e) forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 200 + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 11;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [topView addSubview:btn];
        
        
        
        if(i == 0){
//            btn.x = 10;
            self.speedBt = btn;
            
        }else if (i == 1){
//            btn.width = size.width + 16;
//            btn.x = CGRectGetMaxX(self.speedBt.frame) + space1;
            self.brandBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }else{
//            btn.x = CGRectGetMaxX(self.brandBt.frame) + space1;
            self.neBt = btn;
        }
    }
    
    
    [self setupRefresh];
    [self setupRefresh1];
    
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    
    [self.view addSubview:self.mainTableView];
    self.mainCollectionView.hidden = YES;
    [self.view addSubview:self.mainCollectionView];
    
    
    [self.view addSubview:self.backTopBt];
    
    
    self.branPopView = [[MMBrandPopView alloc]initWithFrame:CGRectMake(0,-HEIGHT, WIDTH, HEIGHT - TabbarSafeBottomMargin) andHei:StatusBarHeight + 127 + 88];
    self.branPopView.dataArr = self.brandArr;
    self.branPopView.sureSelectBlock = ^(NSArray * _Nonnull seleArr, NSString * _Nonnull nameStr) {
               
        weakself.isShow = @"0";
        weakself.brandBt.userInteractionEnabled = YES;
        weakself.bids = [seleArr componentsJoinedByString:@","];
        
        if(seleArr.count > 0){

            weakself.brandBt.selected = YES;
            [weakself.brandBt setTitle:nameStr forState:(UIControlStateSelected)];
            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }else{
            weakself.brandBt.selected = NO;
            [weakself.brandBt setTitle:[UserDefaultLocationDic valueForKey:@"ibrand"] forState:(UIControlStateNormal)];
            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            
        }
        
        [weakself requestRefresh];
    };
    
    self.branPopView.sureHideBlock = ^(NSString * _Nonnull str) {
        weakself.brandBt.userInteractionEnabled = YES;
    };
    [self.view addSubview:self.branPopView];
//    [self.branPopView showView];
    
    self.priceScreenView = [[MMPriceFilterPopView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, HEIGHT - TabbarSafeBottomMargin) andTopHeight:StatusBarHeight + 127 + 88 andPriceArr:self.screenArr andSign:self.Sign];
    
//    self.priceScreenView = [[MMPriceFilterPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - TabbarSafeBottomMargin) andDataArr:self.screenArr andHei:StatusBarHeight + 127 + 88];
    self.priceScreenView.surePriceBlock = ^(NSString * _Nonnull min, NSString * _Nonnull max) {
        weakself.isShow1 = @"0";
        weakself.screenBt.userInteractionEnabled = YES;
        weakself.brandBt.userInteractionEnabled = YES;
        weakself.minprice = min;
        weakself.maxprice = max;
        if(!min || [min isEmpty] || min == nil){
            [weakself.screenBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        }else{
            [weakself.screenBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
        }
        [weakself requestRefresh];
    };
    self.priceScreenView.sureHideBlock = ^(NSString * _Nonnull str) {
        weakself.screenBt.userInteractionEnabled = YES;
    };
    
    [self.view addSubview:self.priceScreenView];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    self.naView = titleView;
    self.naView.titleLa.text = self.titleStr;
    
    
    
   
    
//    self.branPopView = [[MMSelectBrandPopView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 127 + 88, WIDTH, HEIGHT - StatusBarHeight - 127 - 88) andData:self.sortArr andData1:self.brandArr];
//    self.branPopView.sureSelectBlock = ^(NSArray * _Nonnull seleArr, NSString * _Nonnull nameStr) {
//        NSLog(@"%@",nameStr);
//        weakself.isShow = @"0";
//        weakself.brandBt.userInteractionEnabled = YES;
//        weakself.bids = [seleArr componentsJoinedByString:@","];
//        if(seleArr.count > 0){
//            weakself.brandBt.selected = YES;
//            [weakself.brandBt setTitle:nameStr forState:(UIControlStateSelected)];
//            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
//            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
//        }else{
//            weakself.brandBt.selected = NO;
//            [weakself.brandBt setTitle:[UserDefaultLocationDic valueForKey:@"ibrand"] forState:(UIControlStateNormal)];
//            [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
//            [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
//        }
//
//        [weakself requestRefresh];
//    };

    
    
    self.topView.classifyArr = self.sortArr;
    self.topView.selectedIndex = 0;
    NSString *pid = self.param[@"pid"];
    if(self.pid){
        for (int i = 0; i < self.sortArr.count; i++) {
            MMSortModel *model = self.sortArr[i];
            if([self.pid isEqualToString:model.ID]){
                self.topView.selectedIndex = i;
            }
        }
    }else{
        for (int i = 0; i < self.sortArr.count; i++) {
            MMSortModel *model = self.sortArr[i];
            if([pid isEqualToString:model.ID]){
                self.topView.selectedIndex = i;
            }
        }
    }
    

    [self.view addSubview:self.topView];
    self.topView.tapSortBlock = ^(NSString * _Nonnull ID) {
        weakself.pids = ID;
        [weakself requestRefresh];
    };
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - 1, WIDTH, 75)];
    topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topView];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"izonghe"],[UserDefaultLocationDic valueForKey:@"salesVol"],[UserDefaultLocationDic valueForKey:@"iprice"]];
    CGFloat wid = (WIDTH - 180)/3;
    CGFloat space = 20;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((wid + space) * i, 14, wid, 13)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
        [topView addSubview:btn];
        
        if(i == 0){
            self.compBt = btn;
        }else if (i == 1){
            self.salesBt = btn;
        }else{
            self.priceBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }
    }
    
    CGSize size3 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ifilter"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *screenBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceBt.frame) + 20, 14, size3.width + 16, 13)];
    [screenBt setImage:[UIImage imageNamed:@"screen_icon"] forState:(UIControlStateNormal)];
    [screenBt setTitle:[UserDefaultLocationDic valueForKey:@"ifilter"] forState:(UIControlStateNormal)];
    [screenBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    screenBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [screenBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [screenBt addTarget:self action:@selector(selectPrice) forControlEvents:(UIControlEventTouchUpInside)];
    [screenBt setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    [topView addSubview:screenBt];
    self.screenBt = screenBt;
    
    UIButton *switchBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 26, 14, 13, 13)];
    [switchBt setImage:[UIImage imageNamed:@"vp_icon"] forState:(UIControlStateNormal)];//水平
    [switchBt setImage:[UIImage imageNamed:@"hp_icon"] forState:(UIControlStateSelected)];//垂直
    switchBt.selected = NO;
    [switchBt addTarget:self action:@selector(clickSwitch:) forControlEvents:(UIControlEventTouchUpInside)];
    [switchBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [topView addSubview:switchBt];
    
    
    NSArray *arr1 = @[[UserDefaultLocationDic valueForKey:@"speed48h"],[UserDefaultLocationDic valueForKey:@"ibrand"],[UserDefaultLocationDic valueForKey:@"xinping"]];
    CGSize size00 = [NSString sizeWithText:arr1[0] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGSize size01 = [NSString sizeWithText:arr1[1] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGSize size02 = [NSString sizeWithText:arr1[2] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    CGFloat  wid1 = (WIDTH - 40)/3;
    CGFloat space1 = 10;
    for (int i = 0; i < arr1.count; i++) {
//        CGSize size = [NSString sizeWithText:arr1[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + (wid1 + space1) * i, 42, wid1, 22)];
        [btn setBackgroundColor:TCUIColorFromRGB(0xf1f1f1)];
        [btn setTitle:arr1[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x0e0e0e) forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 200 + i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 11;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [topView addSubview:btn];
        
        
        
        if(i == 0){
//            btn.x = 10;
            self.speedBt = btn;
            
        }else if (i == 1){
//            btn.width = size.width + 16;
//            btn.x = CGRectGetMaxX(self.speedBt.frame) + space1;
            self.brandBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }else{
//            btn.x = CGRectGetMaxX(self.brandBt.frame) + space1;
            self.neBt = btn;
        }
    }
    
    
    [self setupRefresh];
    [self setupRefresh1];
}


-(void)requestList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductPageList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    //GetVersion。GetProductMoreInfo
    NSString *pid = self.param[@"pid"];
    if(pid){
        [param setValue:pid forKey:@"pid"];
    }else if (self.pid){
        [param setValue:self.pid forKey:@"pid"];
    }else{
        [param setValue:@"0" forKey:@"pid"];
    }
    
    NSString *pids = self.param[@"subids"];
    if(pids){
        [param setValue:pids forKey:@"pids"];
    }else if (self.pids){
        [param setValue:self.pids forKey:@"pids"];
    }else{
        [param setValue:@"" forKey:@"pids"];
    }
    
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
    [param setValue:@"1" forKey:@"ishomeproduct"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            weakself.titleStr = [NSString stringWithFormat:@"%@",jsonDic[@"Name"]];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetStores{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStores"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"pricelist"];
            weakself.Sign = jsonDic[@"Sign"];
            weakself.screenArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requestTopData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductScreenNew"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *pid = self.param[@"pid"];
    if(self.pid){
        [param setValue:self.pid forKey:@"pid"];
    }else{
        [param setValue:pid forKey:@"pid"];
    }
//    if(pid){
//        [param setValue:pid forKey:@"pid"];
//    }else if (self.pid){
//        [param setValue:self.pid forKey:@"pid"];
//    }else{
//        [param setValue:@"0" forKey:@"pid"];
//    }
    
    
   
    [param setValue:@"" forKey:@"keyword"];
    [param setValue:@"" forKey:@"sids"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *brandArr = [MMBrandModel mj_objectArrayWithKeyValuesArray:jsonDic[@"brand"]];
            weakself.brandArr = [NSMutableArray arrayWithArray:brandArr];
            NSArray *sortArr = [MMSortModel mj_objectArrayWithKeyValuesArray:jsonDic[@"sub"]];
            weakself.sortArr = [NSMutableArray arrayWithArray:sortArr];
//            NSDictionary *dic = @{@"ID":@"",@"Name":@"全部"};
//            MMSortModel *model = [MMSortModel mj_objectWithKeyValues:dic];
//            [weakself.sortArr insertObject:model atIndex:0];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        sender.selected = !sender.selected;
        self.otype = @"0";
        self.salesBt.selected = NO;
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
    }else if (sender.tag == 101){
        self.compBt.selected = NO;
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        if(sender.selected == NO){
            sender.selected = YES;
            self.otype = @"1";
        }
    }else if (sender.tag == 102){
        self.compBt.selected = NO;
        self.salesBt.selected = NO;
        [self.priceBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
        if([self.otype isEqualToString:@"0"] || [self.otype isEqualToString:@"1"] || [self.otype isEqualToString:@"3"]){
            self.otype = @"4";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        }else if ([self.otype isEqualToString:@"4"]){
            self.otype = @"3";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
        }
    }
    [self requestRefresh];
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 200){
        sender.selected = !sender.selected;
        if(sender.selected){
            self.isrec = @"1";
        }else{
            self.isrec = @"0";
        }
        [self requestRefresh];
        
//        if([self.isShow isEqualToString:@"0"]){
//            self.branPopView.type = @"0";
//            [[UIApplication sharedApplication].keyWindow addSubview:self.branPopView];
//            [self.branPopView showView];
//            self.isShow = @"1";
//        }else{
//            self.branPopView.type = @"0";
//        }
    }else if (sender.tag == 201){
        
        
        
            if([self.isShow1 isEqualToString:@"1"]){
                self.screenBt.userInteractionEnabled = YES;
                [self.priceScreenView hideView];
                self.isShow1 = @"0";
            }
//            self.branPopView.type = @"1";
//            [[UIApplication sharedApplication].delegate.window addSubview:self.branPopView];
            self.brandBt.userInteractionEnabled = NO;
            [self.branPopView showView];
            self.isShow = @"1";
       
        
    }else{
        sender.selected = !sender.selected;
        if(sender.selected){
            self.isNew = @"1";
            [sender setBackgroundColor:TCUIColorFromRGB(0xffeae7)];
            sender.layer.borderColor = redColor2.CGColor;
            sender.layer.borderWidth = 0.5;
        }else{
            self.isNew = @"0";
            [sender setBackgroundColor:TCUIColorFromRGB(0xf1f1f1)];
            sender.layer.borderColor = redColor2.CGColor;
            sender.layer.borderWidth = 0;
        }
        [self requestRefresh];
        
    }
}

-(void)requestRefresh{
    [self.dataArr removeAllObjects];
    [self.mainTableView reloadData];
    [self.mainCollectionView reloadData];
    KweakSelf(self);
    self.page = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductPageList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    //GetVersion。GetProductMoreInfo
    if(self.bids){
        [param setValue:self.bids forKey:@"bids"];
    }
    if(self.pids){
        [param setValue:self.pids forKey:@"pids"];
    }
    if(self.minprice){
        [param setValue:self.minprice forKey:@"minprice"];
    }
    if(self.maxprice){
        [param setValue:self.maxprice forKey:@"maxprice"];
    }
    
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    NSString *pid = self.param[@"pid"];
    if(pid){
        [param setValue:pid forKey:@"pid"];
    }else if (self.pid){
        [param setValue:self.pid forKey:@"pid"];
    }else{
        [param setValue:@"0" forKey:@"pid"];
    }
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
    [param setValue:@"1" forKey:@"ishomeproduct"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
            [weakself.mainCollectionView reloadData];
            [weakself.mainTableView.mj_footer endRefreshing];
            [weakself.mainCollectionView.mj_footer endRefreshing];
            
//            [weakself.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
//            [weakself.mainCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 上拉加载
-(void)setupRefresh{
    KweakSelf(self);
    //上拉 加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            [self requestLoadMoreGoodsDataPage:weakself.page];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainCollectionView.mj_footer = footer;

}

-(void)setupRefresh1{
    KweakSelf(self);
    //上拉 加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            [self requestLoadMoreGoodsDataPage:weakself.page];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
            weakself.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainTableView.mj_footer = footer;

}

-(void)requestLoadMoreGoodsDataPage:(NSInteger )page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductPageList"];
  
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.bids){
        [param setValue:self.bids forKey:@"bids"];
    }
    if(self.pids){
        [param setValue:self.pids forKey:@"pids"];
    }
    if(self.minprice){
        [param setValue:self.minprice forKey:@"minprice"];
    }
    if(self.maxprice){
        [param setValue:self.maxprice forKey:@"maxprice"];
    }
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    NSString *pid = self.param[@"pid"];
    if(pid){
        [param setValue:pid forKey:@"pid"];
    }else if (self.pid){
        [param setValue:self.pid forKey:@"pid"];
    }else{
        [param setValue:@"0" forKey:@"pid"];
    }
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
    [param setValue:@"1" forKey:@"ishomeproduct"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.dataArr addObjectsFromArray:arr];
                
                [weakself.mainTableView reloadData];
                [weakself.mainCollectionView reloadData];
                [weakself.mainCollectionView.mj_footer endRefreshing];
                [weakself.mainTableView.mj_footer endRefreshing];
            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -- uitableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    
    if([self.lang isEqualToString:@"1"]){
        MMGoodsListEnglishCell*cell = [[MMGoodsListEnglishCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count > 0) {
            cell.model = self.dataArr[indexPath.row];
        }
        cell.clickShopCar = ^(NSString * _Nonnull goodsID) {
            weakself.goodsId = goodsID;
            [weakself GetProductBuyTest:goodsID];
        };
        
        return cell;
    }else{
        MMGoodsListCell*cell = [[MMGoodsListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count > 0) {
            cell.model = self.dataArr[indexPath.row];
        }
        cell.clickShopCar = ^(NSString * _Nonnull goodsID) {
            weakself.goodsId = goodsID;
            [weakself GetProductBuyTest:goodsID];
        };
        
        return cell;
    }
    
}

#pragma mark -- uicollectionviewdelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
        weakself.goodsId = indexStr;
        [weakself GetProductBuyTest:indexStr];
    };
    
    return cell;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
    MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.row];
    MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- 筛选价格 切换样式
-(void)selectPrice{
    if([self.isShow isEqualToString:@"1"]){
        self.brandBt.userInteractionEnabled = YES;
        [self.branPopView hideView];
        self.isShow = @"0";
    }
    self.screenBt.userInteractionEnabled = NO;
    self.isShow1 = @"1";
//    [[UIApplication sharedApplication].delegate.window  addSubview:self.priceScreenView];
    [self.priceScreenView showView];
   
    
}

-(void)clickSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.mainTableView.hidden = YES;
        self.mainCollectionView.hidden = NO;
    }else{
        self.mainTableView.hidden = NO;
        self.mainCollectionView.hidden = YES;
    }
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

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- uiscrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.mainCollectionView.contentOffset.y >= 300 || self.mainTableView.contentOffset.y >= 300){
        self.backTopBt.hidden = NO;
    }else{
        self.backTopBt.hidden = YES;
    }
}

-(void)backTop{
    if(self.mainTableView.hidden == NO){
        [UIView animateWithDuration:0.25 animations:^{
            self.mainTableView.contentOffset = CGPointMake(0, 0);
        }];
    }else if (self.mainCollectionView.hidden == NO){
        [UIView animateWithDuration:0.25 animations:^{
            self.mainCollectionView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
//    [self.branPopView hideView];
    [TalkingDataSDK onPageEnd:@"商品列表页面"];
}
@end
