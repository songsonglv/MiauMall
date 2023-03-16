//
//  MMShopCarVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMShopCarVC.h"
#import "MMShopCarModel.h"
#import "MMShopCarGoodsModel.h"
#import "MMMyCollectionViewController.h"
#import "MMFootOrCollectGoodsModel.h"
#import "MMShopCartCollectionCell.h"
#import "MMFootCollectionCell.h"
#import "MMShopCarBottomView.h"
#import "MMShopCatBottomMoneyView.h"
#import "MMShopCarEditView.h"
#import "MMConfirmOrderViewController.h"
#import "MMDiscountDetailPopView.h"
#import "MMCollageListViewController.h"
#import "MMFindSimilaryViewController.h"

@interface MMShopCarVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMShopCarModel *model;
@property (nonatomic, strong) NSMutableArray *allArr;//总的数组
@property (nonatomic, strong) NSMutableArray *arr1;//普通商品分组
@property (nonatomic, strong) NSMutableArray *arr2;//任选商品分组
@property (nonatomic, strong) NSMutableArray *footArr;// 足迹列表
@property (nonatomic, strong) UITabBarItem *cartabBarItem;
@property (nonatomic, strong) UILabel *numLa;//购物车商品数量
@property (nonatomic, strong) NSMutableArray *seleArr;//选中的数组
@property (nonatomic, assign) CGFloat hei;//购物车商品的总高度
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, assign) NSInteger endPage;//总页码
@property (nonatomic, assign) NSInteger page;//当前页码
@property (nonatomic, strong) NSMutableArray *dataArr;//推荐商品数组

@property (nonatomic, assign) CGFloat picHei;

//一个默认显示 一个点击编辑时显示 互斥
@property (nonatomic, strong) MMShopCarBottomView *bottomView;
@property (nonatomic, strong) MMShopCatBottomMoneyView *moneyView;
@property (nonatomic, strong) MMShopCarEditView *editView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) MMDiscountDetailPopView *popView;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

@property (nonatomic, strong) UIButton *backTopBt;

@end

@implementation MMShopCarVC

-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 200 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}


