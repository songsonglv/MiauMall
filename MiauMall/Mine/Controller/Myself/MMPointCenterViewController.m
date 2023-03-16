//
//  MMPointCenterView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//  积分中心

#import "MMPointCenterViewController.h"
#import "MMIntegralListGoodsModel.h"
#import "MMPointsDetailsModel.h"
#import "MMIntegralGoodsCell.h"
#import "MMIntegralRuleVC.h"
#import "MMIntegarlDetailVC.h"
#import "MMIntegralGoodsDetailVC.h"

@interface MMPointCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMMemberInfoModel *memberInfo;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSMutableArray *logArr;//积分明细列表 超过三条的展示3条
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic, strong) UILabel *todayLa;
@property (nonatomic, strong) UIButton *todayBt;
@property (nonatomic, assign) NSInteger endpage;

@end

@implementation MMPointCenterViewController

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)logArr{
    if(!_logArr){
        _logArr = [NSMutableArray array];
    }
    return _logArr;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 头部视图悬停
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.sectionHeadersPinToVisibleBounds = NO;
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 8;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 8;
    layout.headerReferenceSize = CGSizeMake(WIDTH,self.hei);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 28)/2, 272);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, HEIGHT - 52 - StatusBarHeight - TabbarSafeBottomMargin) collectionViewLayout:layout];
        
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColor.clearColor;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[MMIntegralGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _collectionView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"积分中心页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleView.titleLa.text = @"积分中心";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self loadHttpRequest];
    // Do any additional setup after loading the view.
}


-(void)loadHttpRequest{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求发货时间早知道图片
           [weakself GetInteMemberHome];
       });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求日本假期数组
        [weakself GetIntePageList];
    });
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求banner数组
           [weakself GetMyLogList];
       });
    
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

//请求顶部数据
-(void)GetInteMemberHome{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetInteMemberHome"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.memberInfo = [MMMemberInfoModel mj_objectWithKeyValues:jsonDic[@"memberInfo"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//请求积分商品数据
-(void)GetIntePageList{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetIntePageList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"curr":@"1",@"limit":@"10"};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
   
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *endpage = [NSString stringWithFormat:@"%@",jsonDic[@"endpage"]];
            weakself.endpage = [endpage integerValue];
            NSArray *arr = [MMIntegralListGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.goodsArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//请求积分明细数据
-(void)GetMyLogList{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyLogList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"curr":@"1",@"limit":@"20",@"wtid":@"2"};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPointsDetailsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.logArr = [NSMutableArray arrayWithArray:arr];
            if(arr.count >= 3){
                weakself.hei = 356 + 78 * 3;
            }else{
                weakself.hei = 356 + 78 * arr.count;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}



-(void)setUI{
    [ZTProgressHUD hide];
    [self.view addSubview:self.collectionView];
    [self setupRefresh];
}

#pragma mark -- 上拉加载
-(void)setupRefresh{
    __block NSInteger page = 1;
    //上拉 加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        if(page <= self.endpage){
            [self requestLoadMoreGoodsDataPage:(long)page];
        }else{
            [ZTProgressHUD showMessage:@"没有更多积分商品"];
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        
    }];
    self.collectionView.mj_footer = footer;
}

