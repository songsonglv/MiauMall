//
//  MMStrollVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMStrollVC.h"
#import "MMClauseListModel.h"
#import "MMPriceScreenView.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

#import "MMStrollGoodsCell.h"
#import "XRWaterfallLayout.h"
#import "MMPriceFilterPopView.h"

@interface MMStrollVC ()<UITextFieldDelegate,HGCategoryViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XRWaterfallLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *heiArr;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UITextField *searchFeild;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *topArr;//顶部分类数组
@property (nonatomic, strong) NSMutableArray *screenArr;//价格筛选数组
@property (nonatomic, strong) NSMutableArray *dataArr;//商品数组
@property (nonatomic, strong) NSString *StoreID;//顶部分类的ID
@property (nonatomic, strong) NSString *keyword;//搜索关键字
@property (nonatomic, assign) NSInteger page;//分页 当前页 每次刷新数据后变成1
@property (nonatomic, assign) NSInteger endPage;//总页数 每次顶部数据变化时更新 搜索结束后也更新
@property (nonatomic, strong) NSString *otype;// 0 综合 1销量 3价格降序 4 价格升序
@property (nonatomic, strong) NSString *minPrice;
@property (nonatomic, strong) NSString *maxPrice;
@property (nonatomic, strong) NSString *isrec;//是否48h

@property (nonatomic, strong) UIButton *compBt;//综合
@property (nonatomic, strong) UIButton *salesBt;//销量
@property (nonatomic, strong) UIButton *priceBt;//价格

@property (nonatomic, strong) UIButton *screenBt;//筛选 弹出弹窗
@property (nonatomic, strong) UISwitch *switchBt;//切换列表样式按钮
@property (nonatomic, strong) UIButton *speedBt;

@property (nonatomic, strong) NSString *isShow;
@property (nonatomic, strong) NSString *isFirst;
@property (nonatomic, strong) MMPriceFilterPopView *priceScreenView;//价格筛选弹窗

@property (nonatomic, strong) HGCategoryView *categaryView;//顶部view

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

@property (nonatomic, strong) UIButton *selectBt;

@property (nonatomic, strong) UIButton *backTopBt;

@property (nonatomic, strong) NSString *sign;
@end

@implementation MMStrollVC

-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        XRWaterfallLayout *layout = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        layout.delegate = self;
        
    //设置垂直间的最小间距
//    layout.minimumLineSpacing = 10;
//    //设置水平间的最小间距
//    layout.minimumInteritemSpacing = 10;
//
//    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
////    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 130, WIDTH, HEIGHT - 120  - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMStrollGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _mainCollectionView;
}

-(NSMutableArray *)heiArr{
    if(!_heiArr){
        _heiArr = [NSMutableArray array];
    }
    return _heiArr;
}

-(NSMutableArray *)topArr{
    if(!_topArr){
        _topArr = [NSMutableArray array];
    }
    return _topArr;
}

-(NSMutableArray *)screenArr{
    if(!_screenArr){
        _screenArr = [NSMutableArray array];
    }
    return _screenArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


-(HGCategoryView *)categaryView{
    NSMutableArray *arr = [NSMutableArray array];
    for (MMClauseListModel *model in self.topArr) {
        [arr addObject:model.Name];
    }
    if(!_categaryView){
        _categaryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 42, WIDTH, 38)];
        _categaryView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _categaryView.delegate = self;
        _categaryView.titles = arr;
        _categaryView.selectedIndex = 0;
        _categaryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _categaryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
        _categaryView.topBorder.hidden = YES;
        _categaryView.bottomBorder.hidden = YES;
        _categaryView.vernierHeight = 2;
        _categaryView.vernierWidth = 20;
        _categaryView.vernier.backgroundColor = redColor2;
        _categaryView.titleNormalColor = TCUIColorFromRGB(0x474747);
        _categaryView.titleSelectedColor = TCUIColorFromRGB(0x474747);
    }
    return _categaryView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"逛逛页面"];
    
    NSString *noReadMessage = [self.userDefaults valueForKey:@"NoReadMsg"];
    if([noReadMessage isEqualToString:@"0"]){
        self.minetabBarItem.badgeValue = nil;
    }else{
        self.minetabBarItem.badgeValue = noReadMessage;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.page = 1;
    self.isrec = @"0";
    self.isShow = @"0";
    self.isFirst = @"0";
    self.otype = @"0";
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self GetStores];
    // Do any additional setup after loading the view.
}

