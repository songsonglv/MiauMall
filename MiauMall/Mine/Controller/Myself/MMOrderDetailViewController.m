//
//  MMOrderDetailViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import "MMOrderDetailViewController.h"
#import "MMOrderDetailInfoModel.h"
#import "MMOrderDetailAddressView.h"
#import "MMOrderDetailGoodsView.h"
#import "MMMoneyInfoView.h"
#import "MMOrderProcessView.h"
#import "MMOrderDetailTrackModel.h"
#import "MMOrderDetailInfoView.h"
#import "MMOrderChangeAddressVC.h"
#import "MMOrderRemindPopView.h"
#import "MMOrderAfterSalesTipPopView.h"
#import "MMOrderAfterSalesVC.h"
#import "MMMyAssessViewControllerView.h"
#import "MMLogisticsInfomoationVC.h"

#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMSelectSKUPopView.h"

#import "MMPayResultModel.h"
#import "MMPayViewController.h"

@interface MMOrderDetailViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMOrderDetailInfoModel *model;

@property (nonatomic, strong) MMOrderDetailAddressView *addressView;

@property (nonatomic, strong) MMOrderDetailGoodsView *goodsView;
@property (nonatomic, strong) MMMoneyInfoView *moneyInfoView;
@property (nonatomic, strong) MMOrderProcessView *processView;//订单进程view
@property (nonatomic, strong) MMOrderDetailInfoView *detailInfoView;//底部信息view
@property (nonatomic, strong) UIButton *rightBt;
@property (nonatomic, strong) UIButton *centerBt;
@property (nonatomic, strong) UIButton *leftBt;

@property (nonatomic, strong) MMOrderRemindPopView *popView;
@property (nonatomic, strong) MMOrderAfterSalesTipPopView *tipsPopView;

@property (nonatomic, strong) UITabBarItem *cartabBarItem;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;


@end

@implementation MMOrderDetailViewController

-(MMOrderDetailAddressView *)addressView{
    if(!_addressView){
        _addressView = [[MMOrderDetailAddressView alloc]initWithFrame:CGRectMake(10, 12, WIDTH - 20, 90)];
    }
    return _addressView;
}

-(MMOrderDetailGoodsView *)goodsView{
    if(!_goodsView){
        _goodsView = [[MMOrderDetailGoodsView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 162 * self.model.itemlist.count + 48)];
        _goodsView.model = self.model;
    }
    return _goodsView;
}

-(MMMoneyInfoView *)moneyInfoView{
    if(!_moneyInfoView){
        _moneyInfoView = [[MMMoneyInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsView.frame) + 14, WIDTH, 295)];
    }
    return _moneyInfoView;
}

-(MMOrderProcessView *)processView{
    KweakSelf(self);
    NSArray *arr = [MMOrderDetailTrackModel mj_objectArrayWithKeyValuesArray:self.model.tracklist];
    CGFloat hei = 0;
    for (int i = 0; i < arr.count; i++) {
        MMOrderDetailTrackModel *model = arr[i];
        NSString *str = [model.Conts stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 145,MAXFLOAT)];
        hei += size.height + 50;
    }
    if(!_processView){
        _processView = [[MMOrderProcessView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyInfoView.frame) + 34, WIDTH - 20, hei + 12)];
    }
    return _processView;
}