-(NSMutableArray *)picArr{
    if(!_picArr){
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(NSMutableArray *)arr1{
    if(!_arr1){
        _arr1 = [NSMutableArray array];
    }
    return _arr1;
}

-(NSMutableArray *)arr2{
    if(!_arr2){
        _arr2 = [NSMutableArray array];
    }
    return _arr2;
}

-(NSMutableArray *)footArr{
    if(!_footArr){
        _footArr = [NSMutableArray array];
    }
    return _footArr;
}


-(MMShopCarEditView *)editView{
    KweakSelf(self);
    if(!_editView){
        _editView = [[MMShopCarEditView alloc]initWithFrame:CGRectMake(0, HEIGHT - 82 - 54, WIDTH, 54)];
        _editView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _editView.model = self.model;
        _editView.tapSeleBlock = ^(NSString * _Nonnull str) {
            [weakself allSelect:str];
        };
        
        _editView.tapCollBlock = ^(NSString * _Nonnull str) {
            [weakself BCollection];
        };
        
        _editView.tapDeleBlock = ^(NSString * _Nonnull str) {
            [weakself CartDel];
        };
    }
    return _editView;
}

-(MMShopCarBottomView *)bottomView{
    KweakSelf(self);
    if(!_bottomView){
        _bottomView = [[MMShopCarBottomView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 36)];
        _bottomView.model = self.model;
        _bottomView.goListBlock = ^(NSString * _Nonnull str) {
            MMCollageListViewController *collageListVC = [[MMCollageListViewController alloc]init];
            [weakself.navigationController pushViewController:collageListVC animated:YES];
        };
        [UIView animateWithDuration:0.25 animations:^{
            weakself.bottomView.frame = CGRectMake(0, 0, WIDTH, weakself.bottomView.hei);
            weakself.bgView.frame = CGRectMake(0, HEIGHT - weakself.bottomView.height - 142, WIDTH, weakself.bottomView.hei + 142);
            weakself.moneyView.y = weakself.bottomView.hei;
            weakself.mainCollectionView.height = HEIGHT - weakself.bottomView.hei - 128 - 100;
        }];
    }
    return _bottomView;
}

-(MMShopCatBottomMoneyView *)moneyView{
    if(!_moneyView){
        KweakSelf(self);
        _moneyView = [[MMShopCatBottomMoneyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), WIDTH, 64)];
        _moneyView.model = self.model;
        _moneyView.tapPayBlock = ^(NSString * _Nonnull str) {
            [weakself goPay];
        };
        _moneyView.tapAllBlock = ^(NSString * _Nonnull str) {
            [weakself allSelect:str];
        };
        
        _moneyView.tapDetailBlock = ^(NSString * _Nonnull str) {
            [weakself discoundViewShow];
        };
    }
    return _moneyView;
}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 100 - 64, WIDTH, 100)];
        _bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [_bgView addSubview:self.bottomView];
        [_bgView addSubview:self.moneyView];
    }
    return _bgView;
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
        // layout.headerReferenceSize = CGSizeMake(0,706 + 55);
        layout.sectionInset = UIEdgeInsetsMake(0,10,0, 10);//item对象上下左右的距离
        //    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - 100 + TabbarSafeBottomMargin) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = UIColor.clearColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
                forCellWithReuseIdentifier:@"cell"];
        [_mainCollectionView registerClass:[MMShopCartCollectionCell class]
                forCellWithReuseIdentifier:@"topcell"];
        [_mainCollectionView registerClass:[MMFootCollectionCell class] forCellWithReuseIdentifier:@"Foot"];
        // [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    }
    return _mainCollectionView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"购物车页面"];
    if(self.mainCollectionView){
        [self refresh];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.page = 1;
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 54)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"购物车(%@)",@"0"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 200;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topV addSubview:lab];
    self.numLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(StatusBarHeight + 19);
        make.height.mas_equalTo(16);
    }];
    
    UIButton *collectionBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 38, StatusBarHeight + 18, 18, 18)];
    [collectionBt setImage:[UIImage imageNamed:@"star_no"] forState:(UIControlStateNormal)];
    [collectionBt addTarget:self action:@selector(clickCollec) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:collectionBt];
    
    UIButton *editBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 85, StatusBarHeight + 20, 35, 14)];
    [editBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    editBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBt setTitle:@"编辑" forState:(UIControlStateNormal)];
    [editBt setTitle:@"完成" forState:(UIControlStateSelected)];
    [editBt addTarget:self action:@selector(clickEdit:) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:editBt];
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    self.popView = [[MMDiscountDetailPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.clickPayBlock = ^(NSString * _Nonnull str) {
        [weakself.popView hideView];
        [weakself goPay];
    };
    
    [self loadHttpRequest];
    // Do any additional setup after loading the view.
}

-(void)loadHttpRequest{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求购物车商品数据
        [weakself requestData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求足迹列表
        [weakself GetBrowseRecord];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求banner数组
        [weakself GetRotationPictures];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求底部推荐商品数组
        [weakself GetCartRecommend];
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

-(void)GetCartRecommend{
    KweakSelf(self);
    NSDictionary *param1 = @{@"IsMinApp":@"0",@"ItemID":@"0",@"otype":@"0",@"StoreID":@"0",@"limit":@"20",@"pid":@"0",@"brand":@"0",@"lang":self.lang,@"cry":self.cry,@"curr":@"1"};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCartRecommend"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endPage = [endpage integerValue];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetBrowseRecord{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBrowseRecord"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMFootOrCollectGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.footArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
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
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"1" forKey:@"id"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.picArr = [NSMutableArray arrayWithArray:arr];
            MMRotationPicModel *model = arr[0];
            dispatch_queue_t q = dispatch_queue_create(@"hei", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
                weakself.picHei = WIDTH/(size1.width/size1.height);
            });
            
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartList1"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            
            NSArray *arr = jsonDic[@"key"][@"newitem"];
            weakself.allArr = [NSMutableArray arrayWithArray:arr];
            weakself.numLa.text = [NSString stringWithFormat:@"购物车(%@)",weakself.model.num];
            NSMutableArray *allNumArr = [NSMutableArray array];
            
            for (NSArray *arr1 in arr) {
                [allNumArr addObjectsFromArray:arr1];
            }
            NSArray *modelArr = [MMShopCarGoodsModel mj_objectArrayWithKeyValuesArray:allNumArr];
            for (MMShopCarGoodsModel *model in modelArr) {
                if([model.buy isEqualToString:@"1"]){
                    [self.seleArr addObject:model];
                }
            }
            CGFloat hei = 0;
            hei = allNumArr.count * 160;
            hei += 44 * arr.count;
           
            weakself.hei = hei;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)setUI{
    [ZTProgressHUD hide];
    if(self.allArr.count > 0){
        self.hei = self.picHei + 20 + self.hei;
    }else{
        self.hei = self.picHei + 20 + WIDTH;
    }
    
    [self.view addSubview:self.mainCollectionView];
    [self.view addSubview:self.bgView];
    self.editView.hidden = YES;
    [self.view addSubview:self.editView];
    [self refresh];
    [self setupRefresh];
    
    [self.view addSubview:self.backTopBt];
}

-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
    NSDictionary *param1 = @{@"IsMinApp":@"0",@"ItemID":@"0",@"otype":@"0",@"StoreID":@"0",@"limit":@"20",@"pid":@"0",@"brand":@"0",@"lang":self.lang,@"cry":self.cry,@"curr":pagestr};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCartRecommend"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr addObjectsFromArray:arr];
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
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
    self.mainCollectionView.mj_header = header;
    [header beginRefreshing];
    
    //上拉 加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endPage){
            [self requestLoadMoreGoodsDataPage:weakself.page];
        }else{
            [ZTProgressHUD showMessage:@"没有更多商品"];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    self.mainCollectionView.mj_footer = footer;
}


#pragma mark -- uicollectionViewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(self.footArr.count > 0){
        return 3;
    }
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.footArr.count > 0){
        if(section == 0){
            return 1;
        }else if (section == 1){
            return 1;
        }else{
            return self.dataArr.count;
        }
    }else{
        if(section == 0){
            return 1;
        }else{
            return self.dataArr.count;
        }
    }
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    
    if(self.footArr.count > 0){
        if(indexPath.section == 0){
            MMShopCartCollectionCell *cell =
            (MMShopCartCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.dataArr = self.allArr;
            cell.hei = self.hei;
            cell.freefreightStrHead = self.model.freefreightStrHead;
            cell.picArr1 = self.picArr;
            cell.picHei = self.picHei;
            cell.tapHomeBlock = ^(NSString * _Nonnull str) {
                [weakself goHome];
            };
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            cell.tapAddBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
                [weakself CartPlus:model];
            };
            cell.tapSubBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
                [weakself CartLess:model];
            };
            cell.tapSeleBlock = ^(MMShopCarGoodsModel * _Nonnull model, NSString * _Nonnull isBuy) {
                [weakself CartSelect:model andIsbuy:isBuy];
                if([isBuy isEqualToString:@"1"]){
                    [self.seleArr addObject:model];
                }else{
                    [self.seleArr removeObject:model];
                }
            };
            cell.tapAttiBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                weakself.goodsId = model.ID;
                [weakself GetProductBuyTest:model.ID];
            };
            cell.tapCollecBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                [weakself BCollection];
            };
            cell.tapSimilarBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                [weakself goFindSimilaryandModel:model];
            };
            cell.tapDeleteBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                [weakself clickShow:model];
            };
            cell.tapMoreBlock = ^(NSString * _Nonnull str) {
                [weakself RouteJump:str];
            };
            cell.tapPicblock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            
            return cell;
        }else if (indexPath.section == 1){
            //                MMFootCollectionCell *cell =
            //                (MMFootCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Foot" forIndexPath:indexPath];
            MMFootCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Foot" forIndexPath:indexPath];
            cell.dataArr = self.footArr;
            cell.tapMoreBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            return cell;
        }else{
            MMHomeShopGoodsCell *cell =
            (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            cell.model = self.dataArr[indexPath.item];
            cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
                weakself.goodsId = indexStr;
                [weakself GetProductBuyTest:indexStr];
            };
            return cell;
        }
    }else{
        if(indexPath.section == 0){
            MMShopCartCollectionCell *cell =
            (MMShopCartCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.dataArr = self.allArr;
            cell.hei = self.hei;
            cell.picArr1 = self.picArr;
            cell.picHei = self.picHei;
            
            cell.tapHomeBlock = ^(NSString * _Nonnull str) {
                [weakself goHome];
            };
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            
            cell.tapAddBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
                [weakself CartPlus:model];
            };
            cell.tapSubBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
                [weakself CartLess:model];
            };
            cell.tapSeleBlock = ^(MMShopCarGoodsModel * _Nonnull model, NSString * _Nonnull isBuy) {
                [weakself CartSelect:model andIsbuy:isBuy];
            };
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            cell.tapAttiBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                weakself.goodsId = model.ID;
                [weakself GetProductBuyTest:model.ID];
            };
            cell.tapDeleteBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
                [weakself clickShow:model];
            };
            return cell;
        }else{
            MMHomeShopGoodsCell *cell =
            (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            cell.model = self.dataArr[indexPath.item];
            cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
                weakself.goodsId = indexStr;
                [weakself GetProductBuyTest:indexStr];
            };
            return cell;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.footArr.count > 0){
        if(indexPath.section == 2){
            MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
            [self RouteJump:model.Url];
        }
    }else{
        if(indexPath.section == 1){
            MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.item];
            [self RouteJump:model.Url];
        }
    }
}

