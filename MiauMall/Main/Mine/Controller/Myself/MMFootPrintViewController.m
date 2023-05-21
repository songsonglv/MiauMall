//
//  MMFootPrintViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import "MMFootPrintViewController.h"
#import "MMFootOrCollectGoodsModel.h"
#import "MMMyCollectionCell.h"
#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

@interface MMFootPrintViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMTitleView *titleView;

@property (nonatomic, strong) NSMutableArray *seleArr;//选择的数组
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *allBt;

@property (nonatomic, strong) NSString *isselect; //是否编辑 0 1
@property (nonatomic, strong) NSString *isallselect; //是否全选 0 1

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

@property (nonatomic, strong) UITabBarItem *cartabBarItem;

@end

@implementation MMFootPrintViewController

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
        CGFloat hei = self.dataArr.count * 128 + 20;
        if(hei < HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin){
            _mainTableView.height = hei + 20;
        }
        
        if(self.dataArr.count == 0){
            self.mainTableView.height = 0;
        }
        _mainTableView.layer.masksToBounds = YES;
        _mainTableView.layer.cornerRadius = 10;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.allowsMultipleSelection = NO;
        _mainTableView.allowsSelectionDuringEditing = NO;
        _mainTableView.allowsMultipleSelectionDuringEditing = NO;

    }
    return _mainTableView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(NSMutableArray *)goodsSpecArr{
    if(!_goodsSpecArr){
        _goodsSpecArr = [NSMutableArray array];
    }
    return _goodsSpecArr;
}

-(NSMutableArray *)goodsSpecShowArr{
    if(!_goodsSpecShowArr){
        _goodsSpecShowArr = [NSMutableArray array];
    }
    return _goodsSpecShowArr;
}

-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
        _bottomView.backgroundColor = TCUIColorFromRGB(0xffffff);
        UIButton *allBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 16, 16)];
        [allBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [allBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [allBt setEnlargeEdgeWithTop:10 right:30 bottom:10 left:10];
        [allBt addTarget:self action:@selector(clickAll:) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomView addSubview:allBt];
        self.allBt = allBt;
        
        UILabel *allLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"allSelect"] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        allLa.frame = CGRectMake(31, 17, 150, 14);
        [_bottomView addSubview:allLa];
        
        
        UIButton *deleteBt = [[UIButton alloc]init];
        [deleteBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
        [deleteBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [deleteBt setBackgroundColor:redColor2];
        deleteBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        deleteBt.layer.masksToBounds = YES;
        deleteBt.layer.cornerRadius = 15;
        deleteBt.layer.borderColor = TCUIColorFromRGB(0x676767).CGColor;
        deleteBt.layer.borderWidth = 0.5;
        [deleteBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomView addSubview:deleteBt];
        
        [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-18);
                    make.top.mas_equalTo(9);
                    make.width.mas_equalTo(74);
                    make.height.mas_equalTo(30);
        }];
        
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //禁止返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [TalkingDataSDK onPageBegin:@"我的足迹页面"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.isselect = @"0";
    self.isallselect = @"0";
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"myFootprint"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    UIButton *editBt = [[UIButton alloc]init];
    editBt.selected = NO;
    [editBt setTitle:[UserDefaultLocationDic valueForKey:@"iedit"] forState:(UIControlStateNormal)];
    [editBt setTitle:[UserDefaultLocationDic valueForKey:@"icomplete"] forState:(UIControlStateSelected)];
    [editBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    editBt.titleLabel.font = [UIFont systemFontOfSize:13];
    editBt.frame = CGRectMake(WIDTH - 118, 20, 100, 13);
    editBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    editBt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [editBt addTarget:self action:@selector(clickEdit:) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:editBt];
   
//    self.skuPopView.addCarBlock = ^(NSString * _Nonnull str) {
//        [weakself requestAddCar];
//    };
//
//    self.skuPopView.buyNowBlock = ^(NSString * _Nonnull str) {
//        [weakself requestBuyNow];
//    };
    
    [self GetCollectList];
    [ZTProgressHUD showLoadingWithMessage:@""];
    // Do any additional setup after loading the view.
    
}

-(void)setUI{
    [ZTProgressHUD hide];
    [self.view addSubview:self.mainTableView];
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
}

#pragma mark -- uitableviewdelete
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMMyCollectionCell*cell = [[MMMyCollectionCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model1 = self.dataArr[indexPath.section];
        cell.isselect = self.isselect;
        
        cell.addSelectBlock = ^(NSString * _Nonnull ID) {
            [weakself addToSelectArr:ID];
        };
        cell.deleteSelectBlock = ^(NSString * _Nonnull ID) {
            [weakself subToSelectArr:ID];
        };
        cell.tapCarBlock = ^(NSString * _Nonnull ID) {
            weakself.goodsId = ID;
            [weakself GetProductBuyTest:ID];
        };
        
        if([self.isallselect isEqualToString:@"1"]){
            cell.selectBt.selected = YES;
        }else if([self.isallselect isEqualToString:@"0"]){
            cell.selectBt.selected = NO;
        }
        
    }
    
    return cell;
}

#pragma mark -- 左滑设置

// 是否允许对cell进行滑动操作
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
          // 删除
          return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
          return @"删除";
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    KweakSelf(self);
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        MMFootOrCollectGoodsModel *model = self.dataArr[indexPath.section];
        [weakself deleGoodsCollection:model.RecID];
    }];
    deleteRowAction.title = [UserDefaultLocationDic valueForKey:@"idelete"];
    deleteRowAction.backgroundColor = [UIColor redColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[ deleteRowAction]];
    return config;
}

