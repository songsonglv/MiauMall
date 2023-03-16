//
//  MMRankListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/10.
//

#import "MMRankListViewController.h"
#import "MMHotRankModel.h"
#import "MMRankListCell.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"


@interface MMRankListViewController ()<HGCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *allDataArr;
@property (nonatomic, strong) HGCategoryView *categoryView;

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

@implementation MMRankListViewController

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 120, WIDTH, HEIGHT - TabbarSafeBottomMargin - 120 - StatusBarHeight) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(HGCategoryView *)categoryView{
    if(!_categoryView){
        _categoryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 54, WIDTH, 65)];
        _categoryView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _categoryView.delegate = self;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.allDataArr.count; i++) {
            MMHotRankModel *model = self.allDataArr[i];
            [arr addObject:model.Name];
        }
        _categoryView.titles = arr;
        _categoryView.alignment = HGCategoryViewAlignmentCenter;
        _categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleNormalColor = TCUIColorFromRGB(0x383838);
        _categoryView.titleSelectedColor = TCUIColorFromRGB(0x383838);
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
        _categoryView.vernier.backgroundColor = TCUIColorFromRGB(0x383838);
        _categoryView.itemSpacing = 24;
        _categoryView.topBorder.hidden = YES;
        _categoryView.bottomBorder.hidden = YES;
        _categoryView.vernier.height = 2.0f;
        _categoryView.vernierWidth = 18;
    }
    return _categoryView;
}

-(NSMutableArray *)allDataArr{
    if(!_allDataArr){
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
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
    [TalkingDataSDK onPageBegin:@"排行榜页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
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
    titleView.titleLa.text = @"排行榜";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self GetRankList];
    // Do any additional setup after loading the view.
}

-(void)GetRankList{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRankList"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.ID){
        [param setValue:self.ID forKey:@"pid"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"pid"];
    }
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHotRankModel mj_objectArrayWithKeyValuesArray:jsonDic[@"ranklist"]];
            weakself.allDataArr = [NSMutableArray arrayWithArray:arr];
            MMHotRankModel *model = weakself.allDataArr[0];
            if(model.num0){
                [weakself.dataArr addObject:model.num0];
            }
            if(model.num1){
                [weakself.dataArr addObject:model.num1];
            }
            if(model.num2){
                [weakself.dataArr addObject:model.num2];
            }
            if(model.num3){
                [weakself.dataArr addObject:model.num3];
            }
            if(model.num4){
                [weakself.dataArr addObject:model.num4];
            }
            if(model.num5){
                [weakself.dataArr addObject:model.num5];
            }
            if(model.num6){
                [weakself.dataArr addObject:model.num6];
            }
            if(model.num7){
                [weakself.dataArr addObject:model.num7];
            }
            if(model.num8){
                [weakself.dataArr addObject:model.num8];
            }
            if(model.num9){
                [weakself.dataArr addObject:model.num9];
            }
            if(model.num10){
                [weakself.dataArr addObject:model.num10];
            }
            
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.mainTableView];
}


#pragma mark -- tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMRankListCell*cell = [[MMRankListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
        cell.index = indexPath.row + 1;
        cell.tapCarBlock = ^(NSString * _Nonnull ID) {
            weakself.goodsId = ID;
            [weakself GetProductBuyTest:ID];
        };
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMHotGoodsModel *model = self.dataArr[indexPath.row];
    MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- categarydelegate
-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    KweakSelf(self);
    MMHotRankModel *model = self.allDataArr[index];
    [self.dataArr removeAllObjects];
    if(model.num0){
        [weakself.dataArr addObject:model.num0];
    }
    if(model.num1){
        [weakself.dataArr addObject:model.num1];
    }
    if(model.num2){
        [weakself.dataArr addObject:model.num2];
    }
    if(model.num3){
        [weakself.dataArr addObject:model.num3];
    }
    if(model.num4){
        [weakself.dataArr addObject:model.num4];
    }
    if(model.num5){
        [weakself.dataArr addObject:model.num5];
    }
    if(model.num6){
        [weakself.dataArr addObject:model.num6];
    }
    if(model.num7){
        [weakself.dataArr addObject:model.num7];
    }
    if(model.num8){
        [weakself.dataArr addObject:model.num8];
    }
    if(model.num9){
        [weakself.dataArr addObject:model.num9];
    }
    if(model.num10){
        [weakself.dataArr addObject:model.num10];
    }
    
    [self.mainTableView reloadData];
    
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
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"FastAdd"];
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
            MMConfirmOrderViewController *confirmVC = [[MMConfirmOrderViewController alloc]init];
            [weakself.navigationController pushViewController:confirmVC animated:YES];
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
    [TalkingDataSDK onPageEnd:@"排行榜页面"];
}

@end