-(void)GetStores{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStores"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *priceArr = jsonDic[@"pricelist"];
            weakself.sign = jsonDic[@"Sign"];
            weakself.screenArr = [NSMutableArray arrayWithArray:priceArr];
            NSArray *arr = [MMClauseListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            MMClauseListModel *model = arr[0];
            weakself.StoreID = model.ID;
            weakself.topArr = [NSMutableArray arrayWithArray:arr];
            [weakself GetStoreRecommend];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//刚进来时请求底部列表
-(void)GetStoreRecommend{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"isrec":@"0",@"curr":@"1",@"limit":@"10"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [param setValue:self.StoreID forKey:@"StoreID"];
    [param setValue:self.otype forKey:@"otype"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endPage = [endpage integerValue];
            
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//每次刷新的请求底部列表 page变为1 endpage重置
-(void)refreshData{
    KweakSelf(self);
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"isrec":self.isrec,@"curr":@"1",@"limit":@"10"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [param setValue:self.StoreID forKey:@"StoreID"];
    [param setValue:self.otype forKey:@"otype"];
    if(self.keyword){
        [param setValue:self.keyword forKey:@"keyword"];
    }
    if(self.minPrice){
        [param setValue:self.minPrice forKey:@"minprice"];
    }
    if(self.maxPrice){
        [param setValue:self.maxPrice forKey:@"maxprice"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr addObjectsFromArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endPage = [endpage integerValue];
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView setContentOffset:CGPointMake(0, 0)];
            
            [weakself setupRefresh];
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
        if(weakself.page <= weakself.endPage){
            [self requestLoadMoreGoodsDataPage:weakself.page];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainCollectionView.mj_footer = footer;

}

-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreRecommend"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"isrec":self.isrec,@"curr":pagestr,@"limit":@"10"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [param setValue:self.StoreID forKey:@"StoreID"];
    [param setValue:self.otype forKey:@"otype"];
    if(self.keyword){
        [param setValue:self.keyword forKey:@"keyword"];
    }
    if(self.minPrice){
        [param setValue:self.minPrice forKey:@"minprice"];
    }
    if(self.maxPrice){
        [param setValue:self.maxPrice forKey:@"maxprice"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
//            [weakself.dataArr removeAllObjects];
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr addObjectsFromArray:arr];
            
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    
    [self.view addSubview:self.mainCollectionView];
    
    [self.view addSubview:self.backTopBt];
    
    
    self.priceScreenView = [[MMPriceFilterPopView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, HEIGHT) andTopHeight:StatusBarHeight + 133 andPriceArr:self.screenArr andSign:self.sign];
//    self.priceScreenView = [[MMPriceScreenView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 133, WIDTH, HEIGHT - StatusBarHeight - 133) andDataArr:self.screenArr andHei:StatusBarHeight + 127];
    self.priceScreenView.surePriceBlock = ^(NSString * _Nonnull min, NSString * _Nonnull max) {
        weakself.screenBt.userInteractionEnabled = YES;
        weakself.minPrice = min;
        weakself.maxPrice = max;
        if(!min || [min isEmpty] || min == nil){
            [weakself.screenBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        }else{
            [weakself.screenBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
        }
        [weakself refreshData];
    };
    self.priceScreenView.sureHideBlock = ^(NSString * _Nonnull str) {
        weakself.screenBt.userInteractionEnabled = YES;
    };
    [self.view addSubview:self.priceScreenView];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 133)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(12, StatusBarHeight + 8, 24, 24)];
    [returnBt setImage:[UIImage imageNamed:@"return_black"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(38, StatusBarHeight + 5, WIDTH - 150, 30)];
    searchView.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 15;
    [self.view addSubview:searchView];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
    searchIcon.image = [UIImage imageNamed:@"order_search_icon"];
    [searchView addSubview:searchIcon];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(28, 6, WIDTH - 160, 18)];
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"isearch"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x56595c)}];
    field.delegate = self;
    field.returnKeyType = UIReturnKeySearch;
    field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    field.textColor = TCUIColorFromRGB(0x585c5f);
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.textAlignment = NSTextAlignmentLeft;
    [searchView addSubview:field];
    
    UIImageView *lightningIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchView.frame) + 14, StatusBarHeight + 12, 10, 17)];
    lightningIcon.image = [UIImage imageNamed:@"lightning"];
    [self.view addSubview:lightningIcon];
    
    UILabel *lab1 = [UILabel publicLab:@"48h" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 100;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-57);
            make.top.mas_equalTo(StatusBarHeight + 13);
            make.height.mas_equalTo(15);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickSwithc:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:20];
    btn.selected = NO;
    [self.view addSubview:btn];
    self.speedBt = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-57);
            make.top.mas_equalTo(StatusBarHeight + 13);
            make.height.mas_equalTo(15);
    }];
    
    // 创建UISwitch实例
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 55, StatusBarHeight + 6, 36, 18)];
    // 设置UISwitch的初始状态
    mySwitch.on = NO;
   
