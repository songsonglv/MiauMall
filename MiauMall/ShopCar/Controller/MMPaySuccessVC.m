//
//  MMPaySuccessVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMPaySuccessVC.h"
#import "MMRotationPicModel.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"
#import "MMOrderDetailViewController.h"

@interface MMPaySuccessVC ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSString *LotteryCode;
//顶部图片高度
@property (nonatomic, assign) CGFloat tkynHeight;
@property (nonatomic, assign) CGFloat topHei;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

//@property (nonatomic, strong) UITabBarItem *cartabBarItem;
@end

@implementation MMPaySuccessVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 头部视图悬停
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.sectionHeadersPinToVisibleBounds = NO;
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
//    layout.headerReferenceSize = CGSizeMake(WIDTH,self.topHei);
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, HEIGHT - 54 - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"下单成功页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
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
    titleView.titleLa.text = @"下单完成";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self loadHttpRequest];
    // Do any additional setup after loading the view.
    
    
}

-(void)loadHttpRequest{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求顶部轮播
        [weakself GetRotationPictures];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求订单类型 充值订单多一行字
        [weakself GetOrderType];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求推荐商品列表
        [weakself GetCartRecommend];
    });
    
   
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

-(void)GetRotationPictures{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    NSDictionary *param = @{@"id":@"9",@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.picArr = [NSMutableArray arrayWithArray:arr];
            MMRotationPicModel *model = arr[0];
            dispatch_queue_t q = dispatch_queue_create("h", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
                weakself.tkynHeight = (WIDTH - 14)/(size1.width/size1.height);
                weakself.topHei = weakself.tkynHeight + 278;
                
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.mainCollectionView reloadData];
                });
               
            });
            
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetOrderType{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetOrderType"];
    NSDictionary *param = @{@"id":self.ID,@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.LotteryCode = [NSString stringWithFormat:@"%@",jsonDic[@"LotteryCode"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
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
            weakself.endpage = [endpage integerValue];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)setUI{
    [ZTProgressHUD hide];
   
    [self.view addSubview:self.mainCollectionView];
    [self setupRefresh];
}

#pragma mark -- 上拉加载
-(void)setupRefresh{
    KweakSelf(self);
    //上拉 加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            [self requestLoadMoreGoodsDataPage:weakself.page];
        }else{
            [ZTProgressHUD showMessage:@"没有更多商品"];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    self.mainCollectionView.mj_footer = footer;
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

#pragma mark -- uicollectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

//设置区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, self.topHei);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        reusableview = headV;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIDTH, self.tkynHeight + 204)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [headV addSubview:view];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (MMRotationPicModel *model in self.picArr) {
            [arr addObject:model.Picture];
        }
        self.cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(7, 0, WIDTH - 14, self.tkynHeight)];
        self.cycle.imageURLStringsGroup = arr;
        self.cycle.delegate = self;
        [view addSubview:self.cycle];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 33)/2, CGRectGetMaxY(self.cycle.frame) + 32, 32, 32)];
        iconImg.image = [UIImage imageNamed:@"select_yes"];
        [view addSubview:iconImg];
        
        UILabel *lab = [UILabel publicLab:@"支付成功" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:21 numberOfLines:0];
        lab.frame = CGRectMake(0, CGRectGetMaxY(iconImg.frame) + 15, WIDTH, 21);
        [view addSubview:lab];
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 190)/2, CGRectGetMaxY(lab.frame) + 16, 92, 30)];
        [btn1 setTitle:@"返回首页" forState:(UIControlStateNormal)];
        [btn1 setTitleColor:TCUIColorFromRGB(0x373737) forState:(UIControlStateNormal)];
        btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn1.layer.masksToBounds = YES;
        btn1.layer.cornerRadius = 15;
        btn1.layer.borderColor = TCUIColorFromRGB(0x373737).CGColor;
        btn1.layer.borderWidth = 0.5;
        [btn1 addTarget:self action:@selector(goHome) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 6,  CGRectGetMaxY(lab.frame) + 16, 92, 30)];
        [btn2 setBackgroundColor:redColor2];
        [btn2 setTitle:@"查看订单" forState:(UIControlStateNormal)];
        [btn2 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn2.layer.masksToBounds = YES;
        btn2.layer.cornerRadius = 15;
        [btn2 addTarget:self action:@selector(lookOrder) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn2];
        
        UILabel *tipsLa = [UILabel publicLab:self.LotteryCode textColor:TCUIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        tipsLa.frame = CGRectMake(0, 158, WIDTH, 12);
        [view addSubview:tipsLa];
        
        UILabel *lab1 = [UILabel publicLab:@"- 您可能还喜欢 -" textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab1.frame = CGRectMake(0, view.height + 30, WIDTH, 16);
        [headV addSubview:lab1];
    }
    return reusableview;
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
    [self jumpRouters:model.Url];
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

//路由跳转
-(void)jumpRouters:(NSString *)routers{
    if([routers isEqualToString:@""]){
    }else{
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)lookOrder{
    MMOrderDetailViewController *detailVC = [[MMOrderDetailViewController alloc]init];
    detailVC.ID = self.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- sdcycledelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.picArr[index];
    [self jumpRouters:model.LinkUrl];
}

-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"下单成功页面"];
}


@end
