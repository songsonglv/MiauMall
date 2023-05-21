//
//  MMFindSimilaryViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/10.
//  查找相似

#import "MMFindSimilaryViewController.h"
#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"
#import "MMOrderDetailViewController.h"

@interface MMFindSimilaryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, assign) NSInteger page;
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
@end

@implementation MMFindSimilaryViewController

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
    layout.headerReferenceSize = CGSizeMake(WIDTH,142);
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
    [TalkingDataSDK onPageBegin:@"查找相似商品页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.page = 1;
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"查找相似";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self setUI];
    
}

-(void)setUI{
    [self.view addSubview:self.mainCollectionView];
    
    [self GetCommoditySimilar];
    [self setupRefresh];
}

-(void)GetCommoditySimilar{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommoditySimilar"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.model.ID forKey:@"ItemID"];
    [param setValue:@"0" forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
   
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            [weakself.mainCollectionView reloadData];
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
            [self requestMoreGoodsData:weakself.page];
        }else{
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainCollectionView.mj_footer = footer;
}

-(void)requestMoreGoodsData:(NSInteger)page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommoditySimilar"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.model.ID forKey:@"ItemID"];
    [param setValue:@"0" forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
   
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count  >0){
                [weakself.dataArr addObjectsFromArray:arr];
                [weakself.mainCollectionView reloadData];
                [weakself.mainCollectionView.mj_footer endRefreshing];
            }
           
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uicollectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        reusableview = headV;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10,10, WIDTH - 20, 134)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [headV addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 128, 128)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:goodsImage];
        
        UILabel *lab = [UILabel publicLab:self.model.name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        CGSize size = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(WIDTH - 162,MAXFLOAT)];
        lab.preferredMaxLayoutWidth = WIDTH - 162;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(132);
                    make.top.mas_equalTo(12);
                    make.width.mas_equalTo(WIDTH - 162);
        }];
        
        if(size.height < 18){
            lab.numberOfLines = 1;
        }else{
            lab.numberOfLines = 2;
        }
        
        NSInteger num = [self.model.limitorderbuy integerValue];
        
        CGSize size2 = [NSString sizeWithText:_model.attname font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] maxSize:CGSizeMake(MAXFLOAT,10)];
        UIView *view1 = [[UIView alloc]init];
        view1.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        view1.layer.masksToBounds = YES;
        view1.layer.cornerRadius = 9;
        [view addSubview:view1];

        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(144);
                make.top.mas_equalTo(lab.mas_bottom).offset(7);
                make.width.mas_equalTo(size2.width + 30);
                make.height.mas_equalTo(18);
        }];
        
        UILabel *limitLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x807f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        limitLa.preferredMaxLayoutWidth = 150;
        [limitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:limitLa];
        
        limitLa.text = [NSString stringWithFormat:@"｜ 限购%@件/单",_model.limitorderbuy];
        
        [limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view.mas_right).offset(10);
                make.top.mas_equalTo(lab.mas_bottom).offset(11);
                make.height.mas_equalTo(10);
        }];
        
        if(num > 10){
            limitLa.hidden = YES;
        }
        
        if([self.model.attid isEqualToString:@"0"]){
            view1.hidden = YES;
            [limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(132);
                make.top.mas_equalTo(lab.mas_bottom).offset(11);
                make.height.mas_equalTo(10);
            }];
        }else{
           
            UILabel *attLa = [UILabel publicLab:_model.attname textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
            attLa.preferredMaxLayoutWidth = 150;
            [attLa setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view1 addSubview:attLa];
           

            [attLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.top.mas_equalTo(4);
                    make.width.mas_equalTo(size2.width + 2);
                    make.height.mas_equalTo(10);
            }];
            
            UIImageView *attiIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_black"]];
            
            [view1 addSubview:attiIcon];
            
            [attiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(attLa.mas_right).offset(5);
                    make.top.mas_equalTo(7);
                    make.width.mas_equalTo(8);
                    make.height.mas_equalTo(4);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = UIColor.clearColor;
            [btn addTarget:self action:@selector(clickAtti) forControlEvents:(UIControlEventTouchUpInside)];
            [view1 addSubview:btn];
            
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.mas_equalTo(0);
            }];
        }
        
        UILabel *priceLa = [UILabel publicLab:self.model.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = 200;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(132);
                    make.bottom.mas_equalTo(-16);
                    make.height.mas_equalTo(15);
        }];
        
        NSArray *temp = [_model.priceshow componentsSeparatedByString:@" "];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(temp[0]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
            confer.text(temp[1]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:17]);
        }];
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

-(void)clickAtti{
    [self GetProductBuyTest:self.model.ID];
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

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"查找相似商品页面"];
}
@end