-(void)requestLoadMoreGoodsDataPage:(NSInteger)page{
    KweakSelf(self);
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetIntePageList"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"curr":pageStr,@"limit":@"10"};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMIntegralListGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.goodsArr addObjectsFromArray:arr];
                [weakself.collectionView reloadData];
                [weakself.collectionView.mj_footer endRefreshing];
            }
           
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark -- uicollectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
        reusableview = headV;
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, WIDTH - 20, 196)];
        topImage.image = [UIImage imageNamed:@"point_bg"];
        topImage.userInteractionEnabled = YES;
        topImage.clipsToBounds = YES;
        [headV addSubview:topImage];
        
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, 44, 44)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:self.memberInfo.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 22;
        [topImage addSubview:headImage];
        
        UILabel *nameLa = [UILabel publicLab:self.memberInfo.Name textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
        nameLa.frame =CGRectMake(74, 26, WIDTH - 184, 16);
        [topImage addSubview:nameLa];
        
        UILabel *codeLa = [UILabel publicLab:[NSString stringWithFormat:@"您的ID:%@",self.memberInfo.ID] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        codeLa.frame = CGRectMake(74, 51, WIDTH - 184, 11);
        [topImage addSubview:codeLa];
        
        UIView *todayView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 108, 30, 100, 28)];
        [self setView:todayView andCorlors:@[TCUIColorFromRGB(0xfbc33b),TCUIColorFromRGB(0xfda604)]];
        todayView.layer.masksToBounds = YES;
        todayView.layer.cornerRadius = 14;
        [topImage addSubview:todayView];

        UIImageView *iconImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(14, 8, 12, 12)];
        iconImage1.image = [UIImage imageNamed:@"today_icon"];
        [todayView addSubview:iconImage1];
        
        UILabel *todayLa = [UILabel publicLab:@"领取蜜豆" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        todayLa.preferredMaxLayoutWidth = 100;
        [todayLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [todayView addSubview:todayLa];
        self.todayLa = todayLa;
        
        [todayLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(31);
                make.top.mas_equalTo(8);
                make.height.mas_equalTo(12);
        }];
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 108, 30, 100, 28)];
        [btn1 setBackgroundColor:UIColor.clearColor];
        [btn1 addTarget:self action:@selector(clickToday) forControlEvents:(UIControlEventTouchUpInside)];
        [topImage addSubview:btn1];
        self.todayBt = btn1;
        
        UILabel *integarlLa = [UILabel publicLab:self.memberInfo.Integration textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:40 numberOfLines:0];
        integarlLa.preferredMaxLayoutWidth = WIDTH - 100;
        [integarlLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [topImage addSubview:integarlLa];
        
        [integarlLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.bottom.mas_equalTo(-74);
                    make.height.mas_equalTo(34);
        }];
        
        if([self.memberInfo.IsClickToday isEqualToString:@"1"]){
            weakself.todayLa.text = @"已领取";
            weakself.todayBt.userInteractionEnabled = NO;
        }else{
            weakself.todayLa.text = @"领取蜜豆";
        }
        
        UILabel *lab = [UILabel publicLab:@"蜜豆" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [topImage addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(integarlLa.mas_right).offset(8);
                    make.bottom.mas_equalTo(-74);
                    make.height.mas_equalTo(16);
        }];
        
        UILabel *lab1 = [UILabel publicLab:@"可抵USD102.35（约JPY10225）" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.frame = CGRectMake(25, 137, WIDTH - 70, 12);
        [topImage addSubview:lab1];
        
        UIButton *ruleBt = [[UIButton alloc]init];
        [ruleBt setImage:[UIImage imageNamed:@"right_while"] forState:(UIControlStateNormal)];
        [ruleBt setTitle:@"积分规则" forState:(UIControlStateNormal)];
        [ruleBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        ruleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [ruleBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        [ruleBt addTarget:self action:@selector(clickRule) forControlEvents:(UIControlEventTouchUpInside)];
        [topImage addSubview:ruleBt];
        
        [ruleBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-8);
                    make.bottom.mas_equalTo(-18);
                    make.width.mas_equalTo(64);
                    make.height.mas_equalTo(10);
        }];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImage.frame), WIDTH, 70)];
        view1.backgroundColor = TCUIColorFromRGB(0xffffff);
        [headV addSubview:view1];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 29, 2, 15)];
        line1.backgroundColor = TCUIColorFromRGB(0xfe4a30);
        line1.layer.masksToBounds = YES;
        line1.layer.cornerRadius = 1;
        [view1 addSubview:line1];
        
        UILabel *detailLa = [UILabel publicLab:@"积分明细" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        detailLa.frame = CGRectMake(21, 30, 100, 16);
        [view1 addSubview:detailLa];
        
        UIImageView *rightIcon = [[UIImageView alloc]init];
        rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
        [view1 addSubview:rightIcon];
        
        [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-18);
                    make.centerY.mas_equalTo(view1);
                    make.width.mas_equalTo(6);
                    make.height.mas_equalTo(12);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:view1.bounds];
        btn.backgroundColor = UIColor.clearColor;
        [btn addTarget:self action:@selector(clickLogDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [view1 addSubview:btn];
        CGFloat height = 0;
        if(self.logArr.count >= 3){
            height = 234;
            for (int i = 0; i < 3; i++) {
                MMPointsDetailsModel *model = self.logArr[i];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + 78 * i, WIDTH, 78)];
                view.backgroundColor = TCUIColorFromRGB(0xffffff);
                [headV addSubview:view];
                
                UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
                lab.preferredMaxLayoutWidth = WIDTH - 100;
                [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:lab];
                
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(16);
                                    make.top.mas_equalTo(20);
                                    make.height.mas_equalTo(15);
                }];
                
                UILabel *timeLa = [UILabel publicLab:model.AddTime textColor:TCUIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
                timeLa.preferredMaxLayoutWidth = WIDTH - 100;
                [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:timeLa];
                
                [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(16);
                                    make.top.mas_equalTo(lab.mas_bottom).offset(12);
                                    make.height.mas_equalTo(12);
                }];
                
                UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",model.Plus,model.Amounts] textColor:TCUIColorFromRGB(0xfe4a30) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:15];
                numLa.preferredMaxLayoutWidth = 200;
                [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:numLa];
                
                [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.right.mas_equalTo(-18);
                                    make.centerY.mas_equalTo(view);
                                    make.height.mas_equalTo(15);
                }];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 77.5, WIDTH - 32, 0.5)];
                line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
                [view addSubview:line];
            }
        }else{
            height = 78 * self.logArr.count;
            for (int i = 0; i < self.logArr.count; i++) {
                MMPointsDetailsModel *model = self.logArr[i];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + 78 * i, WIDTH, 78)];
                view.backgroundColor = TCUIColorFromRGB(0xffffff);
                [headV addSubview:view];
                
                UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
                lab.preferredMaxLayoutWidth = WIDTH - 100;
                [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:lab];
                
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(16);
                                    make.top.mas_equalTo(20);
                                    make.height.mas_equalTo(15);
                }];
                
                UILabel *timeLa = [UILabel publicLab:model.AddTime textColor:TCUIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
                timeLa.preferredMaxLayoutWidth = WIDTH - 100;
                [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:timeLa];
                
                [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(16);
                                    make.top.mas_equalTo(lab.mas_bottom).offset(12);
                                    make.height.mas_equalTo(12);
                }];
                
                UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",model.Plus,model.Amounts] textColor:TCUIColorFromRGB(0xfe4a30) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:15];
                numLa.preferredMaxLayoutWidth = 200;
                [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:numLa];
                
                [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.right.mas_equalTo(-18);
                                    make.centerY.mas_equalTo(view);
                                    make.height.mas_equalTo(15);
                }];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 77.5, WIDTH - 32, 0.5)];
                line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
                [view addSubview:line];
            }
        }
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + height, WIDTH, 70)];
        view2.backgroundColor = TCUIColorFromRGB(0xffffff);
        [headV addSubview:view2];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(15, 29, 2, 15)];
        line2.backgroundColor = TCUIColorFromRGB(0xfe4a30);
        line2.layer.masksToBounds = YES;
        line2.layer.cornerRadius = 1;
        [view2 addSubview:line2];
        
        UILabel *detailLa1 = [UILabel publicLab:@"积分兑换" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        detailLa1.frame = CGRectMake(21, 30, 100, 16);
        [view2 addSubview:detailLa1];
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMIntegralGoodsCell *cell =
    (MMIntegralGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.goodsArr[indexPath.item];
    cell.tapExchangeBlock = ^(NSString * _Nonnull str) {
        [weakself jumpGoodsVC:str];
    };
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMIntegralListGoodsModel *model = self.goodsArr[indexPath.item];
    MMIntegralGoodsDetailVC *goodsDetailVC = [[MMIntegralGoodsDetailVC alloc]init];
    goodsDetailVC.ID = model.ID;
    goodsDetailVC.integral = self.memberInfo.Integration;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

-(void)jumpGoodsVC:(NSString *)ID{
    MMIntegralGoodsDetailVC *goodsDetailVC = [[MMIntegralGoodsDetailVC alloc]init];
    goodsDetailVC.ID = ID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 28)/2, 272);
    
}

#pragma mark -- 方法
-(void)clickToday{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ClickToday"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.todayLa.text = @"已领取";
            weakself.todayBt.userInteractionEnabled = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//查看规则
-(void)clickRule{
    MMIntegralRuleVC *vc = [[MMIntegralRuleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//积分详情列表
-(void)clickLogDetail{
    MMIntegarlDetailVC *detailVC = [[MMIntegarlDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"积分中心页面"];
}


@end
