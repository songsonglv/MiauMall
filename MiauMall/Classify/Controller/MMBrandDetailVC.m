//
//  MMBrandDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//  品牌详情

#import "MMBrandDetailVC.h"
#import "MMBrandInfoModel.h"
#import "MMBrandInfoView.h"
#import "MMBrandListModel.h"
#import "MMBrandGoodsCell.h"

@interface MMBrandDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMBrandInfoModel *model;
@property (nonatomic, strong) MMBrandInfoView *infoView;
@property (nonatomic, strong) UIView *screenView;//排序view
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MMBrandListModel *brandListModel;
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *xinBt;
@property (nonatomic, strong) UIButton *saleBt;
@property (nonatomic, strong) UIButton *priceBt;
@property (nonatomic, strong) UIButton *xinBt1;
@property (nonatomic, strong) UIButton *saleBt1;
@property (nonatomic, strong) UIButton *priceBt1;
@property (nonatomic, strong) NSString *otype;//新品 1 销量 0 价格升序 3 价格降序 2
@property (nonatomic, strong) UIView *topView;

@end

@implementation MMBrandDetailVC

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-59, WIDTH, HEIGHT - TabbarSafeBottomMargin + 59) style:(UITableViewStyleGrouped)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
    }
    return _mainTableView;
}

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 80)];
        _topView.backgroundColor = TCUIColorFromRGB(0xffffff);
//        [_screenView addSubview:self.screenView];
        NSArray *arr = @[@"新品",@"销量",@"价格"];
        CGFloat wid = 70;
        CGFloat space = 55;
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 320)/2 + (wid + space) * i, StatusBarHeight + 38, wid, 24)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 12;
            [btn setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
            [btn setTitle:arr[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateSelected)];
            [btn setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            btn.tag = 200 + i;
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [_topView addSubview:btn];

            if(i == 0){
                self.xinBt1 = btn;
            }else if (i == 1){
                self.saleBt1 = btn;
                [btn setBackgroundColor:redColor2];
                [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            }else{
                self.priceBt1 = btn;
                [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }
        }
    }
    return _topView;
}

-(UIView *)screenView{
    if(!_screenView){
        _screenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        _screenView.backgroundColor = TCUIColorFromRGB(0xffffff);
        NSArray *arr = @[@"新品",@"销量",@"价格"];
        CGFloat wid = 70;
        CGFloat space = 55;
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 320)/2 + (wid + space) * i, 18, wid, 24)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 12;
            [btn setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
            [btn setTitle:arr[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateSelected)];
            [btn setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [_screenView addSubview:btn];
            
            if(i == 0){
                self.xinBt = btn;
            }else if (i == 1){
                self.saleBt = btn;
                [btn setBackgroundColor:redColor2];
                [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            }else{
                self.priceBt = btn;
                [btn setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
                [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:5];
            }
        }
    }
    return _screenView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"品牌详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.otype = @"0";
    self.page = 1;
    [self GetBrandInfo];
    
    // Do any additional setup after loading the view.
}

-(void)GetBrandInfo{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBrandInfo"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"id"];
    }
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMBrandInfoModel mj_objectWithKeyValues:jsonDic[@"brandInfo"]];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    self.infoView = [[MMBrandInfoView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 432) andModel:self.model];
    self.infoView.returnViewHei = ^(CGFloat hei) {
        weakself.infoView.height = hei;
        weakself.mainTableView.tableHeaderView = weakself.infoView;
    };
    self.infoView.tapShareBlock = ^(NSString * _Nonnull str) {
        [ZTProgressHUD showMessage:@"分享"];
    };
    
    self.infoView.tapReturnBlock = ^(NSString * _Nonnull str) {
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    self.infoView.tapSearchBlock = ^(NSString * _Nonnull str) {
        [ZTProgressHUD showMessage:@"搜索"];
    };
    [self.view addSubview:self.infoView];
    self.mainTableView.tableHeaderView = self.infoView;
    [self.view addSubview:self.mainTableView];
    
    self.topView.hidden = YES;
    [self.view addSubview:self.topView];
    
    
    [self requestData];
    [self setupRefresh];
}

-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBrandList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"IsMinApp":@"0",@"curr":@"1",@"limit":@"10",@"otype":self.otype};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.param[@"id"]){
        [param setValue:self.param[@"id"] forKey:@"bids"];
    }else if (self.ID){
        [param setValue:self.ID forKey:@"bids"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.brandListModel = [MMBrandListModel mj_objectWithKeyValues:jsonDic];
            NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:weakself.brandListModel.list];
            weakself.dataArr = [NSMutableArray arrayWithArray:goodsArr];
            weakself.endpage = [weakself.brandListModel.endpage integerValue];
            [weakself.mainTableView reloadData];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)refreshData{
    KweakSelf(self);
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBrandList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"IsMinApp":@"0",@"curr":@"1",@"limit":@"10",@"otype":self.otype};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.param[@"id"]){
        [param setValue:self.param[@"id"] forKey:@"bids"];
    }else if (self.ID){
        [param setValue:self.ID forKey:@"bids"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [self.dataArr removeAllObjects];
            weakself.brandListModel = [MMBrandListModel mj_objectWithKeyValues:jsonDic];
            NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:weakself.brandListModel.list];
            [weakself.dataArr addObjectsFromArray:goodsArr];
            weakself.endpage = [weakself.brandListModel.endpage integerValue];
            [weakself.mainTableView reloadData];
            
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
            [ZTProgressHUD showMessage:@"没有更多类似商品"];
            weakself.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
       
    }];
    
    self.mainTableView.mj_footer = footer;
}

