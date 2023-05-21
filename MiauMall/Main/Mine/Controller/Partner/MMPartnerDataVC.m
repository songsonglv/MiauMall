//
//  MMPartnerDataVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//  合伙人数据

#import "MMPartnerDataVC.h"
#import "MMPartnerDataModel.h"
#import "MMPartnerOrderDataView.h"
#import "BRDatePickerView.h"
#import "MMPartnerTeamDataView.h"
#import "MMPartnerGoodsListCell.h"
#import "MMPartnerHotSaleGoodsModel.h"

@interface MMPartnerDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *startTime;//开始时间
@property (nonatomic, strong) NSString *endTime;//结束时间 请求数据时要用
@property (nonatomic, strong) MMPartnerDataModel *model;
@property (nonatomic, strong) MMPartnerOrderDataView *orderView;
@property (nonatomic, strong) UILabel *startTimeLa;
@property (nonatomic, strong) UILabel *endTimeLa;
@property (nonatomic, strong) MMPartnerTeamDataView *teamView;
@property (nonatomic, strong) UIView *goodsView;
@end

@implementation MMPartnerDataVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 36, WIDTH - 20, self.goodsView.height - 36) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(MMPartnerOrderDataView *)orderView{
    if(!_orderView){
        _orderView = [[MMPartnerOrderDataView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 96, WIDTH - 20, 100)];
        _orderView.model = self.model;
    }
    return _orderView;
}

-(MMPartnerTeamDataView *)teamView{
    if(!_teamView){
        _teamView = [[MMPartnerTeamDataView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.orderView.frame) + 12, WIDTH - 20, 152)];
        _teamView.model = self.model;
    }
    return _teamView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"合伙人数据页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"partnerData"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    [self requestData];
}

-(void)setUI{
    [ZTProgressHUD hide];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 54, WIDTH - 20, 42)];
    [self.view addSubview:view];
    UIImageView *iconImage1 = [[UIImageView alloc]init];
    iconImage1.image = [UIImage imageNamed:@"down_gary"];
    [view addSubview:iconImage1];
    
    [iconImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(19);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(4);
    }];
    
    UILabel *endTimeLa = [UILabel publicLab:self.endTime textColor:TCUIColorFromRGB(0xe0e0e0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    endTimeLa.preferredMaxLayoutWidth = 110;
    [endTimeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:endTimeLa];
    
    [endTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iconImage1.mas_left).offset(-6);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(11);
    }];
    self.endTimeLa = endTimeLa;
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setBackgroundColor:UIColor.clearColor];
    [btn1 addTarget:self action:@selector(clickEnd) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(22);
    }];
    
    UILabel *lab = [UILabel publicLab:@"至" textColor:TCUIColorFromRGB(0xe0e0e0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 20;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(endTimeLa.mas_left).offset(-6);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(11);
    }];
    
    UIImageView *iconImage2 = [[UIImageView alloc]init];
    iconImage2.image = [UIImage imageNamed:@"down_gary"];
    [view addSubview:iconImage2];
    
    [iconImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lab.mas_left).offset(-6);
            make.top.mas_equalTo(19);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(4);
    }];
    
    UILabel *startTimeLa = [UILabel publicLab:self.startTime textColor:TCUIColorFromRGB(0xe0e0e0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    startTimeLa.preferredMaxLayoutWidth = 110;
    [startTimeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:startTimeLa];
    
    [startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iconImage2.mas_left).offset(-6);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(11);
    }];
    self.startTimeLa = startTimeLa;
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 setBackgroundColor:UIColor.clearColor];
    [btn2 addTarget:self action:@selector(clickStart) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lab.mas_left).offset(6);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(22);
    }];
    
    self.startTimeLa = startTimeLa;
    
    
    [self.view addSubview:self.orderView];
    [self.view addSubview:self.teamView];
    
    UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.teamView.frame) + 12, WIDTH - 20, HEIGHT - CGRectGetMaxY(self.teamView.frame) - 15 - TabbarSafeBottomMargin)];
    goodsView.backgroundColor = TCUIColorFromRGB(0xfffffff);
    goodsView.layer.masksToBounds = YES;
    goodsView.layer.cornerRadius = 7.5;
    [self.view addSubview:goodsView];
    self.goodsView = goodsView;
    
    UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 16, 16)];
    goodImage.image = [UIImage imageNamed:@"good_icon"];
    [goodsView addSubview:goodImage];
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"teamBestSell"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(30, 13, 200, 16);
    [goodsView addSubview:lab1];
    [goodsView addSubview:self.mainTableView];
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSalesDefaultTime"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.ID forKey:@"id"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.startTime = jsonDic[@"SalesTime"];
            weakself.endTime = jsonDic[@"CurrencyTime"];
            [weakself requestpartnerData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestpartnerData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCurrencySalesTeamInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.startTime forKey:@"StartTime"];
    [param setValue:self.endTime forKey:@"EndTime"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMPartnerDataModel mj_objectWithKeyValues:jsonDic];
            NSArray *arr = [MMPartnerHotSaleGoodsModel mj_objectWithKeyValues:weakself.model.HotSales];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)changeDataInfoStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCurrencySalesTeamInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:startTime forKey:@"StartTime"];
    [param setValue:endTime forKey:@"EndTime"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMPartnerDataModel mj_objectWithKeyValues:jsonDic];
            weakself.orderView.model = weakself.model;
            weakself.teamView.model = weakself.model;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- uitabelviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMPartnerGoodsListCell *cell = [[MMPartnerGoodsListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)clickEnd{
    KweakSelf(self);
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeDate;
    datePickerView.title = @"选择结束时间";
    datePickerView.pickerStyle.doneTextColor = selectColor;
    datePickerView.pickerStyle.doneBtnTitle = @"确认";
    
     datePickerView.selectValue = self.endTime;
//    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        weakself.endTimeLa.text = selectValue;
        weakself.endTime = selectValue;
        [weakself changeDataInfoStartTime:weakself.startTime andEndTime:weakself.endTime];
//        [weakself isEnClick];
    };
    [datePickerView show];
}

-(void)clickStart{
    KweakSelf(self);
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeDate;
    datePickerView.title = @"选择开始时间";
    datePickerView.pickerStyle.doneTextColor = selectColor;
    datePickerView.pickerStyle.doneBtnTitle = @"确认";
    
     datePickerView.selectValue = self.startTime;
//    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        weakself.startTimeLa.text = selectValue;
        weakself.startTime = selectValue;
        [weakself changeDataInfoStartTime:weakself.startTime andEndTime:weakself.endTime];
    };
    [datePickerView show];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"合伙人数据页面"];
}

@end
