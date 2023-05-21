//
//  MMPartnerAccountVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//  合伙人--我的账户

#import "MMPartnerAccountVC.h"
#import "MMPartnerAccountModel.h"
#import "MMPartnerAccountCell.h"
#import "MMPartnerAddAccountVC.h"
#import "MMEditAccountModel.h"


@interface MMPartnerAccountVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家



@end

@implementation MMPartnerAccountVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 54, WIDTH - 20, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 54) style:(UITableViewStylePlain)];
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
    [TalkingDataSDK onPageBegin:@"提现账户页面"];
    if(self.mainTableView){
        [self requestData];
    }
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"myAccount"];
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
    // Do any additional setup after loading the view.
}



-(void)setUI{
    [self.view addSubview:self.mainTableView];
    
    UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT - 116 - 60, WIDTH - 20, 60)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [addBt setBackgroundImage:[UIImage imageNamed:@"add_account_bg"] forState:(UIControlStateNormal)];
    [addBt setTitle:[UserDefaultLocationDic valueForKey:@"addAccount"] forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [addBt setImage:[UIImage imageNamed:@"add_icon"] forState:(UIControlStateNormal)];
    [addBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:5];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBt];
    
    [self requestData];
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyAccountList"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMPartnerAccountModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr removeAllObjects];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
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
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMPartnerAccountCell *cell = [[MMPartnerAccountCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.clickEdit = ^(NSString * _Nonnull ID) {
        [weakself editID:ID];
    };
    cell.clickDelete = ^(NSString * _Nonnull ID) {
        [weakself deleteID:ID];
    };
    
    return cell;
}

-(void)editID:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMyAccountByID"];
    [param setValue:ID forKey:@"ID"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMEditAccountModel *model = [MMEditAccountModel mj_objectWithKeyValues:jsonDic];
            [weakself jumpEditVC:model];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)jumpEditVC:(MMEditAccountModel *)model{
    MMPartnerAddAccountVC *addVC = [[MMPartnerAddAccountVC alloc]init];
    addVC.titleStr = @"修改账户";
    addVC.model = model;
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)deleteID:(NSString *)ID{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:@"确认此账户删除吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself deleteAccount:ID];
    }]];
    
    

    [self presentViewController:alert animated:true completion:nil];
}

-(void)deleteAccount:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"DeleteMyAccount"];
    [param setValue:ID forKey:@"ID"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        [weakself requestData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickAdd{
    MMPartnerAddAccountVC *addVC = [[MMPartnerAddAccountVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"提现账户页面"];
}

@end
