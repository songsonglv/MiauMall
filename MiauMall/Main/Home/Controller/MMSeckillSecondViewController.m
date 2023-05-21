//
//  MMSeckillSecondViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/26.
//  装修二级页面 (里面也是各种装修仓库)

#import "MMSeckillSecondViewController.h"
#import "MMHomePageItemModel.h"
#import "MMSearchViewController.h"
#import "MMLimitMoreGoodsCell.h"
#import "MMHomeGoodsDetailController.h"
#import "MMSecondPageHomeModel.h"
#import "MMHomePageTopCell.h"
#import "MMSecondPageHomeModel.h"
#import "MMHomePageVC.h"
#import "MMLoginViewController.h"


#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"
#import "MMSearchViewController.h"
#import "MMRaffleViewController.h"

#import "MMOptionalTabModel.h"
#import "MMOptionalAreaGoodsCell.h"


@interface MMSeckillSecondViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HGCategoryViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *pageArr;//装修数组
@property (nonatomic, strong) NSString *bgImageUrl;//背景图片
@property (nonatomic, strong) NSString *keyword;//搜索框占位文字
@property (nonatomic, strong) NSMutableArray *dataArr;//今天的秒杀
@property (nonatomic, strong) NSMutableArray *lastArr;//未来的秒杀
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSMutableArray *picHArr;
@property (nonatomic, strong) NSMutableArray *goodsArr1;//商品列表item 基本上是1
@property (nonatomic, assign) CGFloat picHei;//单图高度
@property (nonatomic, strong) UIImageView *btImage;//按钮背景图片
@property (nonatomic, strong) UIView *bgView;//纯色背景view
@property (nonatomic, strong) NSString *isTomorro;//是否时明日 默认0 切换1
@property (nonatomic, strong) UILabel *limitLa;
@property (nonatomic, strong) UILabel *hourLa;
@property (nonatomic, strong) UILabel *minLa;
@property (nonatomic, strong) UILabel *secLa;
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *tomoLa;
@property (nonatomic, strong) MMTitleView *titleView;

@property (nonatomic, strong) MMSecondPageHomeModel *homeModel;
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

@property (nonatomic, strong) NSMutableArray *recListEightArr; //推荐列表8
@property (nonatomic, strong) NSMutableArray *proList2Arr;//商品列表2
@property (nonatomic, strong) NSMutableArray *recList2Arr;//推荐列表2
@property (nonatomic, strong) NSMutableArray *zyhdArr;//左右滑动数组
@property (nonatomic, strong) NSMutableArray *rankList2Arr;
@property (nonatomic, strong) NSMutableArray *proList4Arr;//商品列表4数组
@property (nonatomic, strong) NSMutableArray *proList7Arr;//商品列表7数组
@property (nonatomic, strong) NSMutableArray *proList1Arr;//商品列表1数组
@property (nonatomic, strong) NSMutableArray *proList8Arr;//商品列表8数组

@property (nonatomic, strong) NSMutableArray *stackbannerArr;//堆叠轮播数组
@property (nonatomic, strong) NSMutableArray *stackbannerHArr;//堆叠轮播高度数组

@property (nonatomic, strong) NSMutableArray *tabArr;
@property (nonatomic, strong) NSMutableArray *tabContArrs; //里面是多个cont对象

@property (nonatomic, strong) NSMutableArray *optionalArr;//任选的tab数组
@property (nonatomic, strong) NSMutableArray *optionalTitleArr;//任选标题数组
@property (nonatomic, strong) NSMutableArray *optionalGoodsArr;//任选商品数组
@property (nonatomic, strong) NSString *isOptional;//是否是任选专区 0否 1是
@property (nonatomic, strong) NSString *optionalID;//任选ID
@property (nonatomic, strong) NSString *optionalName;

@property (nonatomic, strong) NSMutableArray *limitArr;//限时抢购1数组
@property (nonatomic, strong) NSMutableArray *limit8Arr;//限时抢购8数组
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArr;//底部商品列表数组
@property (nonatomic, strong) NSMutableArray *goodsHArr;//底部推荐商品高度列表
@property (nonatomic, strong) NSMutableArray *datas;//二维高度数组
@property (nonatomic, assign) CGFloat hei;//上面topcell高度 topcell高度
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *t;

@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) MMHomePageItemModel *tabModel;
@property (nonatomic, assign) CGFloat tabHei;//默认44
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *bageColor;
@property (nonatomic, strong) NSMutableArray *tabGoodsArr;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

@property (nonatomic, strong) MMHomePageItemModel *hangFloatModel;//悬浮模块model

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

@property (nonatomic, strong) UIButton *backTopBt;

@property (nonatomic, strong) UIButton *hangFloatBt;//悬浮按钮

@end

