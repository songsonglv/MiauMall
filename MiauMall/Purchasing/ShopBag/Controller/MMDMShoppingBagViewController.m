//
//  MMDMShoppingBagViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//

#import "MMDMShoppingBagViewController.h"
#import "MMDMShopCartGoodsModel.h"
#import "MMDMShopCartModel.h"
#import "MMDMSeriverModel.h"
#import "MMDMShopCartGoodsCell.h"
#import "MMDMShopCartTipsView.h"
#import "MMDMShopCartMoneyView.h"
#import "MMDMShopCartEditView.h"
#import "MMDMOrderConfirmationVC.h"
#import "MMDMSelectServicePopview.h"

@interface MMDMShoppingBagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *serviceArr;//服务数组
@property (nonatomic, strong) NSMutableArray *dataArr;//商品数组
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) MMDMShopCartModel *model;
@property (nonatomic, strong) MMDMShopCartMoneyView *moneyView;
@property (nonatomic, strong) MMDMShopCartTipsView *tipsView;
@property (nonatomic, strong) MMDMShopCartEditView *editView;
@property (nonatomic, strong) MMDMSelectServicePopview *servicePopView;
@property (nonatomic, strong) MMDMShopCartGoodsModel *seleGoodsModel;
@property (nonatomic, strong) NSMutableArray *allArr;

@property (nonatomic, strong) NSMutableArray *seleArr;//选中的商品数组 
@end

@implementation MMDMShoppingBagViewController

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

-(MMDMShopCartEditView *)editView{
    KweakSelf(self);
    if(!_editView){
        _editView = [[MMDMShopCartEditView alloc]initWithFrame:CGRectMake(0, HEIGHT - 82 - 54, WIDTH, 54)];
        _editView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _editView.model = self.model;
        _editView.tapSeleBlock = ^(NSString * _Nonnull str) {
            [weakself allSelect:str];
        };
        
        
        
        _editView.tapDeleBlock = ^(NSString * _Nonnull str) {
            [weakself CartDel];
        };
    }
    return _editView;
}

-(MMDMShopCartMoneyView *)moneyView{
    if(!_moneyView){
        KweakSelf(self);
        _moneyView = [[MMDMShopCartMoneyView alloc]initWithFrame:CGRectMake(0, HEIGHT - 120 - TabbarHeight, WIDTH, 120)];
        _moneyView.hidden = YES;
        _moneyView.tapSeleBlock = ^(NSString * _Nonnull str) {
            [weakself allSelect:str];
        };
        _moneyView.tapOrderBlock = ^(NSString * _Nonnull str) {
            [weakself orderConfirmation];
        };
    }
    return _moneyView;
}

-(MMDMShopCartTipsView *)tipsView{
    if(!_tipsView){
        _tipsView = [[MMDMShopCartTipsView alloc]initWithFrame:CGRectMake(0, HEIGHT - 162 - TabbarHeight, WIDTH, 42)];
        _tipsView.hidden = YES;
    }
    return _tipsView;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 54, WIDTH - 20, HEIGHT - TabbarHeight - StatusBarHeight - 54) style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}


