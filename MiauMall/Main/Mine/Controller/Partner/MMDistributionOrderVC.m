//
//  MMDistributionOrderVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//  分销订单页面

#import "MMDistributionOrderVC.h"
#import "MMDistributionOrderCell.h"
#import "MMPartnerOrderModel.h"

@interface MMDistributionOrderVC ()<UITableViewDelegate,UITableViewDataSource,HGCategoryViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *selectBtn;//选中按钮
@property (nonatomic, strong) NSString *wtid;// 1 2 3 4按顺序对应
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) HGCategoryView *categaryView;

@end

@implementation MMDistributionOrderVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(HGCategoryView *)categaryView{
    if(!_categaryView){
        NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"iall"],[UserDefaultLocationDic valueForKey:@"toBeShipped"],[UserDefaultLocationDic valueForKey:@"toReceived"],[UserDefaultLocationDic valueForKey:@"icompleted"]];
        _categaryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 57, WIDTH, 48)];
        _categaryView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _categaryView.delegate = self;
        _categaryView.titles = arr;
        _categaryView.selectedIndex = 0;
        _categaryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _categaryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:17];
        _categaryView.topBorder.hidden = YES;
        _categaryView.bottomBorder.hidden = YES;
        _categaryView.vernierHeight = 2;
        _categaryView.vernierWidth = 32;
        _categaryView.vernier.backgroundColor = redColor2;
        _categaryView.titleNormalColor = TCUIColorFromRGB(0x2a2b2a);
        _categaryView.titleSelectedColor = redColor2;
    }
    return _categaryView;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 100, WIDTH, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 100) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
   
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"分销订单页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.wtid = @"1";
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"distributionOrd"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, 48)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    
    [self.view addSubview:self.categaryView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(self.categaryView.frame), WIDTH - 36, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [view addSubview:line];
    
    [self.view addSubview:self.mainTableView];
    [self requestData];
}

#pragma mark -- categaryViewdelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    NSString *index1 = [NSString stringWithFormat:@"%ld",index + 1];
    self.wtid = index1;
    [self requestData];
}

//-(void)clickBtn:(UIButton *)sender{
//    KweakSelf(self);
//    NSString *index = [NSString stringWithFormat:@"%ld",sender.tag - 99];
//    self.wtid = index;
//    
//    if (![self.selectBtn isEqual:sender]) {
//        self.selectBtn.selected = NO;
//        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
//    }
//    
//    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:17];
//    sender.selected = YES;
//    self.selectBtn = sender;
//    [UIView animateWithDuration:0.25 animations:^{
//        weakself.redView.centerX = sender.centerX;
//    }];
//    
//    [self requestData];
//}

#pragma mark -- uitableiewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDistributionOrderCell *cell = [[MMDistributionOrderCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return  cell;
}


-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSalesOrder"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"99" forKey:@"limit"];
    [param setValue:self.wtid forKey:@"wtid"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPartnerOrderModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            
            [weakself.mainTableView reloadData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"分销订单页面"];
}
@end