@implementation MMSeckillSecondViewController

-(UIButton *)hangFloatBt{
    if(!_hangFloatBt){
        _hangFloatBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 60, self.backTopBt.y - 60, 50, 50)];
        [_hangFloatBt addTarget:self action:@selector(clickHangFloat) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hangFloatBt;
}


-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}

-(NSMutableArray *)pageArr{
    if(!_pageArr){
        _pageArr = [NSMutableArray array];
    }
    return _pageArr;
}

-(NSMutableArray *)picHArr{
    if(!_picHArr){
        _picHArr = [NSMutableArray array];
    }
    return _picHArr;
}

-(NSMutableArray *)picArr{
    if(!_picArr){
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

-(NSMutableArray *)goodsArr1{
    if(!_goodsArr1){
        _goodsArr1 = [NSMutableArray array];
    }
    return _goodsArr1;
}

-(NSMutableArray *)limitArr{
    if(!_limitArr){
        _limitArr = [NSMutableArray array];
    }
    return _limitArr;
}

-(NSMutableArray *)limit8Arr{
    if(!_limit8Arr){
        _limit8Arr = [NSMutableArray array];
    }
    return _limit8Arr;
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

-(NSMutableArray *)recListEightArr{
    if(!_recListEightArr){
        _recListEightArr = [NSMutableArray array];
    }
    return _recListEightArr;
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

-(NSMutableArray *)tabArr{
    if(!_tabArr){
        _tabArr = [NSMutableArray array];
    }
    return _tabArr;
}

-(NSMutableArray *)tabGoodsArr{
    if(!_tabGoodsArr){
        _tabGoodsArr = [NSMutableArray array];
    }
    return _tabGoodsArr;
}

-(NSMutableArray *)tabContArrs{
    if(!_tabContArrs){
        _tabContArrs = [NSMutableArray array];
    }
    return _tabContArrs;
}

-(NSMutableArray *)optionalArr{
    if(!_optionalArr){
        _optionalArr = [NSMutableArray array];
    }
    return _optionalArr;
}

-(NSMutableArray *)optionalGoodsArr{
    if(!_optionalGoodsArr){
        _optionalGoodsArr = [NSMutableArray array];
    }
    return _optionalGoodsArr;
}

-(NSMutableArray *)optionalTitleArr{
    if(!_optionalTitleArr){
        _optionalTitleArr = [NSMutableArray array];
    }
    return _optionalTitleArr;
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

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionHeadersPinToVisibleBounds = YES;
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
   // layout.headerReferenceSize = CGSizeMake(0,706 + 55);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_mainCollectionView registerClass:[MMOptionalAreaGoodsCell class]
            forCellWithReuseIdentifier:@"optional"];
    [_mainCollectionView registerClass:[MMHomePageTopCell class]
        forCellWithReuseIdentifier:@"topcell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _mainCollectionView;
}

-(HGCategoryView *)categoryView{
    if(!_categoryView){
        _categoryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0,0, WIDTH, self.tabHei)];
        _categoryView.backgroundColor = self.bageColor;
        _categoryView.delegate = self;
        NSMutableArray *arr = [NSMutableArray array];
        if(self.tabContArrs.count > 0){
            for (MMHomePageContModel *model in self.tabContArrs) {
                [arr addObject:model.subtitle];
            }
            _categoryView.titles = arr;
        }else{
            _categoryView.titles = self.optionalTitleArr;
        }
        _categoryView.alignment = HGCategoryViewAlignmentCenter;
        _categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _categoryView.titleNormalColor = self.textColor;
        _categoryView.titleSelectedColor = self.selectTextColor;
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
        _categoryView.vernier.backgroundColor = self.selectTextColor;
        _categoryView.itemSpacing = 24;
        _categoryView.topBorder.hidden = YES;
        _categoryView.bottomBorder.hidden = YES;
        _categoryView.vernier.height = 2.0f;
        _categoryView.vernierWidth = 18;
    }
    return _categoryView;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
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
    [TalkingDataSDK onPageBegin:[NSString stringWithFormat:@"装修子页面id=%@",self.param[@"id"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf7f7f7);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.isTomorro = @"0";
    self.isOptional = @"0";
    
    NSString *ID = self.param[@"id"];
    if([ID isEqualToString:@"1078"] || [ID isEqualToString:@"1079"] || [ID isEqualToString:@"1158"]){
        [self GetStoreInfo];
    }else{
        [self GetStoreInfo1];
    }
    
    // Do any additional setup after loading the view.
}



-(void)GetStoreInfo{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%@",self.param[@"id"]];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.homeModel = [MMSecondPageHomeModel mj_objectWithKeyValues:jsonDic];
            NSArray *arr = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:weakself.homeModel.list];
            weakself.pageArr = [NSMutableArray arrayWithArray:arr];
            weakself.bgImageUrl = weakself.homeModel.BackGroundImage;
            weakself.keyword = weakself.homeModel.keyword;
            
            dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
            
            for (MMHomePageItemModel *model in arr) {
                if([model.type isEqualToString:@"limit1more"]){
                    NSArray *arr1 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist[0]];
                    NSArray *arr2 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist[1]];
                    weakself.dataArr = [NSMutableArray arrayWithArray:arr1];
                    weakself.lastArr = [NSMutableArray arrayWithArray:arr2];
                    [weakself.goodsArr1 addObject:model];
                }else if ([model.type isEqualToString:@"limit8more"]){
                    NSArray *arr1 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist[0]];
                    NSArray *arr2 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist[1]];
                    weakself.dataArr = [NSMutableArray arrayWithArray:arr1];
                    weakself.lastArr = [NSMutableArray arrayWithArray:arr2];
                    [weakself.goodsArr1 addObject:model];
                }else if ([model.type isEqualToString:@"iadvimg"]){
                    [weakself.picArr addObject:model];
                   
                    dispatch_async(q, ^{
                        CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.cont.image]];
                        CGFloat hei = WIDTH/(size1.width/size1.height);
                        [weakself.picHArr addObject:[NSString stringWithFormat:@"%.2f",hei]];
                        
                        if(weakself.picHArr.count == weakself.picArr.count){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakself.mainTableView reloadData];
                            });
                        }
                    });
                }
            }
            [weakself setUI];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetStoreInfo1{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetStoreInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%@",self.param[@"id"]];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.homeModel = [MMSecondPageHomeModel mj_objectWithKeyValues:jsonDic];
            NSArray *arr = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:weakself.homeModel.list];
            weakself.pageArr = [NSMutableArray arrayWithArray:arr];
            weakself.bgImageUrl = weakself.homeModel.BackGroundImage;
            weakself.keyword = weakself.homeModel.keyword;
            weakself.titleView.titleLa.text = weakself.homeModel.Name;
            
            NSArray *items = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            for (MMHomePageItemModel*itemModel in items) {
                
                if([itemModel.type isEqualToString:@"banner"]){
                    [weakself.bannerArr addObject:itemModel];
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
                }else if ([itemModel.type isEqualToString:@"limit8"]){
                    [weakself.limit8Arr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"threeimg3"]){
                    [weakself.threeImgThreeArr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"threeimg4"]){
                    [weakself.threeImg4Arr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"jiutu"]){
                    [weakself.nineArr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"twoimgturn"]){
                    [weakself.imageTwoturnArr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"reclist8"]){
                    [weakself.recListEightArr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"prolist2"]){
                    [weakself.proList2Arr addObject:itemModel];
                }else if ([itemModel.type isEqualToString:@"reclist2"]){
                    [weakself.recList2Arr addObject:itemModel];
                }else if([itemModel.type isEqualToString:@"zuoyouhd"]){
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
                }else if([itemModel.type isEqualToString:@"hangfloat2"]){
                    self.hangFloatModel = itemModel;
                    continue;
                }
                else if ([itemModel.type isEqualToString:@"classtab"]){
                    NSLog(@"%@",itemModel);
                    weakself.tabModel = itemModel;
                    weakself.textColor = [UIColor colorWithWzxString:itemModel.fontColor];
                    weakself.selectTextColor = [UIColor colorWithWzxString:itemModel.havedian];
                    weakself.bageColor = [UIColor colorWithWzxString:itemModel.otherColor];
                    [weakself.tabArr addObject:itemModel];
                    for (int i = 0; i < weakself.homeModel.list.count; i++) {
                        NSDictionary *dic = weakself.homeModel.list[i];
                        NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                        if([type isEqualToString:@"classtab"]){
                            NSArray *arr = [MMHomePageContModel mj_objectArrayWithKeyValuesArray:dic[@"cont"]];
                            weakself.tabContArrs = [NSMutableArray arrayWithArray:arr];
                            MMHomePageContModel *model1 = arr[0];
                            NSArray *tabGoodsArr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model1.prolist];
                            weakself.tabGoodsArr = [NSMutableArray arrayWithArray:tabGoodsArr];
                        }
                    }
                    break;
                }else if ([itemModel.type isEqualToString:@"optional"]){
                    weakself.textColor = [UIColor colorWithWzxString:itemModel.fontColor];
                    weakself.selectTextColor = [UIColor colorWithWzxString:itemModel.havedian];
                    weakself.bageColor = [UIColor colorWithWzxString:itemModel.otherColor];
                    weakself.isOptional = @"1";
                    break;
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
                
                //九图轮播高度
                for (MMHomePageItemModel *model in weakself.nineArr) {
                    NSInteger pagenum = [model.pagenum integerValue];
                    NSInteger row = pagenum/3;
                    float hei = row * 200;
                    NSString *heiStr = [NSString stringWithFormat:@"%f",hei];
                    [weakself.nineHArr addObject:heiStr];
                    weakself.hei += hei;
                }
                
                //推荐列表8高度
                for (MMHomePageItemModel *model in weakself.recListEightArr) {
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
                
                //堆叠轮播高度
                for (MMHomePageItemModel *model in weakself.stackbannerArr) {
                    float wid3 = 250;
                    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model.cont.imglist];
                    MMHomeImageModel *model1 = imgArr[0];
                    CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model1.url]];
                    CGFloat height = wid3/(size.width/size.height);
                    NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                    [weakself.stackbannerHArr addObject:heiStr];
                    weakself.hei += height;
                }
                
                //热销榜单高度
                for (int i = 0; i < weakself.rankList2Arr.count; i++) {
                    weakself.hei += 254;
                }
                
                //限时抢购1高度
                for (int i = 0; i < weakself.limitArr.count; i++) {
                    MMHomePageItemModel *model = weakself.limitArr[i];
                    float margin = [model.margin1 floatValue];
                    weakself.hei += 264 + margin;
                }
                
                //限时抢购8高度
                for (int i = 0; i < weakself.limit8Arr.count; i++) {
                    
                    weakself.hei += 268;
                }
                
                NSString *heiStr = [NSString stringWithFormat:@"%.2f",weakself.hei];
                NSArray *heiArr1 = @[heiStr];
                [weakself.datas addObject:heiArr1];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //请求成功 回到主线程 刷新UI
                    [weakself setUI];
                });
            });
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgImage.userInteractionEnabled = YES;
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.bgImageUrl]];
    [self.view addSubview:bgImage];
    self.tabHei = 44;
    self.textColor = UIColor.blackColor;
    self.selectTextColor = UIColor.blackColor;
    self.bageColor = UIColor.whiteColor;
    
    
    NSString *ID = self.param[@"id"];
    if([ID isEqualToString:@"1078"] || [ID isEqualToString:@"1079"] || [ID isEqualToString:@"1158"]){
        UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(16, StatusBarHeight + 22, 10, 22)];
        [returnBt setImage:[UIImage imageNamed:@"return_white_icon"] forState:(UIControlStateNormal)];
        [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:returnBt];
        
        UIView *searchV = [[UIView alloc]initWithFrame:CGRectMake(50, StatusBarHeight + 20, WIDTH - 75, 30)];
        searchV.backgroundColor = TCUIColorFromRGB(0xffffff);
        searchV.layer.masksToBounds = YES;
        searchV.layer.cornerRadius = 15;
        [self.view addSubview:searchV];
        
        UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 7, 15, 16)];
        searchIcon.image = [UIImage imageNamed:@"homesearch"];
        [searchV addSubview:searchIcon];
        
        UILabel *lab = [UILabel publicLab:self.keyword textColor:TCUIColorFromRGB(0x727272) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(32, 8, WIDTH - 110, 13);
        [searchV addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 75, 30)];
        [btn addTarget:self action:@selector(clcikSearch) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [searchV addSubview:btn];
        
        [self.view addSubview:self.mainTableView];
    }else{
        UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
        topV.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.view addSubview:topV];
        
        MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
        titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
        titleView.line.hidden = YES;
        titleView.titleLa.text = self.homeModel.Name;
        [self.view addSubview:titleView];
        self.titleView = titleView;
        
        UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 35, 17, 20, 20)];
        [searchBt setImage:[UIImage imageNamed:@"order_search_icon"] forState:(UIControlStateNormal)];
        [searchBt addTarget:self action:@selector(clcikSearch) forControlEvents:(UIControlEventTouchUpInside)];
        [searchBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [titleView addSubview:searchBt];
        
        [self.view addSubview:self.mainCollectionView];
        
        if([ID isEqualToString:@"1035"]){
            
        }else if ([self.isOptional isEqualToString:@"1"]){
            [self GetOptionals];
            [self setupRefresh];
        }else if ([self.homeModel.IsLoadRec isEqualToString:@"1"]){
            if(self.tabArr.count > 0){
                
            }else{
                self.t = @"GetHotSales";
                [self requestGoodsData];
                [self setupRefresh];
            }
           
            
        }else if ([self.homeModel.IsLoadMore isEqualToString:@"1"]){
            if(self.tabArr.count > 0){
                
            }else{
                self.t = @"GetStoreRecommend";
                [self requestGoodsData];
                [self setupRefresh];
            }
            
        }
       
    }
   
    [self.view addSubview:self.backTopBt];
    
    if(self.hangFloatModel){
        [self.hangFloatBt sd_setImageWithURL:[NSURL URLWithString:self.hangFloatModel.havedian] forState:(UIControlStateNormal)];
        [self.view addSubview:self.hangFloatBt];
    }
}

