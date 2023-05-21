//
//  MMGoodHotListVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/10.
//  分类热销榜单

#import "MMGoodHotListVC.h"
#import "MMHotGoodsModel.h"
#import "MMHotRankModel.h"
#import "MMHotGoodsCell.h"
#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

@interface MMGoodHotListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMHotRankModel *model;
@property (nonatomic, strong) NSMutableArray *dataArr;

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

@implementation MMGoodHotListVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor colorWithWzxString:self.model.BackColor];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"热推榜单页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRank"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"id"];
    }
    
    [ZTProgressHUD showLoadingWithMessage:@""];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMHotRankModel mj_objectWithKeyValues:jsonDic];
            if(weakself.model.num0){
                [weakself.dataArr addObject:weakself.model.num0];
            }
            if(weakself.model.num1){
                [weakself.dataArr addObject:weakself.model.num1];
            }
            if(weakself.model.num2){
                [weakself.dataArr addObject:weakself.model.num2];
            }
            if(weakself.model.num3){
                [weakself.dataArr addObject:weakself.model.num3];
            }
            if(weakself.model.num4){
                [weakself.dataArr addObject:weakself.model.num4];
            }
            if(weakself.model.num5){
                [weakself.dataArr addObject:weakself.model.num5];
            }
            if(weakself.model.num6){
                [weakself.dataArr addObject:weakself.model.num6];
            }
            if(weakself.model.num7){
                [weakself.dataArr addObject:weakself.model.num7];
            }
            if(weakself.model.num8){
                [weakself.dataArr addObject:weakself.model.num8];
            }
            if(weakself.model.num9){
                [weakself.dataArr addObject:weakself.model.num9];
            }
            if(weakself.model.num10){
                [weakself.dataArr addObject:weakself.model.num10];
            }
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    self.view.backgroundColor = [UIColor colorWithWzxString:self.model.BackColor];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.model.BackPicture] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(13, 16, 10, 20)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [bgImage addSubview:returnBt];
    
   
    
    UIButton *shareBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 36, 16, 22, 22)];
    [shareBt setImage:[UIImage imageNamed:@"share_icon_white"] forState:(UIControlStateNormal)];
    [shareBt addTarget:self action:@selector(clickShare) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:shareBt];
    
    self.mainTableView.tableHeaderView = bgImage;
    [self.view addSubview:self.mainTableView];
}

#pragma mark -- uitableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHotGoodsCell*cell = [[MMHotGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.colorStr = self.model.BackColor;
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
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


-(void)clickShare{
    [ZTProgressHUD showMessage:@"分享"];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"热推榜单页面"];
}

@end
