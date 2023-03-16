//
//  MMSearchResultVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/24.
//  location 0 搜索页 1 分类页面

#import "MMSearchResultVC.h"
#import "MMSortModel.h"
#import "MMSearchBrandPopView.h"

@interface MMSearchResultVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, strong) NSString *otype; //综合0 按销量排序为1 价格升序 4 价格降序3
@property (nonatomic, strong) NSString *isrec;//48小时发货选中时 为1 默认为0
@property (nonatomic, strong) NSString *isNew;//新品

@property (nonatomic, strong) UIButton *compBt;//推荐
@property (nonatomic, strong) UIButton *salesBt;//销量
@property (nonatomic, strong) UIButton *priceBt;//价格

@property (nonatomic, strong) UIButton *brandBt;//品牌
@property (nonatomic, strong) UIButton *sortBt;//分类
@property (nonatomic, strong) UIButton *neBt; //新品

@property (nonatomic, strong) NSString *pids;//分类 多选，拼接
@property (nonatomic, strong) NSString *bids;//品牌 多选，拼接

@property (nonatomic, strong) NSMutableArray *sortArr;//分类数组
@property (nonatomic, strong) NSMutableArray *brandArr;//品牌数组
@property (nonatomic, strong) NSMutableArray *dataArr;//商品数组

@property (nonatomic, strong) MMSearchBrandPopView *branPopView;//品牌分类弹窗
@property (nonatomic, strong) NSString *isShow;//0 默认不显示时 1已经展示

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

@implementation MMSearchResultVC

-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}


-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
       
//    layout.headerReferenceSize = CGSizeMake(WIDTH,455);
        
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 129, WIDTH, HEIGHT - 129 - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
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
    [TalkingDataSDK onPageBegin:@"搜索结果页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.page = 1;
    
    self.otype = @"0";
    self.isNew = @"0";
    self.isrec = @"0";
    self.isShow = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"商品列表";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    if(![self.pageNum isEqualToString:@"1"]){
        self.endpage = [self.pageNum integerValue];
        self.dataArr = [NSMutableArray arrayWithArray:self.listArr];
    }
    
    [self SetSearchRecord];
    [self GetProductScreen];
    // Do any additional setup after loading the view.
}