#pragma mark -- 请求任选专区tab数据
-(void)GetOptionals{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetOptionals"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([str isEqualToString:@"1"]){
            NSArray *arr = [MMOptionalTabModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.optionalArr = [NSMutableArray arrayWithArray:arr];
            MMOptionalTabModel *model0 = arr[0];
            weakself.optionalID = model0.ID;
            for (MMOptionalTabModel *model in arr) {
                [weakself.optionalTitleArr addObject:model.Name];
            }
            [weakself GetOptionalListByID:model0.ID];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求任选商品
-(void)GetOptionalListByID:(NSString *)ID{
    self.page = 1;
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetOptionalListByID"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:ID forKey:@"OptionalID"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([str isEqualToString:@"1"]){
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            weakself.optionalName = [NSString stringWithFormat:@"%@",jsonDic[@"OptionalName"]];
            [weakself.optionalGoodsArr removeAllObjects];
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.optionalGoodsArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainCollectionView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestMoreOptionalGoodsPage:(NSInteger)page{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetOptionalListByID"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    [param setValue:self.optionalID forKey:@"OptionalID"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        [weakself.optionalGoodsArr addObjectsFromArray:goodsArr];
        [weakself.mainCollectionView reloadData];
        [weakself.mainCollectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark -- 请求推荐商品
-(void)requestGoodsData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,self.t];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"0" forKey:@"ItemID"];
    [param setValue:self.param[@"id"] forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
        weakself.endpage = [endpage integerValue];
        weakself.goodsArr = [NSMutableArray arrayWithArray:goodsArr];
        [weakself.mainCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 加载更多
//刷新
-(void)setupRefresh{
    KweakSelf(self);
    //上拉 加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            if([self.isOptional isEqualToString:@"1"]){
                [self requestMoreOptionalGoodsPage:weakself.page];
            }else{
                [self requestLoadMoreGoodsDataPage:weakself.page];
            }
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
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,self.t];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"0" forKey:@"ItemID"];
    [param setValue:self.param[@"id"] forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        [weakself.goodsArr addObjectsFromArray:goodsArr];
        [weakself.mainCollectionView reloadData];
        [weakself.mainCollectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clcikSearch{
    MMSearchViewController *searchVC = [[MMSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -- tableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.picArr.count > 0){
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.picArr.count > 0){
        if(section == 0){
            return self.picArr.count;
        }else{
            if([self.isTomorro isEqualToString:@"0"]){
                return self.dataArr.count;
            }else{
                return self.lastArr.count;
            }
        }
    }else{
        if([self.isTomorro isEqualToString:@"0"]){
            return self.dataArr.count;
        }else{
            return self.lastArr.count;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.picArr.count > 0){
        if(indexPath.section == 0){
            if(self.picHArr.count > 0){
                NSString *heiStr = self.picHArr[indexPath.row];
                return [heiStr floatValue];
            }else{
                return 0.1;
            }
            
        }else{
            return 158;
        }
    }else{
        return 158;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.picArr.count > 0){
        MMHomePageItemModel *model = self.goodsArr1[0];
        if(section == 1){
            return 40 ;
        }else{
            return 0.1;
        }
       
    }else{
        MMHomePageItemModel *model = self.goodsArr1[0];
        return 40 ;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    KweakSelf(self);
    
    if(section == 1){
        MMHomePageItemModel *model = self.goodsArr1[0];
        MMHomeLimitGoodsModel *model1 = self.lastArr[0];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        view.backgroundColor = UIColor.clearColor;
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 6, WIDTH, 34)];
        view1.backgroundColor = [UIColor colorWithWzxString:model.havedian];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDTH, 34) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12.5, 12.5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view1.bounds;
        maskLayer.path = maskPath.CGPath;
        view1.layer.mask = maskLayer;
        [view addSubview:view1];
        
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2, 40)];
        bgImage.userInteractionEnabled = YES;
        [view addSubview:bgImage];
        self.btImage = bgImage;
        
        UILabel *limitLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"Countdown"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        CGSize size = [NSString sizeWithText:limitLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        limitLa.frame = CGRectMake(15, 16, size.width, 13);
        [view addSubview:limitLa];
        self.limitLa = limitLa;
        
        UILabel *hourLa = [UILabel publicLab:@"" textColor:[UIColor colorWithWzxString:model.havedian] textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        hourLa.frame = CGRectMake(CGRectGetMaxX(limitLa.frame) + 10, 14, 18, 18);
        hourLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        hourLa.layer.masksToBounds = YES;
        hourLa.layer.cornerRadius = 4;
        [view addSubview:hourLa];
        self.hourLa = hourLa;

        UILabel *lab1 = [UILabel publicLab:@":" textColor:[UIColor whiteColor] textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(CGRectGetMaxX(hourLa.frame) + 4, 14, 2, 18);
        [view addSubview:lab1];
        self.lab1 = lab1;

        UILabel *minLa = [UILabel publicLab:@"" textColor:[UIColor colorWithWzxString:model.havedian] textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        minLa.frame = CGRectMake(CGRectGetMaxX(lab1.frame) + 4, 14, 18, 18);
        minLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        minLa.layer.masksToBounds = YES;
        minLa.layer.cornerRadius = 4;
        [view addSubview:minLa];
        self.minLa = minLa;

        UILabel *lab2 = [UILabel publicLab:@":" textColor:[UIColor whiteColor] textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab2.frame = CGRectMake(CGRectGetMaxX(minLa.frame) + 4, 14, 2, 18);
        [view addSubview:lab2];
        self.lab2 = lab2;

        UILabel *secLa = [UILabel publicLab:@"" textColor:[UIColor colorWithWzxString:model.havedian] textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        secLa.frame = CGRectMake(CGRectGetMaxX(lab2.frame) + 4, 14, 18, 18);
        secLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        secLa.layer.masksToBounds = YES;
        secLa.layer.cornerRadius = 4;
        [view addSubview:secLa];
        self.secLa = secLa;

        NSDate *datenow = [NSDate date];
        //时间转时间戳的方法:
        NSInteger timesp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];//现在时间

        NSInteger timesp2 = [model1.StartStamp integerValue];
        CountDownLabel *lab = [[CountDownLabel alloc]initWithKeyInfo:@"limit1more"];
        lab.frame = CGRectMake(0, 0, 10, 11);
        lab.hidden = YES;
        [view addSubview:lab];

        [lab startCountDownWithTotalTime:timesp2 - timesp - 8 * 3600 countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            
            if(day > 0){
                hour = day * 24 + hour;
            }
            NSString *hourStr;
            NSString *minuteStr;
            NSString *secondStr;
            if(hour < 10){
                hourStr = [NSString stringWithFormat:@"0%ld",hour];
            }else{
                hourStr = [NSString stringWithFormat:@"%ld",hour];
            }

            if(minute < 10){
                minuteStr = [NSString stringWithFormat:@"0%ld",minute];
            }else{
                minuteStr = [NSString stringWithFormat:@"%ld",minute];
            }
            
            if(second < 10){
                secondStr = [NSString stringWithFormat:@"0%ld",second];
            }else{
                secondStr = [NSString stringWithFormat:@"%ld",second];
            }

            CGSize size1 = [NSString sizeWithText:hourStr font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            hourLa.width = size1.width + 4;
            hourLa.text = hourStr;
            lab1.x = CGRectGetMaxX(hourLa.frame) + 4;
            minLa.x = CGRectGetMaxX(lab1.frame) + 4;
            lab2.x = CGRectGetMaxX(minLa.frame) + 4;
            secLa.x = CGRectGetMaxX(lab2.frame) + 4;

            minLa.text = minuteStr;
            secLa.text = secondStr;

        } countDownFinished:^(NSTimeInterval leftTime) {

        } waitingBlock:^{

        }];
        
        MMHomeLimitGoodsModel *model2 = self.lastArr[0];
        NSString *str2 = [model2.PromotionStart substringWithRange:NSMakeRange(5,11)];
        
        CGSize size1 = [NSString sizeWithText:[NSString stringWithFormat:@"%@%@",str2,[UserDefaultLocationDic valueForKey:@"startMS"]] font:[UIFont fontWithName:@"PingFangSC-Medium" size:18] maxSize:CGSizeMake(MAXFLOAT,18)];
        UILabel *tomoLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",str2,[UserDefaultLocationDic valueForKey:@"startMS"]] textColor:TCUIColorFromRGB(0x211325) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:0];
        tomoLa.frame = CGRectMake(WIDTH/2 + (WIDTH/2 - size1.width)/2, 16, size1.width, 18);
        [view addSubview:tomoLa];
        self.tomoLa = tomoLa;
        
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2 * i, 0, WIDTH/2, 40)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [view1 addSubview:btn];
        }
        
        if([self.isTomorro isEqualToString:@"0"]){
            bgImage.image = [UIImage imageNamed:@"bgImage_left"];
            bgImage.x = 0;
            self.limitLa.textColor = TCUIColorFromRGB(0x211e25);
            self.hourLa.backgroundColor = TCUIColorFromRGB(0x211e25);
            self.hourLa.textColor = TCUIColorFromRGB(0xffffff);
            self.lab1.textColor = TCUIColorFromRGB(0x211e25);
            self.minLa.backgroundColor = TCUIColorFromRGB(0x211e25);
            self.minLa.textColor = TCUIColorFromRGB(0xffffff);
            self.lab2.textColor = TCUIColorFromRGB(0x211e25);
            self.secLa.backgroundColor = TCUIColorFromRGB(0x211e25);
            self.secLa.textColor = TCUIColorFromRGB(0xffffff);
            self.tomoLa.textColor = TCUIColorFromRGB(0xffffff);
            
        }else{
            bgImage.image = [UIImage imageNamed:@"bgImage_right"];
            bgImage.x = WIDTH/2;
            self.limitLa.textColor = TCUIColorFromRGB(0xffffff);
            self.hourLa.backgroundColor = TCUIColorFromRGB(0xffffff);
            self.hourLa.textColor = [UIColor colorWithWzxString:model.havedian];
            self.lab1.textColor = TCUIColorFromRGB(0xffffff);
            self.minLa.backgroundColor = TCUIColorFromRGB(0xffffff);
            self.minLa.textColor = [UIColor colorWithWzxString:model.havedian];
            self.lab2.textColor = TCUIColorFromRGB(0xffffff);
            self.secLa.backgroundColor = TCUIColorFromRGB(0xffffff);
            self.secLa.textColor = [UIColor colorWithWzxString:model.havedian];
            self.tomoLa.textColor = TCUIColorFromRGB(0x211e25);
        }
        
        return view;
    }else{
        return nil;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.picArr.count > 0){
        if(indexPath.section == 0){
            MMHomePageItemModel *model = self.picArr[indexPath.row];
            MMSinglePicTableViewCell *cell = [[MMSinglePicTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"single"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            cell.TapIadvBlock = ^(NSString * _Nonnull indexStr) {
                
            };
            return cell;
        }else{
            MMHomeLimitGoodsModel *model;
            if([self.isTomorro isEqualToString:@"0"]){
               model = self.dataArr[indexPath.row];
            }else{
                model = self.lastArr[indexPath.row];
            }
           
            MMHomePageItemModel *model1 = self.goodsArr1[0];
            MMLimitMoreGoodsCell *cell = [[MMLimitMoreGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"limit1more"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            cell.type = self.isTomorro;
            cell.model1 = model1;
            return cell;
        }
    }else{
        MMHomeLimitGoodsModel *model;
        if([self.isTomorro isEqualToString:@"0"]){
           model = self.dataArr[indexPath.row];
        }else{
            model = self.lastArr[indexPath.row];
        }
       
        MMLimitMoreGoodsCell *cell = [[MMLimitMoreGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"limit1more"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.type = self.isTomorro;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.picArr.count > 0){
        if(indexPath.section == 1){
            MMHomeLimitGoodsModel *model;
            if([self.isTomorro isEqualToString:@"0"]){
               model = self.dataArr[indexPath.row];
            }else{
                model = self.lastArr[indexPath.row];
            }
            MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
            detailVC.ID = model.ID;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}


#pragma mark -- uicollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(self.goodsArr.count > 0 || self.tabGoodsArr.count > 0 || self.optionalArr.count > 0){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.goodsArr.count > 0){
        if(section == 0){
            return 1;
        }else{
            return self.goodsArr.count;
        }
    }else if (self.tabGoodsArr.count > 0){
        if(section == 0){
            return 1;
        }else{
            return self.tabGoodsArr.count;
        }
    }else if (self.optionalGoodsArr.count > 0){
        if(section == 0){
            return 1;
        }else{
            return self.optionalGoodsArr.count;
        }
    }else{
        return 1;
    }
}
    
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    if(self.goodsArr.count > 0){
        if(indexPath.section == 0){
            MMHomePageTopCell *cell =
            (MMHomePageTopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.model1 = weakself.homeModel;
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
            cell.limit8TapMoreBlock = ^(NSString * _Nonnull str) {
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
//                weakself.goodsId = indexStr;
//                [weakself GetProductBuyTest:indexStr];
            };
            return cell;
        }
    }else if (self.tabGoodsArr.count > 0){
        if(indexPath.section == 0){
            MMHomePageTopCell *cell =
            (MMHomePageTopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.model1 = weakself.homeModel;
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
            cell.limit8TapMoreBlock = ^(NSString * _Nonnull str) {
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
            cell.model1 = self.tabGoodsArr[indexPath.item];
            cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
                weakself.goodsId = indexStr;
                [weakself GetProductBuyTest:indexStr];
            };
            return cell;
        }
    }else if (self.optionalGoodsArr.count > 0){
        if(indexPath.section == 0){
            MMHomePageTopCell *cell =
            (MMHomePageTopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
            cell.model1 = weakself.homeModel;
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
            cell.limit8TapMoreBlock = ^(NSString * _Nonnull str) {
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
            MMOptionalAreaGoodsCell *cell =
            (MMOptionalAreaGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"optional" forIndexPath:indexPath];
            cell.model = self.optionalGoodsArr[indexPath.item];
            cell.optionalName = self.optionalName;
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself RouteJump:router];
            };
            return cell;
        }
    }
    else{
        MMHomePageTopCell *cell =
        (MMHomePageTopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topcell" forIndexPath:indexPath];
        cell.model1 = weakself.homeModel;
        cell.hei = weakself.hei;
        cell.bannerHei = weakself.bannerHei;
        cell.singleHArr = weakself.singleHArr;
        cell.twoimg1HArr = weakself.twoimg1HArr;
        cell.twoimg2HArr = weakself.twoimg2HArr;
        cell.threeimg3HArr = weakself.threeImgThreeHArr;
        cell.nineImgHArr = weakself.nineHArr;
        cell.imageTwoTurnHArr = weakself.imageTwoturnHArr;
        cell.threeImg4HArr = weakself.threeImg4HArr;
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
        cell.limit8TapMoreBlock = ^(NSString * _Nonnull str) {
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
    }
    
    
   
}
    
   
    //设置区头高度
    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
    {
        
        if(self.tabGoodsArr.count > 0 || self.optionalArr.count > 0){
            if(section == 1){
                return CGSizeMake(WIDTH, self.tabHei + 10);
            }
        }else if (self.goodsArr.count > 0){
            if(section == 1){
                return CGSizeMake(WIDTH, 10);
            }
        }
        return CGSizeZero;
    }

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
        reusableview = headV;
    if(self.tabGoodsArr.count > 0 || self.optionalTitleArr.count > 0){
        if(indexPath.section == 1){
            [headV addSubview:self.categoryView];
        }
        return reusableview;
        }
    }
    return reusableview;
}

    //设置区尾高度
    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
    {
        return CGSizeZero;
    }
    
    //设置cell大小
    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if(self.goodsArr.count > 0){
            if(indexPath.section == 0){
                
                return CGSizeMake(WIDTH, self.hei);
            }else{
                MMHomeRecommendGoodsModel *model = self.goodsArr[indexPath.item];
                if([model.ShortName isEqualToString:@""]){
                    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
                }else{
                    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
                }
                
            }
        }else if (self.tabGoodsArr.count > 0){
            if(indexPath.section == 0){
                
                return CGSizeMake(WIDTH, self.hei);
            }else{
                return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
            }
        }else if (self.optionalGoodsArr.count > 0){
            if(indexPath.section == 0){
                
                return CGSizeMake(WIDTH, self.hei);
            }else{
                return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 94);
            }
        }
        return  CGSizeMake(WIDTH, self.hei);
        
    }



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.goodsArr.count > 0){
        if(indexPath.section == 1){
            MMHomeRecommendGoodsModel *model = self.goodsArr[indexPath.item];
            [self RouteJump:model.Url];
        }
    }else if (self.tabGoodsArr.count > 0){
        if(indexPath.section == 1){
            MMHomeGoodsModel *model = self.tabGoodsArr[indexPath.item];
        
            if(model.link.length > 6){
                [self RouteJump:model.link];
            }else{
                NSString *link = [NSString stringWithFormat:@"/pages/shop/info?id=%@",model.ID];
                [self RouteJump:link];
            }
           
        }
    }
    
}

-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        self.isTomorro = @"0";
    }else{
        self.isTomorro = @"1";
    }
    [self.mainTableView reloadData];
}

#pragma mark - categarydelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    if(self.tabGoodsArr.count > 0){
        MMHomePageContModel *model1 = self.tabContArrs[index];
        [self.tabGoodsArr removeAllObjects];
        NSArray *tabGoodsArr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model1.prolist];
        self.tabGoodsArr = [NSMutableArray arrayWithArray:tabGoodsArr];
        [self.mainCollectionView reloadData];
        self.mainCollectionView.contentOffset = CGPointMake(0, self.hei);
    }else{
        MMOptionalTabModel *model = self.optionalArr[index];
        [self.optionalGoodsArr removeAllObjects];
        self.optionalID = model.ID;
        [self GetOptionalListByID:model.ID];
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
    BOOL isKind = [vc isKindOfClass:[MMHomePageVC class]];
    BOOL isKind2 = [vc isKindOfClass:[MMLoginViewController class]];
    if(isKind == YES){
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if (isKind2 == YES){
        vc.modalPresentationStyle = 0;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)backTop{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainTableView.contentOffset = CGPointMake(0, 0);
        self.mainCollectionView.contentOffset = CGPointMake(0, 0);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:[NSString stringWithFormat:@"装修子页面id=%@",self.param[@"id"]]];
}

@end