-(MMOrderDetailInfoView *)detailInfoView{
    if(!_detailInfoView){
        _detailInfoView = [[MMOrderDetailInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.processView.frame) + 20, WIDTH - 20, 175)];
        if([self.model.PayStatus isEqualToString:@"0"]){
            _detailInfoView.height = 125;
        }
    }
    return _detailInfoView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"订单详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
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
    titleView.titleLa.text = @"订单详情";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    self.popView = [[MMOrderRemindPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.tapGoonBlock = ^(NSString * _Nonnull str) {
        [ZTProgressHUD showMessage:@"估计是跳转客服了"];
    };
    
    NSString *conStr = @"售后申请期限指包裹签收7天之内，此处不包含清关异常、物流原因等导致包裹退回及美容仪保修等情况";
    self.tipsPopView = [[MMOrderAfterSalesTipPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:@"亲爱的蜜友" andConten:conStr andCancle:@"取消" andGoon:@"继续"];
    self.tipsPopView.tapGoonBlock = ^(NSString * _Nonnull str) {
        MMOrderAfterSalesVC *afterVC = [[MMOrderAfterSalesVC alloc]init];
        afterVC.model1 = weakself.model;
        [weakself.navigationController pushViewController:afterVC animated:YES];
    };
    
    self.tipsPopView.tapQuesttBlock = ^(NSString * _Nonnull str) {
        MMProblemDetailVC *problemVC = [[MMProblemDetailVC alloc]init];
        problemVC.ID = @"2090";
        [weakself.navigationController pushViewController:problemVC animated:YES];
    };
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
    [self requestOrderInfo];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    KweakSelf(self);
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 140)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 140);
    [self.view addSubview:scrollView];
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 88, WIDTH, 88)];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:bottomV];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 312 + 104 * i, 12, 84, 36)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 18;
        btn.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [bottomV addSubview:btn];
        
        if(i == 0){
            self.leftBt = btn;
        }else if (i == 1){
            self.centerBt = btn;
        }else{
            self.rightBt = btn;
            [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
            [btn setBackgroundColor:redColor2];
            btn.layer.borderColor = UIColor.clearColor.CGColor;
        }
    }
    
    if([self.model.CanPay isEqualToString:@"1"]){//待付款
        [self.rightBt setTitle:@"付款" forState:(UIControlStateNormal)];
        [self.centerBt setTitle:@"联系客服" forState:(UIControlStateNormal)];
        [self.leftBt setTitle:@"取消订单" forState:(UIControlStateNormal)];
    }else if ([self.model.AllState isEqualToString:@"0"]){//待发货
        if([self.model.CanTips isEqualToString:@"1"]){
            [self.rightBt setTitle:@"联系客服" forState:(UIControlStateNormal)];
            [self.rightBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
            [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.rightBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
            self.rightBt.layer.borderWidth = 0.5;
            [self.centerBt setTitle:@"提醒发货" forState:(UIControlStateNormal)];
            [self.leftBt setTitle:@"申请退款" forState:(UIControlStateNormal)];
        }else{
            [self.rightBt setTitle:@"联系客服" forState:(UIControlStateNormal)];
            [self.rightBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
            [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.rightBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
            self.rightBt.layer.borderWidth = 0.5;
            [self.centerBt setTitle:@"申请退款" forState:(UIControlStateNormal)];
            self.leftBt.hidden = YES;
        }
    }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
        //待收货
        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
        [self.centerBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.leftBt setTitle:@"申请售后" forState:(UIControlStateNormal)];
    }else if ([self.model.AllState isEqualToString:@"2"]){
        //已完成 分为可评价和不可评价
        [self.rightBt setTitle:@"评价" forState:(UIControlStateNormal)];
        [self.centerBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.leftBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        self.leftBt.x = WIDTH - 328;
        self.leftBt.width = 100;
        if([self.model.CanAssessOrder isEqualToString:@"0"]){
            [self.rightBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
            [self.rightBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
            [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.rightBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
            self.rightBt.layer.borderWidth = 0.5;
            
            [self.centerBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
            self.centerBt.x = WIDTH - 224;
            self.centerBt.width = 100;
            self.leftBt.hidden = YES;
        }
    }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"] || [self.model.AllState isEqualToString:@"10"]){
        //售后
        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
        [self.centerBt setTitle:@"联系客服" forState:(UIControlStateNormal)];
        self.leftBt.hidden = YES;
        
    }else if ([self.model.AllState isEqualToString:@"5"]){
        //取消关闭的
        [self.rightBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        [self.rightBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.rightBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
        self.rightBt.layer.borderWidth = 0.5;
        [self.centerBt setTitle:@"删除订单" forState:(UIControlStateNormal)];
        self.leftBt.hidden = YES;
    }
    
    
    self.addressView.mainModel = self.model;
    self.addressView.selectAddressBlock = ^(NSString * _Nonnull str) {
        [weakself selectAddress];
    };
    [scrollView addSubview:self.addressView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.addressView.frame) + 12, WIDTH - 20, 800)];
    contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 7.5;
    [scrollView addSubview:contentView];
    [contentView addSubview:self.goodsView];
    self.goodsView.tapGoodsBlock = ^(NSString * _Nonnull router) {
        [weakself RouteJump:router];
    };
    self.goodsView.tapAddCarBlock = ^(NSString * _Nonnull ID) {
        [weakself GetProductBuyTest:ID];
    };
    self.goodsView.tapApplyBlock = ^(NSString * _Nonnull ID) {
        [weakself getApplyAfter:ID];
    };
    self.moneyInfoView.model = self.model;
    [contentView addSubview:self.moneyInfoView];
    self.processView.tracklist = self.model.tracklist;
    [contentView addSubview:self.processView];
    self.detailInfoView.model = self.model;
    self.detailInfoView.tapCopyBlock = ^(NSString * _Nonnull orderNo) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = orderNo;
        [ZTProgressHUD showMessage:@"复制成功！"];
    };
    [contentView addSubview:self.detailInfoView];
    
    contentView.height = CGRectGetMaxY(self.detailInfoView.frame);
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(contentView.frame) + 20);
    
}

-(void)requestOrderInfo{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.ID forKey:@"id"];
    [param setValue:@"0" forKey:@"longitude"];
    [param setValue:@"0" forKey:@"latitude"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMOrderDetailInfoModel *model = [MMOrderDetailInfoModel mj_objectWithKeyValues:jsonDic];
            weakself.model = model;
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)selectAddress{
    KweakSelf(self);
    MMOrderChangeAddressVC *changeVC = [[MMOrderChangeAddressVC alloc]init];
    changeVC.model = self.model;
    changeVC.selectAddressBlock = ^(MMAddressModel * _Nonnull addressModel) {
        weakself.addressView.model = addressModel;
    };
    [self.navigationController pushViewController:changeVC animated:YES];
}

-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 102){
        if([self.model.CanPay isEqualToString:@"1"]){
            [self GetPayHandleMoreOrders:self.model.ID];
        }else if ([self.model.AllState isEqualToString:@"0"]){
            [ZTProgressHUD showMessage:@"客服"];
        }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
            [self receiptShow];
        }else if ([self.model.AllState isEqualToString:@"2"]){
            if([self.model.CanAssessOrder isEqualToString:@"1"]){
                MMMyAssessViewControllerView *assessVC = [[MMMyAssessViewControllerView alloc]init];
                [self.navigationController pushViewController:assessVC animated:YES];
            }else{
                MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
                logictisVC.orderID = self.model.ID;
                [self.navigationController pushViewController:logictisVC animated:YES];
            }
        }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"] || [self.model.AllState isEqualToString:@"10"]){
            [self receiptShow];
        }else if ([self.model.AllState isEqualToString:@"5"]){
            [self addCar:self.model.ID];
        }
    }else if (sender.tag == 101){
        if([self.model.CanPay isEqualToString:@"1"]){
            [ZTProgressHUD showMessage:@"联系客服"];
        }else if ([self.model.AllState isEqualToString:@"0"]){
            if([self.model.CanTips isEqualToString:@"1"]){
                [self tipsOrderID:self.model.ID];
            }else{
                //申请退款
                MMOrderAfterSalesVC *afterVC = [[MMOrderAfterSalesVC alloc]init];
                afterVC.model1 = self.model;
                [self.navigationController pushViewController:afterVC animated:YES];
            }
           
        }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
            MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
            logictisVC.orderID = self.model.ID;
            [self.navigationController pushViewController:logictisVC animated:YES];
        }else if ([self.model.AllState isEqualToString:@"2"]){
            if([self.model.CanAssessOrder isEqualToString:@"1"]){
                MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
                logictisVC.orderID = self.model.ID;
                [self.navigationController pushViewController:logictisVC animated:YES];
            }else{
                [self addCar:self.model.ID];
            }
        }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"] || [self.model.AllState isEqualToString:@"10"]){
            [ZTProgressHUD showMessage:@"客服"];
        }else if ([self.model.AllState isEqualToString:@"5"]){
            [ZTProgressHUD showMessage:@"删除订单"];
        }
    }else{
        if([self.model.CanPay isEqualToString:@"1"]){
            KweakSelf(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"确定取消该订单吗？"
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
                [weakself cancleOrderID:weakself.model.ID];
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }else if ([self.model.AllState isEqualToString:@"0"]){
            if([self.model.CanTips isEqualToString:@"1"]){
                //申请退款
                MMOrderAfterSalesVC *afterVC = [[MMOrderAfterSalesVC alloc]init];
                afterVC.model1 = self.model;
                [self.navigationController pushViewController:afterVC animated:YES];
            }
            
        }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
            [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
            [self.tipsPopView showView];
        }else if ([self.model.AllState isEqualToString:@"2"]){
            [self addCar:self.model.ID];
        }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"] || [self.model.AllState isEqualToString:@"10"]){
            
        }else if ([self.model.AllState isEqualToString:@"5"]){
            
        }
    }
}