-(void)SetSearchRecord{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductScreen"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"location":@"0"};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetProductScreen{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductScreen"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:self.keyWord forKey:@"keyword"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *brandArr = [MMSortModel mj_objectArrayWithKeyValuesArray:jsonDic[@"brand"]];
            weakself.brandArr = [NSMutableArray arrayWithArray:brandArr];
            NSArray *sortArr = [MMSortModel mj_objectArrayWithKeyValuesArray:jsonDic[@"sub"]];
            weakself.sortArr = [NSMutableArray arrayWithArray:sortArr];
            
            if([weakself.pageNum isEqualToString:@"1"]){
                [weakself GetRecommend];
            }else{
                [weakself setUI];
            }
           
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    KweakSelf(self);
    self.branPopView = [[MMSearchBrandPopView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 129, WIDTH, HEIGHT - StatusBarHeight - 129) andData:self.sortArr andData1:self.brandArr];
    self.branPopView.sureSelectBlock = ^(NSArray * _Nonnull seleArr, NSString * _Nonnull nameStr) {
        NSLog(@"%@",nameStr);
        weakself.isShow = @"0";
        weakself.brandBt.userInteractionEnabled = YES;
        weakself.sortBt.userInteractionEnabled = YES;
        if([weakself.branPopView.type isEqualToString:@"0"]){
            weakself.pids = [seleArr componentsJoinedByString:@","];
            if(seleArr.count > 0){
                weakself.sortBt.selected = YES;
                [weakself.sortBt setTitle:nameStr forState:(UIControlStateSelected)];
                [weakself.sortBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [weakself.sortBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }else{
                weakself.sortBt.selected = NO;
                [weakself.sortBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [weakself.sortBt setTitle:@"分类" forState:(UIControlStateNormal)];
                [weakself.sortBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }
        }else{
            weakself.bids = [seleArr componentsJoinedByString:@","];
            if(seleArr.count > 0){
                weakself.brandBt.selected = YES;
                [weakself.brandBt setTitle:nameStr forState:(UIControlStateSelected)];
                [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }else{
                weakself.brandBt.selected = NO;
                [weakself.brandBt setTitle:@"品牌" forState:(UIControlStateNormal)];
                [weakself.brandBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [weakself.brandBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }
        }
        [weakself requestRefresh];
    };
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, 75)];
    topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topView];
    
    NSArray *arr = @[@"48h极速",@"销量",@"价格"];
    CGFloat wid = WIDTH/3;
    CGFloat space = 0;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((wid + space) * i, 14, wid, 13)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:redColor2 forState:(UIControlStateSelected)];
        [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
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
    
    NSArray *arr1 = @[@"分类",@"品牌",@"新品"];
    CGFloat  wid1 = 80;
    CGFloat space1 = (WIDTH - 260)/2;
    for (int i = 0; i < arr1.count; i++) {
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
            self.sortBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            
        }else if (i == 1){
            self.brandBt = btn;
            [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        }else{
            self.neBt = btn;
        }
    }
    
    [self.view addSubview:self.mainCollectionView];
    [self setupRefresh];
    
    [self.view addSubview:self.backTopBt];
}

#pragma mark -- uicollectionViewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([self.pageNum isEqualToString:@"1"]){
        return 2;
    }else{
        return 1;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([self.pageNum isEqualToString:@"1"]){
        if(section == 0){
            return self.listArr.count;
        }else{
            return self.dataArr.count;
        }
    }else{
        return self.dataArr.count;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if([self.pageNum isEqualToString:@"1"]){
        if(section == 1){
            return CGSizeMake(WIDTH, 75);
        }else{
            return CGSizeMake(WIDTH, 0);
        }
        
    }else{
        return CGSizeMake(WIDTH, 0);
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    if([self.pageNum isEqualToString:@"1"]){
        if(indexPath.section == 1){
            UICollectionReusableView *reusableview = nil;
            if(kind == UICollectionElementKindSectionHeader){
                UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
                headV.backgroundColor = UIColor.clearColor;
                reusableview = headV;
                
                UILabel *lab = [UILabel publicLab:@"- 您可能还喜欢 -" textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
                lab.frame = CGRectMake(0, 30, WIDTH, 15);
                [headV addSubview:lab];
                
            }
            return reusableview;
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
   
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([self.pageNum isEqualToString:@"1"]){
        if(indexPath.section == 0){
            cell.model = self.listArr[indexPath.item];
        }else{
            cell.model = self.dataArr[indexPath.item];
        }
    }else{
        cell.model = self.dataArr[indexPath.item];
    }
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
    MMHomeRecommendGoodsModel *model;
    if([self.pageNum isEqualToString:@"1"]){
        if(indexPath.section == 0){
            model = self.listArr[indexPath.item];
        }else{
            model = self.dataArr[indexPath.item];
        }
    }else{
        model = self.dataArr[indexPath.item];
    }
   
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



#pragma mark -- 点击按钮
-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        sender.selected = !sender.selected;
        if(sender.selected == YES){
            self.isrec = @"1";
        }else{
            self.isrec = @"0";
        }
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
        
        if([self.isShow isEqualToString:@"0"]){
            self.branPopView.type = @"0";
            [[UIApplication sharedApplication].keyWindow addSubview:self.branPopView];
            self.sortBt.userInteractionEnabled = NO;
            [self.branPopView showView];
            self.isShow = @"1";
        }else{
            self.branPopView.type = @"0";
        }
    }else if (sender.tag == 201){
        if([self.isShow isEqualToString:@"0"]){
            self.branPopView.type = @"1";
            [[UIApplication sharedApplication].delegate.window addSubview:self.branPopView];
            self.brandBt.userInteractionEnabled = NO;
            [self.branPopView showView];
            self.isShow = @"1";
        }else{
            self.branPopView.type = @"1";
        }
            
       
        
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

-(void)GetRecommend{
    KweakSelf(self);
    NSDictionary *param1 = @{@"IsMinApp":@"0",@"ItemID":@"0",@"otype":@"0",@"StoreID":@"0",@"limit":@"20",@"pid":@"0",@"brand":@"0",@"lang":self.lang,@"cry":self.cry,@"curr":@"1"};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRecommend"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            [weakself setUI];
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
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        if(weakself.page <= weakself.endpage){
            if([weakself.pageNum isEqualToString:@"1"]){
                [weakself requestLoadMoreGoodsDataPage:weakself.page];
            }else{
                [weakself requestLoadMoreSearchDataPage:weakself.page];
            }
            
        }else{
            [ZTProgressHUD showMessage:@"没有更多商品"];
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    self.mainCollectionView.mj_footer = footer;
}

//搜索商品加载
-(void)requestLoadMoreSearchDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
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
  
    [param setValue:self.keyWord forKey:@"keyword"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:pagestr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr addObjectsFromArray:arr];
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView.mj_footer endRefreshing];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//推荐商品加载
-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRecommend"];
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
  
    
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:pagestr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr addObjectsFromArray:arr];
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView.mj_footer endRefreshing];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 刷新数据
-(void)requestRefresh{
    KweakSelf(self);
    self.page = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductPageList"];
    if([self.pageNum isEqualToString:@"1"]){
        url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRecommend"];
        
    }else{
        [param setValue:self.keyWord forKey:@"keyword"];
    }
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
  
    
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:self.otype forKey:@"otype"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:self.isNew forKey:@"isNew"];
    [param setValue:self.isrec forKey:@"isrec"];
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
            weakself.mainCollectionView.mj_footer.state = MJRefreshStateIdle;
            [weakself.mainCollectionView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
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

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"搜索结果页面"];
}
@end
