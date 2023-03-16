//
//  MMSearchViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/23.
//  搜索页面

#import "MMSearchViewController.h"
#import "MMHistorySearchView.h"
#import "MMHotSearchModel.h"
#import "MMSearchResultVC.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

@interface MMSearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) MMHistorySearchView *historyView;
@property (nonatomic, strong) UIView *hotView;
@property (nonatomic, strong) UIView *hotView1;
@property (nonatomic, strong) NSMutableArray *resultArr;//搜索结果
@property (nonatomic, strong) NSMutableArray *recommendArr;//推荐商品数组 只有在没有搜索结果时才会展示商品列表
@property (nonatomic, strong) NSString *resultEndpage;//搜索结果页数
@property (nonatomic, strong) UIView *bgView;//进来默认显示
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, assign) CGFloat headerHei;
@property (nonatomic, strong) UIButton *backTopBt;



//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;
@end

@implementation MMSearchViewController

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
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
       
    layout.headerReferenceSize = CGSizeMake(WIDTH,455);
        
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, HEIGHT - 54 - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
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

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
        _bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return _bgView;
}

-(NSMutableArray *)resultArr{
    if(!_resultArr){
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

-(NSMutableArray *)recommendArr{
    if(!_recommendArr){
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}

-(NSMutableArray *)hotArr{
    if(!_hotArr){
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:HistoryGoodsSearchPath];
        if(_historyArray.count > 30){
            NSArray *smallArray = [_historyArray subarrayWithRange:NSMakeRange(0, 30)];
            _historyArray = [NSMutableArray arrayWithArray:smallArray];
        }
        
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

-(UIView *)hotView1{
    
    if(!_hotView1){
        _hotView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
        UILabel *titleLa = [UILabel publicLab:@"热门搜索" textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        titleLa.frame = CGRectMake(10, 0, WIDTH - 20, 14);
        [_hotView1 addSubview:titleLa];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (MMHotSearchModel *model in self.hotArr) {
            [arr addObject:model.Name];
        }
        
        CGFloat y = 14 + 14;
        CGFloat letfWidth = 12;
        for (int i = 0; i < arr.count; i++) {
            
            MMHotSearchModel *model = self.hotArr[i];
            
            NSString *text = arr[i];
            
            CGFloat width = [self getWidthWithStr:text] + 28;
            CGFloat width1 = [self getWidthWithStr:text];
            if([model.IsRec isEqualToString:@"1"]){
                width = [self getWidthWithStr:text] + 38;
            }
            if (letfWidth + width + 10 > WIDTH) {
                y += 35;
                letfWidth = 12;
            }
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(letfWidth, y, width, 27)];
            view.tag = 100 + i;
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 13.5;
            view.layer.borderColor = TCUIColorFromRGB(0xe7e7e7).CGColor;
            view.layer.borderWidth = 0.5;
            [_hotView1 addSubview:view];
            
           
            
            letfWidth += width + 12;
            
            UILabel *lab = [UILabel publicLab:text textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            lab.frame = CGRectMake(14, 7, width1, 13);
            [view addSubview:lab];
            
            
            
            if([model.IsRec isEqualToString:@"1"]){
                UIImageView *fireImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 12, 15)];
                fireImage.image = [UIImage imageNamed:@"fire_icon"];
                [view addSubview:fireImage];
                
                lab.x = 24;
            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(tapBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }
        _hotView1.height = y + 30;
        
    }
    return _hotView1;
}

-(UIView *)hotView{
    
    if(!_hotView){
        _hotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
        UILabel *titleLa = [UILabel publicLab:@"热门搜索" textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        titleLa.frame = CGRectMake(10, 0, WIDTH - 20, 14);
        [_hotView addSubview:titleLa];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (MMHotSearchModel *model in self.hotArr) {
            [arr addObject:model.Name];
        }
        
        CGFloat y = 14 + 14;
        CGFloat letfWidth = 12;
        for (int i = 0; i < arr.count; i++) {
            
            MMHotSearchModel *model = self.hotArr[i];
            
            NSString *text = arr[i];
            
            CGFloat width = [self getWidthWithStr:text] + 28;
            CGFloat width1 = [self getWidthWithStr:text];
            if([model.IsRec isEqualToString:@"1"]){
                width = [self getWidthWithStr:text] + 38;
            }
            if (letfWidth + width + 10 > WIDTH) {
                y += 35;
                letfWidth = 12;
            }
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(letfWidth, y, width, 27)];
            view.tag = 100 + i;
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 13.5;
            view.layer.borderColor = TCUIColorFromRGB(0xe7e7e7).CGColor;
            view.layer.borderWidth = 0.5;
            [_hotView addSubview:view];
            
           
            
            letfWidth += width + 12;
            
            UILabel *lab = [UILabel publicLab:text textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            lab.frame = CGRectMake(14, 7, width1, 13);
            [view addSubview:lab];
            
            
            
            if([model.IsRec isEqualToString:@"1"]){
                UIImageView *fireImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 12, 15)];
                fireImage.image = [UIImage imageNamed:@"fire_icon"];
                [view addSubview:fireImage];
                
                lab.x = 24;
            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(tapBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }
        _hotView.height = y + 30;
        
        self.headerHei = _hotView.height + 328;
        
    }
    return _hotView;
}

-(MMHistorySearchView *)historyView{
    KweakSelf(self);
    if(!_historyView){
        _historyView = [[MMHistorySearchView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.hotView.frame) + 30, WIDTH, 100)];
        _historyView.dataArr = self.historyArray;
        _historyView.height = _historyView.hei;
        _historyView.tapSearchBlcok = ^(NSString * _Nonnull keyword) {
            weakself.searchField.text = keyword;
            [weakself GetProductPageList];
        };
        _historyView.tapDeleteBlock = ^(NSString * _Nonnull str) {
            [weakself.historyArray removeAllObjects];
            weakself.historyView.dataArr = weakself.historyArray;
            [NSKeyedArchiver archiveRootObject:weakself.historyArray toFile:HistoryGoodsSearchPath];
        };
    }
    return _historyView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"搜索页面"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
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
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 54)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(7, StatusBarHeight + 17, 20, 20)];
    [returnBt setImage:[UIImage imageNamed:@"return_black"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:returnBt];
    
    UIView *searchV = [[UIView alloc]initWithFrame:CGRectMake(38, StatusBarHeight + 11, WIDTH - 50, 32)];
    searchV.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    searchV.layer.masksToBounds = YES;
    searchV.layer.cornerRadius = 16;
    [topV addSubview:searchV];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9, 15, 14)];
    searchIcon.image = [UIImage imageNamed:@"homesearch"];
    [searchV addSubview:searchIcon];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(34, 7, searchV.width - 122, 18)];
    field.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    field.delegate = self;
    field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    field.textColor = TCUIColorFromRGB(0x333333);
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.textAlignment = NSTextAlignmentLeft;
    [searchV addSubview:field];
    self.searchField = field;
    
    UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(searchV.width - 78, 0, 78, 31)];
    [searchBt setBackgroundColor:redColor2];
    [searchBt setTitle:@"搜索" forState:(UIControlStateNormal)];
    [searchBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    searchBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    searchBt.layer.masksToBounds = YES;
    searchBt.layer.cornerRadius = 16;
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [searchV addSubview:searchBt];
    

    [self GetSearchKeywork];
    // Do any additional setup after loading the view.
}

-(void)GetSearchKeywork{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSearchKeywork"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHotSearchModel mj_objectArrayWithKeyValuesArray:jsonDic[@"keys"]];
            weakself.hotArr = [NSMutableArray arrayWithArray:arr];
            NSString *str  = jsonDic[@"keyword"];
            weakself.searchField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x666666)}];
            
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)setUI{
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.hotView];
    
    if(self.historyArray.count > 0){
        [self.bgView addSubview:self.historyView];
    }
    
    self.mainCollectionView.hidden = YES;
    [self.view addSubview:self.mainCollectionView];
    [self setupRefresh];
    
    [self.view addSubview:self.backTopBt];
}