//    mySwitch.onImage = [UIImage imageNamed:@"switch_on"];
    mySwitch.offImage = [UIImage imageNamed:@"switch_off"];
    mySwitch.onTintColor = redColor2;
    mySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);

    // 添加一个值改变操作
    [mySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 添加到视图中
    [self.view addSubview:mySwitch];
    self.switchBt = mySwitch;

    
//    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50, StatusBarHeight + 13, 34, 15)];
//    [btn1 setImage:[UIImage imageNamed:@"switch_on"] forState:(UIControlStateSelected)];
//    [btn1 setImage:[UIImage imageNamed:@"switch_off"] forState:(UIControlStateNormal)];
//    [btn1 addTarget:self action:@selector(clickSwithc:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:btn1];
    
    [self.view addSubview:self.categaryView];
    //salesVol
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"izonghe"],[UserDefaultLocationDic valueForKey:@"salesVol"],[UserDefaultLocationDic valueForKey:@"iprice"]];
    CGFloat wid = 80;
    CGFloat space = 30;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.categaryView.frame) + 3, WIDTH, 44)];
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 43.5, WIDTH - 16, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xececec);
    [view addSubview:line];
    
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((wid + space) * i, 0, wid, 40)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        if(i == 0){
            self.compBt = btn;
            btn.selected = YES;
        }else if (i == 1){
            self.salesBt = btn;
        }else{
            self.priceBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }
    }
    
//    CGSize size
    CGSize size3 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ifilter"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *screenBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceBt.frame) + 30, 14, size3.width + 16, 13)];
    [screenBt setImage:[UIImage imageNamed:@"screen_icon"] forState:(UIControlStateNormal)];
    [screenBt setTitle:[UserDefaultLocationDic valueForKey:@"ifilter"] forState:(UIControlStateNormal)];
    [screenBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    screenBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [screenBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [screenBt addTarget:self action:@selector(selectPrice) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:screenBt];
    self.screenBt = screenBt;
    
    
    [self setupRefresh];
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
    MMStrollGoodsCell *cell =
    (MMStrollGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
        weakself.goodsId = indexStr;
        [weakself GetProductBuyTest:indexStr];
    };
    
    return cell;
}



//设置cell大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
////    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
//   
//        MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
//        CGFloat hei = (WIDTH - 30)/2 + 84;
//        CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@  %@",model.ProductSign,model.Name] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake((WIDTH - 30)/2 - 14,MAXFLOAT)];
//        hei += size.height;
//        if(model.ShortName.length > 0){
//            hei += 25;
//        }
//        
//        
//    
//    float hei1 = (WIDTH - 30)/2 + 153;
//    return CGSizeMake((WIDTH - 30)/2, hei);
//    
//    
//
//}

//XRWaterLayoutDelegate
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
    CGFloat hei = (WIDTH - 30)/2 + 84;
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@        %@",model.ProductSign,model.Name] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake((WIDTH - 30)/2 - 14,MAXFLOAT)];
    hei += size.height;
    if(model.ShortName.length > 0){
        hei += 25;
    }
    
    return hei;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
    [self RouteJump:model.Url];
}


#pragma mark -- uitextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.keyword = textField.text;
    [self refreshData];
    return [textField resignFirstResponder];;
}


#pragma mark -- categarydelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    MMClauseListModel *model = self.topArr[index];
    self.StoreID = model.ID;
    [self refreshData];
}

#pragma mark -- uiscrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.mainCollectionView.contentOffset.y >= 300){
        self.backTopBt.hidden = NO;
    }else{
        self.backTopBt.hidden = YES;
    }
}

-(void)backTop{
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0)];
    }];
    
}


-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        sender.selected = YES;
        self.otype = @"0";
        self.salesBt.selected = NO;
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
    }else if (sender.tag == 101){
        sender.selected = YES;
        self.otype = @"1";
        self.compBt.selected = NO;
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
            
        
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
    [self refreshData];
}

// 目标方法
- (void)switchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        // 执行开启操作
        self.isrec = @"1";
        self.speedBt.selected = YES;
    } else {
        // 执行关闭操作
        self.isrec = @"0";
        self.speedBt.selected = NO;
    }
    
    [self refreshData];
}

-(void)clickSwithc:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.switchBt.on = !self.switchBt.on;
    if(sender.selected){
        self.isrec = @"1";
    }else{
        self.isrec = @"0";
    }
    [self refreshData];
}

#pragma mark -- 筛选价格
-(void)selectPrice{
//        [[UIApplication sharedApplication].keyWindow addSubview:self.priceScreenView];
        [self.priceScreenView showView];
        self.isShow = @"1";
        self.screenBt.userInteractionEnabled = NO;
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

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}
  

-(void)clickReturn{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"逛逛页面"];
}
@end