-(NSMutableArray *)serviceArr{
    if(!_serviceArr){
        _serviceArr = [NSMutableArray array];
    }
    return _serviceArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买购物袋"];
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 54)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"myCart"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
//    lab.preferredMaxLayoutWidth = 200;
//    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topV addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((WIDTH - 200)/2);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(StatusBarHeight + 19);
        make.height.mas_equalTo(16);
    }];
    
    UIButton *editBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 58, StatusBarHeight + 20, 58, 13)];
    [editBt setTitle:[UserDefaultLocationDic valueForKey:@"iedit"] forState:(UIControlStateNormal)];
    [editBt setTitle:[UserDefaultLocationDic valueForKey:@"icomplete"] forState:(UIControlStateSelected)];
    [editBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    editBt.selected = NO;
    editBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBt addTarget:self action:@selector(clickEdit:) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:editBt];
    
    self.servicePopView = [[MMDMSelectServicePopview alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.servicePopView.selectServiceBlock = ^(MMDMSeriverModel * _Nonnull model) {
        [weakself CartUpdate:weakself.seleGoodsModel andNum:weakself.seleGoodsModel.num andService:model.ID];
    };
//    [self.view addSubview:self.servicePopView];
    
    [self setUI];
    
//    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartList1"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"carttype"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        MMDMShopCartModel *model = [MMDMShopCartModel mj_objectWithKeyValues:jsonDic[@"key"][@"othershopcart"]];
        weakself.model = model;
        
        [weakself.dataArr removeAllObjects];
        for (NSArray *arr in model.newitem) {
            NSArray *arr1 = [MMDMShopCartGoodsModel mj_objectArrayWithKeyValuesArray:arr];
            [weakself.dataArr addObject:arr1];
        }
        
        NSArray *serArr = [MMDMSeriverModel mj_objectArrayWithKeyValuesArray:weakself.model.Distributions];
        weakself.serviceArr = [NSMutableArray arrayWithArray:serArr];
        weakself.tipsView.tips = model.NormalTips;
        weakself.moneyView.model = model;
        weakself.editView.model = model;
        
        NSArray *modelArr = [MMDMShopCartGoodsModel mj_objectArrayWithKeyValuesArray:weakself.model.item];
        for (MMDMShopCartGoodsModel *model in modelArr) {
            if([model.buy isEqualToString:@"1"]){
                [weakself.seleArr addObject:model];
            }
        }
        
        weakself.cartabBarItem.badgeValue = weakself.model.num;;
        if([weakself.model.num isEqualToString:@"0"]){
            weakself.cartabBarItem.badgeValue = nil;
        }
        
        [weakself.mainTableView reloadData];
        
        if(self.dataArr.count == 0){
            weakself.tipsView.hidden = YES;
            weakself.moneyView.hidden = YES;
        }else{
            weakself.tipsView.hidden = NO;
            weakself.moneyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.moneyView];
    
    self.editView.hidden = YES;
    [self.view addSubview:self.editView];
    
    [self setNoneData];
}

-(void)setNoneData{
    KweakSelf(self);
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"dm_shopcar_none"
                                                                 titleStr:@"您的购物车暂无商品"
                                                                detailStr:@"再忙，也要记得犒劳下自己哦~"
                                                              btnTitleStr:@"去逛逛"
                                                            btnClickBlock:^(){
        [weakself goHome];
        }];
    emptyView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    emptyView.contentViewY = 108;
    emptyView.titleLabMargin = 23.f;
    emptyView.titleLabFont = [UIFont systemFontOfSize:14];
    emptyView.titleLabTextColor = TCUIColorFromRGB(0x555555);
    emptyView.subViewMargin = 10.f;
    emptyView.detailLabFont = [UIFont systemFontOfSize:13];
    emptyView.detailLabTextColor = TCUIColorFromRGB(0x999999);
    emptyView.actionBtnMargin = 52;
    emptyView.actionBtnWidth = 120;
    emptyView.actionBtnFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    emptyView.actionBtnHeight = 36.f;
    emptyView.actionBtnBorderColor = TCUIColorFromRGB(0x999999);
    emptyView.actionBtnCornerRadius = 18;
    emptyView.actionBtnTitleColor = TCUIColorFromRGB(0xffffff);
    emptyView.actionBtnBackGroundColor = redColor3;
    self.mainTableView.ly_emptyView = emptyView;
}

#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.dataArr.count - 1){
        return 225;
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 56)];
    view.backgroundColor = UIColor.clearColor;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 12, WIDTH - 20, 44)];
    view1.backgroundColor = UIColor.whiteColor;
    [self setCircular:view1 andCir1:(UIRectCornerTopLeft) andCir2:(UIRectCornerTopRight)];
    [view addSubview:view1];
    
    NSArray *arr = self.dataArr[section];
    MMDMShopCartGoodsModel *model = arr[0];
    UILabel *lab = [UILabel publicLab:model.site textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    lab.frame = CGRectMake(33, 17, WIDTH - 65, 15);
    [view1 addSubview:lab];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 5)];
    view.backgroundColor = UIColor.whiteColor;
    [self setCircular:view andCir1:(UIRectCornerBottomLeft) andCir2:(UIRectCornerBottomRight)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMDMShopCartGoodsCell*cell = [[MMDMShopCartGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.dataArr[indexPath.section];
    if (arr.count > 0) {
        cell.model = arr[indexPath.row];
        cell.tapUpdateBlock = ^(MMDMShopCartGoodsModel * _Nonnull model, NSString * _Nonnull num) {
            [weakself CartUpdate:model andNum:num andService:nil];
        };
       
        cell.tapServiceBlock = ^(MMDMShopCartGoodsModel * _Nonnull model) {
            weakself.seleGoodsModel = model;
            weakself.servicePopView.tipsArr = weakself.model.Distributions;
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.servicePopView];
            [weakself.servicePopView showView];
        };
        
        cell.tapSubBlock = ^(NSString * _Nonnull num, MMDMShopCartGoodsModel * _Nonnull model) {
            [weakself CartLess:model];
        };
        cell.tapAddBlock = ^(NSString * _Nonnull num, MMDMShopCartGoodsModel * _Nonnull model) {
            [weakself CartPlus:model];
        };
        
        cell.tapDeleteBlock = ^(MMDMShopCartGoodsModel * _Nonnull model) {
            [weakself CartLess:model];
        };
        
        cell.tapSeleBlock = ^(MMDMShopCartGoodsModel * _Nonnull model, NSString * _Nonnull isBuy) {
            [weakself CartSelect:model andIsbuy:isBuy];
        };
        
    }
    if(indexPath.row == arr.count - 1){
        cell.line.hidden = YES;
    }
    
    
    return cell;
}

//删除弹窗
-(void)clickShow:(MMDMShopCartGoodsModel *)model{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:[UserDefaultLocationDic valueForKey:@"delPro"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself CartLess:model];
    }]];
    
    
    
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -- 左滑操作
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        NSArray *arr = self.dataArr[indexPath.section];
        MMDMShopCartGoodsModel *model = arr[indexPath.row];
        [weakself clickShow:model];
    }];
    deleteRowAction.title = [UserDefaultLocationDic valueForKey:@"idelete"];
    deleteRowAction.backgroundColor = redColor2;
    [deleteRowAction setImage:[UIImage imageNamed:@"delete_icon_white"]];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[ deleteRowAction]];
    return config;
}