//设置区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

//设置区尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //        if(self.footArr.count > 0){
    //            if(section == 0 || section == 1){
    //                return CGSizeMake(WIDTH, 10);
    //            }else{
    //                return CGSizeZero;
    //            }
    //        }else{
    //            if(section == 0){
    //                return CGSizeMake(WIDTH, 10);
    //            }else{
    //                return CGSizeZero;
    //            }
    //        }
    return CGSizeZero;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.footArr.count > 0){
        if(indexPath.section == 0){
            return CGSizeMake(WIDTH, self.hei);
        }else if (indexPath.section == 1){
            return CGSizeMake(WIDTH, 254);
        }else{
            return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
        }
    }else{
        if(indexPath.section == 0){
            return CGSizeMake(WIDTH, self.hei);
        }else{
            return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
        }
    }
}

-(void)clickEdit:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.editView.hidden = NO;
        self.bgView.hidden = YES;
        self.mainCollectionView.height = HEIGHT - self.editView.height - StatusBarHeight - 130;
    }else{
        self.bgView.hidden = NO;
        self.editView.hidden = YES;
        self.mainCollectionView.height = HEIGHT - self.bgView.height - StatusBarHeight - 54;
    }
}

-(void)clickCollec{
    MMMyCollectionViewController *collectionVC = [[MMMyCollectionViewController alloc]init];
    [self.navigationController pushViewController:collectionVC animated:YES];
}

