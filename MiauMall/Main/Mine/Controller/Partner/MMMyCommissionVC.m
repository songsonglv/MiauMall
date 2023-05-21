//
//  MMMyCommissionVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/28.
//  我的佣金页面

#import "MMMyCommissionVC.h"
#import "MMMemberInfoModel.h"
#import "MMCommissionModel.h"
#import "MMCommissionCell.h"
#import "MMCommissionDetailVC.h"

@interface MMMyCommissionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIImageView *bgImage;//头部背景图片
@property (nonatomic, strong) MMMemberInfoModel *memberInfo;//头部数据
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MMMyCommissionVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, WIDTH - 20, self.bottomView.height - 48) style:(UITableViewStylePlain)];
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
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"我的佣金页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.view.backgroundColor = TCUIColorFromRGB(0xf6f6f6);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 267)];
    bgImage.image = [UIImage imageNamed:@"red_bg"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    self.bgImage = bgImage;
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 18, 8, 16)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    UILabel *titleLa = [UILabel publicLab:@"我的佣金" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(50, StatusBarHeight + 18, WIDTH - 100, 18);
    [bgImage addSubview:titleLa];
    
    UIButton *detailBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 27, StatusBarHeight + 18, 13, 15)];
    [detailBt setImage:[UIImage imageNamed:@"detail_icon_while"] forState:(UIControlStateNormal)];
    [detailBt addTarget:self action:@selector(clickDetail) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:detailBt];
    
    [self requestListData];
}

-(void)requestListData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSaleLogList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMCommissionModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            
            [weakself requestData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    [ZTProgressHUD showLoadingWithMessage:@""];
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SalesMoney"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.memberInfo = [MMMemberInfoModel mj_objectWithKeyValues:jsonDic[@"memberInfo"]];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    
    UILabel *tiLa = [UILabel publicLab:@"我的佣金(JPY)" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    tiLa.frame = CGRectMake(0, StatusBarHeight + 70, WIDTH, 13);
    [self.bgImage addSubview:tiLa];
    
    UILabel *moneyLa = [UILabel publicLab:self.memberInfo.YongBalance textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:40 numberOfLines:0];
    moneyLa.frame = CGRectMake(0, CGRectGetMaxY(tiLa.frame) + 22, WIDTH, 40);
    [self.bgImage addSubview:moneyLa];
    
    UILabel *showLa = [UILabel publicLab:self.memberInfo.YongTotalReadyShow textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    showLa.frame = CGRectMake(0, CGRectGetMaxY(moneyLa.frame) + 18, WIDTH, 16);
    [self.bgImage addSubview:showLa];
    
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 198, WIDTH - 20, 86)];
    dataView.backgroundColor = TCUIColorFromRGB(0xffffff);
    dataView.layer.masksToBounds = YES;
    dataView.layer.cornerRadius = 10;
    [self.view addSubview:dataView];
    
    CGFloat wid = (WIDTH - 20)/2;
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 0, wid, 86)];
        [dataView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        lab.frame = CGRectMake(0, 21, wid, 21);
        [view addSubview:lab];
        
        UILabel *titleLa = [UILabel publicLab:@"可提现(JPY)" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        [view addSubview:titleLa];
        
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo((wid - 80)/2);
                    make.top.mas_equalTo(49);
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(11);
        }];
        
        if(i == 0){
            lab.text = self.memberInfo.YongBalance;
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundImage:[UIImage imageNamed:@"withdraw_bg"] forState:(UIControlStateNormal)];
            [btn setTitle:@"提现" forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(clickWithDraw) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(titleLa.mas_right).offset(2);
                            make.top.mas_equalTo(48);
                            make.width.mas_equalTo(34);
                            make.height.mas_equalTo(14);
            }];
        }else{
            lab.text = self.memberInfo.YongReady;
            titleLa.text = @"待入账(JPY)";
            [titleLa mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerX.mas_equalTo(view);
                            make.top.mas_equalTo(49);
                            make.width.mas_equalTo(wid);
                            make.height.mas_equalTo(11);
            }];
        }
    }
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(dataView.frame) + 12, WIDTH - 20, HEIGHT - CGRectGetMaxY(dataView.frame) - TabbarSafeBottomMargin - 20)];
    bottomView.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 4;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel *lab = [UILabel publicLab:@"佣金变动明细" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    lab.frame = CGRectMake(10, 18, 120, 17);
    [bottomView addSubview:lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 47, WIDTH - 36, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [bottomView addSubview:line];
    
    [bottomView addSubview:self.mainTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMCommissionCell *cell = [[MMCommissionCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    
    return  cell;
}

-(void)clickWithDraw{
    [ZTProgressHUD showMessage:@"去提现"];
}

-(void)clickDetail{
    MMCommissionDetailVC *detailVC = [[MMCommissionDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [TalkingDataSDK onPageEnd:@"我的佣金页面"];
}
@end
