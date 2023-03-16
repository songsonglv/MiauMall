//
//  MMMyAssessViewControllerView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//  我的评价

#import "MMMyAssessViewControllerView.h"
#import "MMMyAssessModel.h"
#import "MMNoAssessGoodsModel.h"
#import "MMMyAssessCell.h"
#import "MMMyAssessGoodsCell.h"
#import "MMOrderAssessViewController.h"

@interface MMMyAssessViewControllerView ()<UITableViewDelegate,UITableViewDataSource,HGCategoryViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSDictionary *memberDic;//用户信息

@property (nonatomic, strong) NSMutableArray *goodsArr;//待评价的商品列表
@property (nonatomic, strong) NSMutableArray *assessArr;//已评价的商品列表
@property (nonatomic, strong) NSString *noCount;//待评价数量
@property (nonatomic, strong) HGCategoryView *cateView;
@property (nonatomic, strong) UITableView *goodsTableView;//待评价商品列表
@property (nonatomic, strong) UITableView *assessTableView;//评价列表

@end

@implementation MMMyAssessViewControllerView

-(HGCategoryView *)cateView{
    if(!_cateView){
        _cateView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 162, WIDTH - 20, 25)];
        _cateView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _cateView.delegate = self;
        _cateView.titles = @[[NSString stringWithFormat:@"待评价(%@)",self.noCount],@"已评价"];
        _cateView.selectedIndex = 0;
        _cateView.alignment = HGCategoryViewAlignmentLeft;
        _cateView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _cateView.titleNormalColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _cateView.vernier.backgroundColor = TCUIColorFromRGB(0x2e2e2e);
        _cateView.topBorder.hidden = YES;
        _cateView.bottomBorder.hidden = YES;
        _cateView.vernier.height = 2.0f;
        _cateView.vernierWidth = 15;
    }
    return _cateView;
}

-(UITableView *)goodsTableView{
    if(!_goodsTableView){
        _goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cateView.frame) + 18, WIDTH, HEIGHT - CGRectGetMaxY(self.cateView.frame) - 18 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _goodsTableView.showsVerticalScrollIndicator = NO;
        _goodsTableView.showsHorizontalScrollIndicator = NO;
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
    }
    return _goodsTableView;
}

-(UITableView *)assessTableView{
    if(!_assessTableView){
        _assessTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cateView.frame) + 18, WIDTH, HEIGHT - CGRectGetMaxY(self.cateView.frame) - 18 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _assessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _assessTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _assessTableView.showsVerticalScrollIndicator = NO;
        _assessTableView.showsHorizontalScrollIndicator = NO;
        _assessTableView.delegate = self;
        _assessTableView.dataSource = self;
    }
    return _assessTableView;
}

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)assessArr{
    if(!_assessArr){
        _assessArr = [NSMutableArray array];
    }
    return _assessArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"我的评价页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"我的评价";
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
     self.memberDic = [NSKeyedUnarchiver unarchiveObjectWithFile:MemberInfoPath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"assessSuccess" object:nil];

    

    [self requestData];
    [self requestData1];
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    [self refreshData1];
    [self refreshData2];
}

-(void)refreshData2{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAssessList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"type":@"0",@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMMyAssessModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.assessArr removeAllObjects];
            [weakself.assessArr addObjectsFromArray:arr];
            [weakself.assessTableView reloadData];
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)refreshData1{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAccessList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"typeid":@"0",@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMNoAssessGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.goodsArr removeAllObjects];
            [weakself.goodsArr addObjectsFromArray:arr];
            weakself.noCount = jsonDic[@"count"];
            weakself.cateView.titles = @[[NSString stringWithFormat:@"待评价(%@)",weakself.noCount],@"已评价"];
            [weakself.goodsTableView reloadData];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData1{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAssessList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"type":@"0",@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMMyAssessModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.assessArr = [NSMutableArray arrayWithArray:arr];
            if(weakself.assessTableView){
                [weakself.assessTableView reloadData];
            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAccessList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"typeid":@"0",@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD hide];
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMNoAssessGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.goodsArr = [NSMutableArray arrayWithArray:arr];
            weakself.noCount = jsonDic[@"count"];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(24, StatusBarHeight + 86, 50, 50)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.memberDic[@"pic"]]];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 25;
    [self.view addSubview:headImage];
    
    UILabel *nameLa = [UILabel publicLab:self.memberDic[@"name"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(84);
            make.top.mas_equalTo(StatusBarHeight + 90);
            make.height.mas_equalTo(19);
    }];
    
    UILabel *vipLa = [UILabel publicLab:@"黑卡" textColor:TCUIColorFromRGB(0xf5cd86) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    vipLa.backgroundColor = TCUIColorFromRGB(0x231815);
    vipLa.layer.masksToBounds = YES;
    vipLa.layer.cornerRadius = 4;
    vipLa.hidden = YES;
    [self.view addSubview:vipLa];
    
    [vipLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(5);
            make.top.mas_equalTo(StatusBarHeight + 90);
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *codeLa = [UILabel publicLab:[NSString stringWithFormat:@"您的ID:%@",self.memberDic[@"ID"]] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    //codeLa.frame = CGRectMake(86, CGRectGetMaxY(nameLa.frame) + 10, MAXFLOAT, 12);
    codeLa.preferredMaxLayoutWidth = 180;
    [codeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.view addSubview:codeLa];
    
    [codeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(84);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    [self.view addSubview:self.cateView];
    [self.view addSubview:self.goodsTableView];
    [self.view addSubview:self.assessTableView];
    self.assessTableView.hidden = YES;
}

#pragma mark -- cateViewdelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    if(index == 0){
        self.goodsTableView.hidden = NO;
        self.assessTableView.hidden = YES;
    }else{
        self.goodsTableView.hidden = YES;
        self.assessTableView.hidden = NO;
    }
}

#pragma mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.goodsTableView){
        return self.goodsArr.count;
    }else{
        return self.assessArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.goodsTableView){
        return 150;
    }else{
        MMMyAssessModel *model = self.assessArr[indexPath.row];
        CGSize size = [NSString sizeWithText:model.Conts font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 28,MAXFLOAT)];
        if(model.Albums.count > 3){
            return size.height + 304;
        }else if (model.Albums.count > 0){
            return size.height + 186;
        }else{
            return size.height + 58;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    if(tableView == self.assessTableView){
        MMMyAssessCell*cell = [[MMMyAssessCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MMMyAssessModel *model = self.assessArr[indexPath.row];
        cell.model = model;
        cell.tapPicArrBlock = ^(NSArray * _Nonnull arr, NSInteger index) {
            [weakself showBigImage:arr andIndex:index];
        };
        return cell;
    }
    MMMyAssessGoodsCell*cell = [[MMMyAssessGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MMNoAssessGoodsModel *model = self.goodsArr[indexPath.row];
    cell.model = model;
    cell.goAssessBlock = ^(NSString * _Nonnull ID) {
        [weakself goAssess:ID];
    };
    return cell;
    
}

-(void)showBigImage:(NSArray *)arr andIndex:(NSInteger)index{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    mg.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
    [mg showPhotoViewerModels:arr controller:self selectViewIndex:index];
}

-(void)goAssess:(NSString *)ID{
    MMOrderAssessViewController *assessVC = [[MMOrderAssessViewController alloc]init];
    assessVC.ID = ID;
    [self.navigationController pushViewController:assessVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"我的评价页面"];
}
@end