-(void)discoundViewShow{
    self.popView.model = self.model;
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

#pragma mark -- 点击事件
-(void)goFindSimilaryandModel:(MMShopCarGoodsModel *)model1{
    MMFindSimilaryViewController *findVC = [[MMFindSimilaryViewController alloc]init];
    findVC.model = model1;
    [self.navigationController pushViewController:findVC animated:YES];
}


-(void)clickShow:(MMShopCarGoodsModel *)model{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定删除该商品吗？"
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
        [weakself CartLess:model];
    }]];
    
    
    
    [self presentViewController:alert animated:true completion:nil];
}

//全选
-(void)allSelect:(NSString *)sele{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartSelect"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"back":@"1",@"tempcart":self.tempcart,@"id":@"0",@"attid":@"0",@"isbuy":sele};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    [self requestUrl:url andParam:param];
}

//➖和删除一样 当num为1时就是删除
-(void)CartLess:(MMShopCarGoodsModel *)model{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartLess"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"id":model.ID,@"attid":model.attid,@"back":@"1"};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
}

//删除
-(void)CartDel{
    if(self.seleArr.count == 0){
        [ZTProgressHUD showMessage:@"请选择需要操作的商品!"];
    }else{
        NSMutableArray *idArr = [NSMutableArray array];
        NSMutableArray *attidArr = [NSMutableArray array];
        for (MMShopCarGoodsModel *model in self.seleArr) {
            [idArr addObject:model.ID];
            [attidArr addObject:model.attid];
        }
        
        NSString *ids = [idArr componentsJoinedByString:@","];
        NSString *attids = [attidArr componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartDel"];
        NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"id":ids,@"attid":attids,@"back":@"1"};
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"memberToken"];
        }
        [self requestUrl:url andParam:param];
    }
}
//单个收藏
-(void)Collection:(MMShopCarGoodsModel *)model{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"Collection"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"id":model.ID,@"isTrue":@"1"};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *msg= [NSString stringWithFormat:@"%@",jsonDic[@"msg"]];
        if([msg isEqualToString:@""]){
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//批量收藏
-(void)BCollection{
    KweakSelf(self);
    if(self.seleArr.count == 0){
        [ZTProgressHUD showMessage:@"请选择需要操作的商品!"];
    }else{
        NSMutableArray *idArr = [NSMutableArray array];
        for (MMShopCarGoodsModel *model in self.seleArr) {
            [idArr addObject:model.ID];
        }
        
        NSString *ids = [idArr componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"BCollection"];
        NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"id":ids,@"isTrue":@"1"};
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"memberToken"];
        }
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            NSString *msg= [NSString stringWithFormat:@"%@",jsonDic[@"msg"]];
            if([msg isEqualToString:@""]){
                
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

//➕
-(void)CartPlus:(MMShopCarGoodsModel *)model{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"id":model.ID,@"attid":model.attid,@"back":@"1"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
    
}

//选中 or 未选中
-(void)CartSelect:(MMShopCarGoodsModel *)model andIsbuy:(NSString *)isbuy{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartSelect"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"id":model.ID,@"attid":model.attid,@"back":@"1",@"isbuy":isbuy};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
}
     

//网络请求后半部分
-(void)requestUrl:(NSString *)url andParam:(NSDictionary *)param{
    KweakSelf(self);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *msg= [NSString stringWithFormat:@"%@",jsonDic[@"msg"]];
        if([msg isEqualToString:@""]){
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
       
        if([code isEqualToString:@"1"]){
            [weakself.allArr removeAllObjects];
            weakself.model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.bottomView.model = weakself.model;
            weakself.moneyView.model = weakself.model;
            weakself.editView.model = weakself.model;
            NSArray *arr = jsonDic[@"key"][@"newitem"];
            weakself.allArr = [NSMutableArray arrayWithArray:arr];
            weakself.numLa.text = [NSString stringWithFormat:@"购物车(%@)",weakself.model.num];
            weakself.cartabBarItem.badgeValue = weakself.model.num;;
            if([weakself.model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
            NSMutableArray *allNumArr = [NSMutableArray array];
            for (NSArray *arr1 in arr) {
                [allNumArr addObjectsFromArray:arr1];
            }
            NSArray *modelArr = [MMShopCarGoodsModel mj_objectArrayWithKeyValuesArray:allNumArr];
            [weakself.seleArr removeAllObjects];
            for (MMShopCarGoodsModel *model in modelArr) {
                if([model.buy isEqualToString:@"1"]){
                    [weakself.seleArr addObject:model];
                }
            }
            CGFloat hei = 0;
            hei = allNumArr.count * 160;
            hei += 44 * arr.count;
            
            if(weakself.allArr.count > 0){
                weakself.hei = weakself.picHei + 20 + hei;
            }else{
                weakself.hei = weakself.picHei + 20 + WIDTH;
            }
            
            [weakself.mainCollectionView reloadData];
            [self.mainCollectionView.mj_header endRefreshing];

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
            [weakself refresh];
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

#pragma mark -- 每次进来刷新
-(void)refresh{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartList1"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [self requestUrl:url andParam:param];
}
 

-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)goPay{
    if(self.memberToken){
        if([self.model.Num1 isEqualToString:@"0"]){
            [ZTProgressHUD showMessage:@"请选择货物后提交"];
        }else{
            MMConfirmOrderViewController *confirmVC = [[MMConfirmOrderViewController alloc]init];
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
    }else{
        MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
        loginVC.modalPresentationStyle = 0;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    
}
-(void)RouteJump:(NSString *)routers{
        NSLog(@"跳转route为%@",routers);
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
        
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
        self.mainCollectionView.contentOffset = CGPointMake(0, 0);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"购物车页面"];
}
@end