//付款页面
-(void)GetPayHandleMoreOrders:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayHandleMoreOrders"];
    NSDictionary *param = @{@"id":ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMPayResultModel *payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
            MMPayViewController *payVC = [[MMPayViewController alloc]init];
            payVC.model = payModel;
            payVC.isEnter = @"0";
            [weakself.navigationController pushViewController:payVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//取消订单
-(void)cancleOrderID:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CancelOrder"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//加入购物车
-(void)addCar:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AllCartPlus"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"1" forKey:@"back"];

    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMShopCarModel *model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.cartabBarItem.badgeValue = model.num;
            if([model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//确认收货弹窗
-(void)receiptShow{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"你确定要确认收货吗？"
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
        [weakself OrderReceipt:weakself.model.ID];
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

//确认收货请求
-(void)OrderReceipt:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderReceipt"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//提醒发货
-(void)tipsOrderID:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderTips"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.popView];
            [weakself.popView showView];
            weakself.centerBt.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//单个商品申请售后
-(void)getApplyAfter:(NSString *)ID{
    [ZTProgressHUD showMessage:[NSString stringWithFormat:@"对%@申请售后",ID]];
}

#pragma mark -- 请求规格数据
-(void)GetProductBuyTest:(NSString *)ID{
    KweakSelf(self);
    self.goodsId = ID;
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
//单个商品请求加入购物车
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
    [TalkingDataSDK onPageEnd:@"订单详情页面"];
}

@end