-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBrandList"];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"IsMinApp":@"0",@"curr":pageStr,@"limit":@"10",@"otype":self.otype};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.param[@"id"]){
        [param setValue:self.param[@"id"] forKey:@"bids"];
    }else if (self.ID){
        [param setValue:self.ID forKey:@"bids"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.brandListModel = [MMBrandListModel mj_objectWithKeyValues:jsonDic];
            NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:weakself.brandListModel.list];
            [weakself.dataArr addObjectsFromArray:goodsArr];
            [weakself.mainTableView reloadData];
            [weakself.mainTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma  mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [view addSubview:self.screenView];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMBrandGoodsCell*cell = [[MMBrandGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeRecommendGoodsModel *model = self.dataArr[indexPath.row];
    MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- uiscrollerdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > self.infoView.height){
        self.topView.hidden = NO;
    }else{
        self.topView.hidden = YES;
    }
}

#pragma mark -- 事件
-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        self.otype = @"1";
        self.xinBt.selected = YES;
        self.saleBt.selected = NO;
        [self.xinBt setBackgroundColor:redColor2];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        
        [self.saleBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
        self.xinBt1.selected = YES;
        self.saleBt1.selected = NO;
        [self.xinBt1 setBackgroundColor:redColor2];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        
        [self.saleBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
    }else if (sender.tag == 101){
        self.otype = @"0";
        self.xinBt.selected = NO;
        self.saleBt.selected = YES;
        [self.xinBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        [self.saleBt setBackgroundColor:redColor2];

        
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
        self.xinBt1.selected = NO;
        self.saleBt1.selected = YES;
        [self.xinBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        [self.saleBt1 setBackgroundColor:redColor2];

        
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
    }else if (sender.tag == 102){
        self.xinBt.selected = NO;
        [self.xinBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        self.saleBt.selected = NO;
        [self.saleBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [self.priceBt setBackgroundColor:redColor2];
        
        self.xinBt1.selected = NO;
        [self.xinBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        self.saleBt1.selected = NO;
        [self.saleBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [self.priceBt1 setBackgroundColor:redColor2];
        
        if([self.otype isEqualToString:@"0"] || [self.otype isEqualToString:@"1"] || [self.otype isEqualToString:@"2"]){
            self.otype = @"3";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
            [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        }else if ([self.otype isEqualToString:@"3"]){
            self.otype = @"2";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
        }
    }else if (sender.tag == 200){
        self.otype = @"1";
        self.xinBt.selected = YES;
        self.saleBt.selected = NO;
        [self.xinBt setBackgroundColor:redColor2];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        
        [self.saleBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
        self.xinBt1.selected = YES;
        self.saleBt1.selected = NO;
        [self.xinBt1 setBackgroundColor:redColor2];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        
        [self.saleBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
    }else if (sender.tag == 201){
        self.otype = @"0";
        
        self.xinBt.selected = NO;
        self.saleBt.selected = YES;
        [self.xinBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        [self.saleBt setBackgroundColor:redColor2];

        
        [self.priceBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
        self.xinBt1.selected = NO;
        self.saleBt1.selected = YES;
        [self.xinBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        [self.saleBt1 setBackgroundColor:redColor2];

        
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [self.priceBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        
    }else if (sender.tag == 202){
        
        self.xinBt.selected = NO;
        [self.xinBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        self.saleBt.selected = NO;
        [self.saleBt setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [self.priceBt setBackgroundColor:redColor2];
        
        self.xinBt1.selected = NO;
        [self.xinBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.xinBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        self.saleBt1.selected = NO;
        [self.saleBt1 setBackgroundColor:TCUIColorFromRGB(0xf3f3f3)];
        [self.saleBt1 setTitleColor:TCUIColorFromRGB(0x535353) forState:(UIControlStateNormal)];
        
        [self.priceBt1 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [self.priceBt1 setBackgroundColor:redColor2];
        
        if([self.otype isEqualToString:@"0"] || [self.otype isEqualToString:@"1"] || [self.otype isEqualToString:@"2"]){
            self.otype = @"3";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
            [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_up_black"] forState:(UIControlStateNormal)];
        }else if ([self.otype isEqualToString:@"3"]){
            self.otype = @"2";
            [self.priceBt setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
            [self.priceBt1 setImage:[UIImage imageNamed:@"triangle_down_black"] forState:(UIControlStateNormal)];
        }
    }
    
    [self refreshData];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"品牌详情"];
}
@end
