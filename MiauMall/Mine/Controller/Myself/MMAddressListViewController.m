//
//  MMAddressListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import "MMAddressListViewController.h"
#import "MMAddressModel.h"
#import "MMAddressListCell.h"
#import "MMAddShippingAddressVC.h"

@interface MMAddressListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSDictionary *defaultAddress;
@end

@implementation MMAddressListViewController

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"地址列表页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addAddressSuccess" object:nil];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"收货地址";
    titleView.line.hidden = NO;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self.view addSubview:self.mainTableView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(18, HEIGHT - 114, WIDTH - 36, 44)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [btn setBackgroundColor:TCUIColorFromRGB(0xd64f3e)];
    [btn setTitle:@"添加新地址" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    [self requestData];
    
    [self setNoneData];
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    [self requestData];
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAddressList"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"list"];
            NSArray *addressArr = [MMAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:addressArr];
            [weakself.mainTableView reloadData];
            for (int i = 0; i < arr.count; i++) {
                MMAddressModel *model = weakself.dataArr[i];
                if([model.IsDefault isEqualToString:@"1"]){
                    weakself.defaultAddress = arr[i];
                    NSData *resultData = [NSJSONSerialization dataWithJSONObject:weakself.defaultAddress options:NSJSONWritingPrettyPrinted error:nil];
                    [resultData writeToFile:UserDefaultsAddressPath atomically:YES];
                }
            }
            
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setNoneData{
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"zhanweif"
                                                                 titleStr:@""
                                                                detailStr:@"您还没添加收货地址！"
                                                              btnTitleStr:@""
                                                            btnClickBlock:^(){
            
        }];
    emptyView.contentViewY = 100;
    emptyView.subViewMargin = 9.f;
    emptyView.detailLabFont = [UIFont systemFontOfSize:12];
    emptyView.detailLabTextColor = TCUIColorFromRGB(0x999999);
    
    self.mainTableView.ly_emptyView = emptyView;
}

#pragma mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMAddressListCell *cell = [[MMAddressListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.clickDeleteBlock = ^(NSString * _Nonnull addressID) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"确定删除吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [action setValue:redColor2 forKey:@"titleTextColor"];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [action setValue:selectColor forKey:@"titleTextColor"];
            [weakself clickDele:addressID];
        }]];
        
        

        [self presentViewController:alert animated:true completion:nil];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMAddressModel *model = self.dataArr[indexPath.row];
    if([self.isEnter isEqualToString:@"0"]){
        self.returnAddressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        MMAddShippingAddressVC *addVC = [[MMAddShippingAddressVC alloc]init];
        addVC.model = model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
    
    
}

-(void)clickDele:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AddressDel"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        if([code isEqualToString:@"1"]){
            [weakself requestData];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)clickAdd{
    MMAddShippingAddressVC *addVC = [[MMAddShippingAddressVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}


-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"地址列表页面"];
}
@end
