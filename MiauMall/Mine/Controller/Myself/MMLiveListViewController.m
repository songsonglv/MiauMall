//
//  MMLiveListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//  直播列表

#import "MMLiveListViewController.h"
#import "MMLiveAnchorModel.h"
#import "MMLiveAnchorCell.h"

@interface MMLiveListViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HGCategoryViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *liveArr;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HGCategoryView *cateView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSString *type;

@end

@implementation MMLiveListViewController

-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置垂直间的最小间距
        layout.minimumLineSpacing = 5;
        //设置水平间的最小间距
        layout.minimumInteritemSpacing = 5;
         layout.headerReferenceSize = CGSizeMake(0,252);
        layout.sectionInset = UIEdgeInsetsMake(5,5,0,5);//item对象上下左右的距离
        layout.itemSize=CGSizeMake((WIDTH - 15)/2, (WIDTH - 15)/2 + 70);//每一个 item 对象大小
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52 - TabbarSafeBottomMargin) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = UIColor.clearColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_mainCollectionView registerClass:[MMLiveAnchorCell class]
                forCellWithReuseIdentifier:@"cell"];
        [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    }
    return _mainCollectionView;
}

-(SDCycleScrollView *)bannerView{
    if(!_bannerView){
        _bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 188)];
        _bannerView.delegate = self;
        _bannerView.showPageControl = YES;
        _bannerView.autoScrollTimeInterval = 4.0;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _bannerView;
}

-(HGCategoryView *)cateView{
    if(!_cateView){
        _cateView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame) + 22, WIDTH, 25)];
        _cateView.backgroundColor = TCUIColorFromRGB(0xf5f4f4);
        _cateView.delegate = self;
        _cateView.titles = @[@"全部",@"我的关注"];
        _cateView.alignment = HGCategoryViewAlignmentLeft;
        _cateView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _cateView.titleNormalColor = TCUIColorFromRGB(0x828181);
        _cateView.titleSelectedColor = TCUIColorFromRGB(0x2e2e2e);
        _cateView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _cateView.vernier.backgroundColor = TCUIColorFromRGB(0x2e2e2e);
        _cateView.topBorder.hidden = YES;
        _cateView.bottomBorder.hidden = YES;
        _cateView.vernier.height = 2.0f;
        _cateView.vernierWidth = 15;
    }
    return _cateView;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(NSMutableArray *)liveArr{
    if(!_liveArr){
        _liveArr = [NSMutableArray array];
    }
    return _liveArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"直播列表页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.type = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"直播列表";
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.view addSubview:self.mainCollectionView];
    [self requestTopData];
    [self requestLiveListata];
    [self setuprefresh];
}

//上拉加载
-(void)setuprefresh{
    __block NSInteger page = 1;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestLoadMoreLiveDataPage:(long)page];
    }];
    self.mainCollectionView.mj_footer = footer;
}

-(void)requestLoadMoreLiveDataPage:(NSInteger )page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetLiveAnchors"];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.type forKey:@"type"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMLiveAnchorModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.liveArr addObjectsFromArray:arr];
                [weakself.mainCollectionView.mj_footer endRefreshing];
                [weakself.mainCollectionView reloadData];
            }else{
                [ZTProgressHUD showMessage:@"没有更多直播数据!"];
                weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestTopData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"3" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.bannerArr = [NSMutableArray arrayWithArray:arr];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestLiveListata{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetLiveAnchors"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.type forKey:@"type"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.liveArr removeAllObjects];
            NSArray *arr = [MMLiveAnchorModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.liveArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainCollectionView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uicollectionviewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.liveArr.count;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
        reusableview = headV;
        
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 0; i < self.bannerArr.count; i++) {
            MMRotationPicModel *model = self.bannerArr[i];
            [imgArr addObject:model.Picture];
        }
        self.bannerView.imageURLStringsGroup = imgArr;
        [headV addSubview:self.bannerView];
        [headV addSubview:self.cateView];
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMLiveAnchorCell *cell =
    (MMLiveAnchorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.liveArr[indexPath.item];
    
    return cell;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 15)/2, (WIDTH - 15)/2 + 70);
    
}

#pragma mark -- cateViewdelegate

-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    if(index == 0){
        self.type = @"0";
    }else{
        self.type = @"1";
    }
    [self requestLiveListata];
}

#pragma mark -- sdcycleviewdelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.bannerArr[index];
    [ZTProgressHUD showMessage:model.LinkUrl];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageBegin:@"直播列表页面"];
}


@end