-(void)clickEdit:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.editView.hidden = NO;
        self.tipsView.hidden = YES;
        self.moneyView.hidden = YES;
       
    }else{
        self.tipsView.hidden = NO;
        self.moneyView.hidden = NO;
        self.editView.hidden = YES;
    }
}

#pragma mark -- 对购物车的一些操作接口
//全选
-(void)allSelect:(NSString *)sele{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartSelect"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"back":@"1",@"tempcart":self.tempcart,@"id":@"0",@"attid":@"0",@"isbuy":sele,@"carttype":@"1"};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    [self requestUrl:url andParam:param];
}

//➖和删除一样 当num为1时就是删除
-(void)CartLess:(MMDMShopCartGoodsModel *)model{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartLess"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"guid":model.guid,@"back":@"1",@"carttype":@"1"};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
}

//更新购物车。更新数量或者服务
-(void)CartUpdate:(MMDMShopCartGoodsModel *)model andNum:(NSString *)num andService:(NSString *)serviceID{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartUpdate"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"guid":model.guid,@"back":@"1",@"carttype":@"1",};
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(num){
        [param setValue:num forKey:@"num"];
    }
    
    if(serviceID){
        [param setValue:serviceID forKey:@"sureid"];
    }
    [self requestUrl:url andParam:param];
}

//删除
-(void)CartDel{
    if(self.seleArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"selePro"]];
    }else{
        NSMutableArray *idArr = [NSMutableArray array];
        NSMutableArray *attidArr = [NSMutableArray array];
        for (MMDMShopCartGoodsModel *model in self.seleArr) {
            [idArr addObject:model.guid];
        }
        
        NSString *ids = [idArr componentsJoinedByString:@","];
        NSString *attids = [attidArr componentsJoinedByString:@","];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartDel"];
        NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"guid":ids,@"back":@"1",@"carttype":@"1"};
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"memberToken"];
        }
        [self requestUrl:url andParam:param];
    }
}

//➕
-(void)CartPlus:(MMDMShopCartGoodsModel *)model{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"guid":model.guid,@"back":@"1",@"carttype":@"1"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
    
}

//选中 or 未选中
-(void)CartSelect:(MMDMShopCartGoodsModel *)model andIsbuy:(NSString *)isbuy{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartSelect"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"tempcart":self.tempcart,@"guid":model.guid,@"back":@"1",@"isbuy":isbuy,@"carttype":@"1"};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [self requestUrl:url andParam:param];
}
     

//网络请求后半部分
-(void)requestUrl:(NSString *)url andParam:(NSDictionary *)param{
    KweakSelf(self);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *msg= [NSString stringWithFormat:@"%@",jsonDic[@"msg"]];
        if([msg isEqualToString:@""]){
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
       
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            weakself.model = [MMDMShopCartModel mj_objectWithKeyValues:jsonDic[@"key"][@"othershopcart"]];
            weakself.moneyView.model = weakself.model;
            weakself.editView.model = weakself.model;
           
            NSArray *arr = weakself.model.newitem;
            weakself.allArr = [NSMutableArray arrayWithArray:arr];
           
            weakself.cartabBarItem.badgeValue = weakself.model.num;;
            if([weakself.model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
            NSMutableArray *allNumArr = [NSMutableArray array];
            for (NSArray *arr1 in arr) {
                [allNumArr addObjectsFromArray:arr1];
            }
            NSArray *modelArr = [MMDMShopCartGoodsModel mj_objectArrayWithKeyValuesArray:allNumArr];
            [weakself.seleArr removeAllObjects];
            for (MMDMShopCartGoodsModel *model in modelArr) {
                if([model.buy isEqualToString:@"1"]){
                    [weakself.seleArr addObject:model];
                }
            }
            
            for (NSArray *arr in  weakself.model.newitem) {
                NSArray *arr1 = [MMDMShopCartGoodsModel mj_objectArrayWithKeyValuesArray:arr];
                [weakself.dataArr addObject:arr1];
            }
            
            [weakself.mainTableView reloadData];
            if(self.dataArr.count == 0){
                weakself.tipsView.hidden = YES;
                weakself.moneyView.hidden = YES;
            }else{
                weakself.tipsView.hidden = NO;
                weakself.moneyView.hidden = NO;
            }

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)orderConfirmation{
    MMDMOrderConfirmationVC *orderConfirmVC = [MMDMOrderConfirmationVC alloc];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买购物袋"];
}


///设置圆角[左上、右上角]

- (void)setCircular:(UIView *)view andCir1:(UIRectCorner)cir1 andCir2:(UIRectCorner)cir2{

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cir1 | cir2 cornerRadii:CGSizeMake(7.5,7.5)];

//创建 layer
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = view.bounds;
//赋值
maskLayer.path = maskPath.CGPath;
view.layer.mask = maskLayer;
}
@end