#pragma mark -- uicollectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recommendArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
        reusableview = headV;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 380)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [headV addSubview:view];
        
        [view addSubview:self.hotView1];
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 78)/2, CGRectGetMaxY(self.hotView.frame) + 55, 78, 86)];
        iconImg.image = [UIImage imageNamed:@"no_goods_icon"];
        [view addSubview:iconImg];
        
        UILabel *lab1 = [UILabel publicLab:@"抱歉，没有找到您想要的商品~" textColor:TCUIColorFromRGB(0x818181) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(0, CGRectGetMaxY(iconImg.frame) + 16, WIDTH, 14);
        [view addSubview:lab1];
        
        NSString *title = @"上传商品信息";
        CGFloat wid = [self getWidthWithStr:title] + 20;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - wid)/2, CGRectGetMaxY(lab1.frame) + 18, wid, 24)];
        [btn setBackgroundColor:TCUIColorFromRGB(0x202020)];
        [btn setTitle:title forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 12;
        [btn addTarget:self action:@selector(goWish) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        UILabel *lab = [UILabel publicLab:@"- 您可能还喜欢 -" textColor:TCUIColorFromRGB(0x202020) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
        lab.frame = CGRectMake(0, CGRectGetMaxY(view.frame) + 30, WIDTH, 15);
        [headV addSubview:lab];
        
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.recommendArr[indexPath.item];
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
    MMHomeRecommendGoodsModel *model = self.recommendArr[indexPath.item];
    [self jumpRouters:model.Url];
}


-(void)clickSearch{
    if(self.searchField.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入您要搜索的商品名"];
    }else{
        [self setHistoryArrWithStr:self.searchField.text];
        [self GetProductPageList];
    }
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:HistoryGoodsSearchPath];
    self.historyView.dataArr = _historyArray;
   // [self requestSearchData:1 andKey:str];
   // [ZTProgressHUD showMessage:@"暂无搜索商品"];
}

- (void)tapBt:(UIButton *)sender
{
    MMHotSearchModel *model = self.hotArr[sender.tag - 100];
    self.searchField.text = model.Name;
    [self setHistoryArrWithStr:model.Name];
    [self GetProductPageList];
    
}

//搜索请求接口
-(void)GetProductPageList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductPageList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.searchField.text forKey:@"keyword"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.resultArr = [NSMutableArray arrayWithArray:arr];
            weakself.resultEndpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            if(arr.count > 0){
                weakself.bgView.hidden = NO;
                weakself.mainCollectionView.hidden = YES;
                MMSearchResultVC *resultVC = [[MMSearchResultVC alloc]init];
                resultVC.listArr = weakself.resultArr;
                resultVC.pageNum = weakself.resultEndpage;
                resultVC.keyWord = weakself.searchField.text;
                [weakself.navigationController pushViewController:resultVC animated:YES];
            }else{
                [weakself GetRecommend];
                weakself.bgView.hidden = YES;
                weakself.mainCollectionView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
            weakself.recommendArr = [NSMutableArray arrayWithArray:arr];
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            [weakself.mainCollectionView reloadData];
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
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRecommend"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.recommendArr addObjectsFromArray:arr];
            [weakself.mainCollectionView reloadData];
            [weakself.mainCollectionView.mj_footer endRefreshing];
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




-(void)goWish{
    [self jumpRouters:@"/member/wishlist"];
}

//路由跳转
-(void)jumpRouters:(NSString *)routers{
    if([routers isEqualToString:@""]){
    }else{
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//获取文本高度
- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(WIDTH, 27) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.width;
    return width;
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

-(void)backTop{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainCollectionView.contentOffset = CGPointMake(0, 0);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"搜索页面"];
}

@end
