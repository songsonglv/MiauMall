//
//  MMAssessListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//  商品评价列表

#import "MMAssessListViewController.h"
#import "MMAssessTagsModel.h"
#import "MMGoodsDetailAssessModel.h"
#import "MMAssessListTopView.h"
#import "MMAssessListCell.h"

@interface MMAssessListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *dataArr;//评价数组
@property (nonatomic, strong) NSMutableArray *evaluateTags;//标签数组
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *TagIDs;//选中标签
@property (nonatomic, strong) NSString *IsRec;//是否精选 0 否 1是
@property (nonatomic, strong) MMAssessListTopView *topView;
@end

@implementation MMAssessListViewController

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 170, WIDTH, HEIGHT - StatusBarHeight - 170) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xdddddd);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)evaluateTags{
    if(!_evaluateTags){
        _evaluateTags = [NSMutableArray array];
    }
    return _evaluateTags;
}

-(MMAssessListTopView *)topView{
    if(!_topView){
        _topView = [[MMAssessListTopView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 44, WIDTH, 126)];
    }
    return _topView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"商品评价页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
    titleView.titleLa.text = @"商品评价";
    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
   
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.IsRec = @"0";
    
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    
    
    KweakSelf(self);
    
    dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求评价标签
           [weakself requestTags];
       });
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求评价数据
           [weakself requestData];
       });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });

}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    self.topView.tags = self.evaluateTags;
    self.topView.assesslevel5rate = self.assesslevel5rate;
    self.topView.btnTapBlock = ^(NSString * _Nonnull indexStr, NSString * _Nonnull num) {
        [weakself requestAssessData:indexStr andNum:num];
    };
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.mainTableView];
}

#pragma mark -- 网络请求
-(void)requestTags{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPingJiaType"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.ID forKey:@"id"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMAssessTagsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"tag"]];
            weakself.evaluateTags = [NSMutableArray arrayWithArray:arr];
            NSArray *arr2 = [MMAssessTagsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"tv"]];
            [weakself.evaluateTags addObjectsFromArray:arr2];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetItemAssessList"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.ID forKey:@"id"];
    [param setValue:@"451" forKey:@"cid"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:self.IsRec forKey:@"IsRec"];
    if(self.TagIDs){
        [param setValue:self.TagIDs forKey:@"TagIDs"];
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


-(void)requestAssessData:(NSString *)ID andNum:(NSString *)num{
    KweakSelf(self);
    if([num isEqualToString:@"2"]){
        self.IsRec = @"1";
    }else{
        self.IsRec = @"0";
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetItemAssessList"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.ID forKey:@"id"];
    [param setValue:@"451" forKey:@"cid"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:self.IsRec forKey:@"IsRec"];
    if([num isEqualToString:@"0"]){
        
    }else{
        [param setValue:ID forKey:@"TagIDs"];
    }
    
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            NSArray *arr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uitableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMGoodsDetailAssessModel *model = self.dataArr[indexPath.row];
    UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
    CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
    CGFloat replyHei = 0;
    if([model.ReplyConts isEmpty]){
        
    }else{
        UILabel *la1 = [UILabel publicLab:model.ReplyConts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        la1.frame = CGRectMake(0, 0, WIDTH - 56, 36);
        CGSize size1 = [la1 sizeThatFits:CGSizeMake(la1.frame.size.width,MAXFLOAT)];
        replyHei = size1.height + 36;
    }
    
    CGFloat imageHei = 0;
    if(model.Albums.count > 3){
        imageHei = 240;
    }else if(model.Albums.count > 0){
        imageHei = 128;
    }else{
        imageHei = 0;
    }
    
    return size.height + 66 + imageHei + replyHei;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMAssessListCell*cell = [[MMAssessListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
        cell.tapPicBlock = ^(NSArray * _Nonnull arr, NSInteger index) {
            [weakself showBigImage:arr andIndex:index];
        };
    }
    return cell;
}

-(void)showBigImage:(NSArray *)arr andIndex:(NSInteger)index{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    mg.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
    [mg showPhotoViewerModels:arr controller:self selectViewIndex:index];
}
-(void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"商品评价页面"];
}

@end