// 实现左滑按钮的核心代码
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    MMFootOrCollectGoodsModel *model = self.dataArr[indexPath.section];
    [weakself deleGoodsCollection:model.RecID];
}];
return @[deleteAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMCollectionModel *model = self.dataArr[indexPath.row];
    [self RouteJump:model.Url];
}

-(void)GetCollectList{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBrowseRecord"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry,@"cur":@"1",@"limit":@"99"};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMFootOrCollectGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            if(arr.count > 0){
                weakself.titleView.titleLa.text = [NSString stringWithFormat:@"%@（%ld）",[UserDefaultLocationDic valueForKey:@"myFootprint"],arr.count];
            }else{
                weakself.titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"myFootprint"];
            }
            
           
        }
        [weakself setUI];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refreshData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBrowseRecord"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"cur":@"1",@"limit":@"99"};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.dataArr removeAllObjects];
            NSArray *arr = [MMFootOrCollectGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
            if(weakself.dataArr.count > 0){
                weakself.titleView.titleLa.text = [NSString stringWithFormat:@"%@（%ld）",[UserDefaultLocationDic valueForKey:@"myFootprint"],arr.count];
                CGFloat hei = weakself.dataArr.count * 128 + 20;
                if(hei < HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin){
                    weakself.mainTableView.height = hei + 20;
                }
            }else{
                weakself.mainTableView.height = 0;
                weakself.titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"myFootprint"];
            }
           
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 编辑
-(void)clickEdit:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.isselect = @"1";
        self.bottomView.hidden = NO;
    }else{
        self.isselect = @"0";
        self.bottomView.hidden = YES;;
    }
    [self.mainTableView reloadData];
    
}

-(void)addToSelectArr:(NSString *)ID{
    [self.seleArr addObject:ID];
    if(self.seleArr.count == self.dataArr.count){
        self.allBt.selected = YES;
    }else{
        self.allBt.selected = NO;
    }
}

-(void)subToSelectArr:(NSString *)ID{
    [self.seleArr removeObject:ID];
    if(self.seleArr.count == self.dataArr.count){
    }else{
        self.allBt.selected = NO;
    }
}

//点击全选
-(void)selectAll{
    [self.seleArr removeAllObjects];
    for (MMCollectionModel *model in self.dataArr) {
        [self.seleArr addObject:model.ID];
    }
}

//取消全选
-(void)cancleAll{
    [self.seleArr removeAllObjects];
}

-(void)clickAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.isallselect = @"1";
        [self selectAll];
    }else{
        self.isallselect = @"0";
        [self cancleAll];
    }
    [self.mainTableView reloadData];
}

-(void)deleGoodsCollection:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"BrowseRecordDel"];
    NSDictionary *param = @{@"id":ID,@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        [weakself refreshData];
    
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickDelete{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"BrowseRecordDel"];
    NSString *idStr = [self.seleArr componentsJoinedByString:@","];
    NSDictionary *param = @{@"id":idStr,@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.seleArr removeAllObjects];
            [weakself refreshData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    NSLog(@"%@",param);
}

#pragma mark -- 请求规格数据
-(void)GetProductBuyTest:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBuyTest"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"id":ID,@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.goodsSpecInfo = [MMGoodsSpecModel mj_objectWithKeyValues:jsonDic];
            weakself.attid = weakself.goodsSpecInfo.attbuying.attid;
            weakself.skuPopView = [[MMSelectSKUPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:weakself.goodsSpecInfo];
        
            self.skuPopView.SkuAndNumBlock = ^(MMGoodsAttdataModel * _Nonnull model, NSString * _Nonnull numStr) {
                weakself.attid = model.ID;
                weakself.numStr = numStr;
            };
            self.skuPopView.addCarBlock = ^(NSString * _Nonnull str) {
                [weakself requestAddCar];
            };
            
            self.skuPopView.buyNowBlock = ^(NSString * _Nonnull str) {
                [weakself requestBuyNow];
            };
            weakself.skuPopView.type = @"0";
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.skuPopView];
            [weakself.skuPopView showView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 后面请求的接口
-(void)requestAddCar{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
   // [param setValue:@"CartPlus" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.goodsId forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:@"1" forKey:@"back"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMShopCarModel *model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.cartabBarItem.badgeValue = model.num;
            if([model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)requestBuyNow{
    [ZTProgressHUD showMessage:@"跳转到生成订单页面"];
}

//路由跳转
-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"我的足迹页面"];
}
@end
