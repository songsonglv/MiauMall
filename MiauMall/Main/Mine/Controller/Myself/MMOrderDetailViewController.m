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
#import "MMCustomerServiceVC.h"
#import "MMAfterSalesResultVC.h"
#import "MMRefundTipsModel.h"
#import "MMOrderRefundPopView.h"

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

//@property (nonatomic, strong) UITabBarItem *cartabBarItem;

@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;
@property (nonatomic, strong) NSString *attid;
@property (nonatomic, strong) MMAttlistItemModel *attlistModel;
@property (nonatomic, strong) NSMutableArray *goodsSpecArr;
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;
@property (nonatomic, strong) NSString *goodsId;//商品ID
@property (nonatomic, strong) NSString *numStr;

//规格弹窗

@property (nonatomic, strong) MMSelectSKUPopView *skuPopView;

@property (nonatomic, strong) MMOrderRefundPopView *refundTipPopView;


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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"orderDetails"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    self.popView = [[MMOrderRemindPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.tapGoonBlock = ^(NSString * _Nonnull str) {
        [ZTProgressHUD showMessage:@"估计是跳转客服了"];
    };
    
    self.refundTipPopView = [[MMOrderRefundPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.refundTipPopView.tapGoonBlock = ^(NSString * _Nonnull str) {
        [weakself getApplyAfter];
    };
    
    NSString *conStr = [UserDefaultLocationDic valueForKey:@"shsqqx"];
    self.tipsPopView = [[MMOrderAfterSalesTipPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:[UserDefaultLocationDic valueForKey:@"dearHoney"] andConten:conStr andCancle:[UserDefaultLocationDic valueForKey:@"icancel"] andGoon:[UserDefaultLocationDic valueForKey:@"icontinue"]];
    self.tipsPopView.tapGoonBlock = ^(NSString * _Nonnull str) {
        [weakself getApplyAfter];
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
    
    
    float wid = (WIDTH - 20)/4;
    UIButton *receiptBt = [[UIButton alloc]init];
    [receiptBt setBackgroundColor:redColor2];
    [receiptBt setTitle:[UserDefaultLocationDic valueForKey:@"confirmReceipt"] forState:(UIControlStateNormal)];
    [receiptBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    receiptBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    receiptBt.titleLabel.numberOfLines = 0;
    receiptBt.layer.masksToBounds = YES;
    receiptBt.layer.cornerRadius = 18;
    [receiptBt addTarget:self action:@selector(clickReceipt) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:receiptBt];
    
       
    [receiptBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-2.5);
        make.bottom.mas_equalTo(-38);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    if([self.model.CanReceiptOrder isEqualToString:@"1"]){
        receiptBt.hidden = NO;
    }else{
        receiptBt.hidden = YES;
        [receiptBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    
    //支付
    
    UIButton *chaidanBt = [[UIButton alloc]init];
    [chaidanBt setBackgroundColor:redColor2];
    [chaidanBt setTitle:[UserDefaultLocationDic valueForKey:@"payMoney"] forState:(UIControlStateNormal)];
    [chaidanBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    chaidanBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    chaidanBt.titleLabel.numberOfLines = 0;
    chaidanBt.layer.masksToBounds = YES;
    chaidanBt.layer.cornerRadius = 18;
    [chaidanBt addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:chaidanBt];
    
    if(receiptBt.hidden == YES){
        [chaidanBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [chaidanBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(receiptBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanPay isEqualToString:@"1"]){
        chaidanBt.hidden = NO;
    }else{
        chaidanBt.hidden = YES;
        [chaidanBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    
    
    //查看结果
    UIButton *resultBt = [[UIButton alloc]init];
    [resultBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [resultBt setTitle:[UserDefaultLocationDic valueForKey:@"proResults"] forState:(UIControlStateNormal)];
    [resultBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    resultBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    resultBt.titleLabel.numberOfLines = 0;
    resultBt.layer.masksToBounds = YES;
    resultBt.layer.cornerRadius = 18;
    resultBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    resultBt.layer.borderWidth = 0.5;
    [resultBt addTarget:self action:@selector(clickResult) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:resultBt];
    
    if(chaidanBt.hidden == YES){
        [resultBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(receiptBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [resultBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(chaidanBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanResult isEqualToString:@"1"]){
        resultBt.hidden = NO;
    }else{
        resultBt.hidden = YES;
        [resultBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    //退款
    
    UIButton *refundBt = [[UIButton alloc]init];
    [refundBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [refundBt setTitle:[UserDefaultLocationDic valueForKey:@"refundRequest"] forState:(UIControlStateNormal)];
    [refundBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    refundBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    refundBt.titleLabel.numberOfLines = 0;
    refundBt.layer.masksToBounds = YES;
    refundBt.layer.cornerRadius = 18;
    refundBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    refundBt.layer.borderWidth = 0.5;
    [refundBt addTarget:self action:@selector(clickRefund) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:refundBt];
   
    if(resultBt.hidden == YES){
        [refundBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(chaidanBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [refundBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(resultBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanRefundMoney isEqualToString:@"1"]){
        refundBt.hidden = NO;
    }else{
        refundBt.hidden = YES;
        [refundBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    
    //查看物流
    
    UIButton *viewLogisticBt = [[UIButton alloc]init];
    [viewLogisticBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [viewLogisticBt setTitle:[UserDefaultLocationDic valueForKey:@"viewLogistics"] forState:(UIControlStateNormal)];
    [viewLogisticBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    viewLogisticBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    viewLogisticBt.titleLabel.numberOfLines = 0;
    viewLogisticBt.layer.masksToBounds = YES;
    viewLogisticBt.layer.cornerRadius = 18;
    viewLogisticBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    viewLogisticBt.layer.borderWidth = 0.5;
    [viewLogisticBt addTarget:self action:@selector(clickLogistics) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:viewLogisticBt];
    
    if(refundBt.hidden == YES){
        [viewLogisticBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(resultBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [viewLogisticBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(refundBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanExpress isEqualToString:@"1"]){
        viewLogisticBt.hidden = NO;
    }else{
        viewLogisticBt.hidden = YES;
        [viewLogisticBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    
    //售后服务
    UIButton *saleServiceBt = [[UIButton alloc]init];
    [saleServiceBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [saleServiceBt setTitle:[UserDefaultLocationDic valueForKey:@"salesService"] forState:(UIControlStateNormal)];
    [saleServiceBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    saleServiceBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    saleServiceBt.titleLabel.numberOfLines = 0;
    saleServiceBt.layer.masksToBounds = YES;
    saleServiceBt.layer.cornerRadius = 18;
    saleServiceBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    saleServiceBt.layer.borderWidth = 0.5;
    [saleServiceBt addTarget:self action:@selector(clickSalesService) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:saleServiceBt];
    
    if(viewLogisticBt.hidden == YES){
        [saleServiceBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(refundBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [saleServiceBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewLogisticBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanRefundItem isEqualToString:@"1"]){
        saleServiceBt.hidden = NO;
    }else{
        saleServiceBt.hidden = YES;
        [saleServiceBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    //评价
    UIButton *assessBt = [[UIButton alloc]init];
    [assessBt setBackgroundColor:redColor2];
    [assessBt setTitle:[UserDefaultLocationDic valueForKey:@"ievaluate"] forState:(UIControlStateNormal)];
    [assessBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    assessBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assessBt.titleLabel.numberOfLines = 0;
    assessBt.layer.masksToBounds = YES;
    assessBt.layer.cornerRadius = 18;
    [assessBt addTarget:self action:@selector(clickAssess) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:assessBt];
    
    if(saleServiceBt.hidden == YES){
        [assessBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewLogisticBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [assessBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(saleServiceBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanAssessOrder isEqualToString:@"1"]){
        assessBt.hidden = NO;
    }else{
        assessBt.hidden = YES;
        [assessBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    
    //提醒发货
 
    UIButton *tixingBt = [[UIButton alloc]init];
    [tixingBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [tixingBt setTitle:[UserDefaultLocationDic valueForKey:@"tiXifaH"] forState:(UIControlStateNormal)];
    [tixingBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    tixingBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    tixingBt.titleLabel.numberOfLines = 0;
    tixingBt.layer.masksToBounds = YES;
    tixingBt.layer.cornerRadius = 18;
    tixingBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    tixingBt.layer.borderWidth = 0.5;
    [tixingBt addTarget:self action:@selector(clickTiXing) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:tixingBt];
    
    if(assessBt.hidden == YES){
        [tixingBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(saleServiceBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [tixingBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assessBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanTips isEqualToString:@"1"]){
        tixingBt.hidden = NO;
    }else{
        tixingBt.hidden = YES;
        [tixingBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
   
    
    
    
    //修改地址
    UIButton *changeAddressBt = [[UIButton alloc]init];
    [changeAddressBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [changeAddressBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
    [changeAddressBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    changeAddressBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    changeAddressBt.titleLabel.numberOfLines = 0;
    changeAddressBt.layer.masksToBounds = YES;
    changeAddressBt.layer.cornerRadius = 18;
    changeAddressBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    changeAddressBt.layer.borderWidth = 0.5;
    [changeAddressBt addTarget:self action:@selector(clickAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:changeAddressBt];
   
    if(tixingBt.hidden == YES){
        [changeAddressBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assessBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [changeAddressBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tixingBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanAddress isEqualToString:@"1"]){
        changeAddressBt.hidden = NO;
    }else{
        changeAddressBt.hidden = YES;
        [changeAddressBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
   
    
    //加入购物车
    UIButton *addCartBt = [[UIButton alloc]init];
    [addCartBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [addCartBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
    [addCartBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    addCartBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addCartBt.titleLabel.numberOfLines = 0;
    addCartBt.layer.masksToBounds = YES;
    addCartBt.layer.cornerRadius = 18;
    addCartBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    addCartBt.layer.borderWidth = 0.5;
    [addCartBt addTarget:self action:@selector(clickAddCart) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:addCartBt];
    
    if(changeAddressBt.hidden == YES){
        [addCartBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tixingBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [addCartBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(changeAddressBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanAddCart isEqualToString:@"1"]){
        addCartBt.hidden = NO;
    }else{
        addCartBt.hidden = YES;
        [addCartBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    
    
    //取消
    UIButton *cancleBt = [[UIButton alloc]init];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cancleBt.titleLabel.numberOfLines = 0;
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 18;
    cancleBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:cancleBt];
   
    if(addCartBt.hidden == YES){
        [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(changeAddressBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addCartBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanCancel isEqualToString:@"1"]){
        cancleBt.hidden = NO;
    }else{
        cancleBt.hidden = YES;
        [cancleBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
   
    
    //删除
    UIButton *deleteBt = [[UIButton alloc]init];
    [deleteBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [deleteBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
    [deleteBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    deleteBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    deleteBt.titleLabel.numberOfLines = 0;
    deleteBt.layer.masksToBounds = YES;
    deleteBt.layer.cornerRadius = 18;
    deleteBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    deleteBt.layer.borderWidth = 0.5;
    [deleteBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:deleteBt];
    
    if(cancleBt.hidden == YES){
        [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addCartBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }else{
        [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cancleBt.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(-38);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if([self.model.CanDeleteOrder isEqualToString:@"1"]){
        deleteBt.hidden = NO;
    }else{
        deleteBt.hidden = YES;
        [deleteBt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
        }];
    }
    
    if([self.model.ColumnID isEqualToString:@"804"]){
        
    }else{
        self.addressView.mainModel = self.model;
        self.addressView.selectAddressBlock = ^(NSString * _Nonnull str) {
            [weakself selectAddress];
        };
        [scrollView addSubview:self.addressView];
        
    }
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.addressView.frame) + 12, WIDTH - 20, 800)];
    if([self.model.ColumnID isEqualToString:@"804"]){
        contentView.y = 12;
    }
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
        [weakself getApplyAfter];
    };
    self.moneyInfoView.model = self.model;
    [contentView addSubview:self.moneyInfoView];
    self.processView.tracklist = self.model.tracklist;
    [contentView addSubview:self.processView];
    self.detailInfoView.model = self.model;
    self.detailInfoView.tapCopyBlock = ^(NSString * _Nonnull orderNo) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = orderNo;
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
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
    [param setValue:@"1" forKey:@"isShowRefund"];
    
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

-(void)clickReceipt{
    [self receiptShow];
}

-(void)clickPay{
    [self GetPayHandleMoreOrders:self.model.ID];
}

-(void)clickResult{
    MMAfterSalesResultVC *reasultVC = [[MMAfterSalesResultVC alloc]init];
    reasultVC.orderID = self.model.ID;
    [self.navigationController pushViewController:reasultVC animated:YES];

}

//售后退款
-(void)clickRefund{
    if([self.model.Processing isEqualToString:@"6"]){
        [self requestOrderRefundMoneyTips:self.model.OrderNumber];
    }else{
        [self getApplyAfter];
    }
}

-(void)clickLogistics{
    MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
    logictisVC.orderID = self.model.ID;
    [self.navigationController pushViewController:logictisVC animated:YES];
}

-(void)clickSalesService{
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsPopView];
    [self.tipsPopView showView];
}

-(void)clickAssess{
    MMMyAssessViewControllerView *assessVC = [[MMMyAssessViewControllerView alloc]init];
    [self.navigationController pushViewController:assessVC animated:YES];
}

-(void)clickTiXing{
    [self tipsOrderID:self.model.ID];
}

-(void)clickAddress{
    [self selectAddress];
}

-(void)clickAddCart{
    [self addCar:self.model.ID];
}

-(void)clickCancle{
    [self cancleOrderID:self.model.ID];
}

-(void)clickDelete{
    [self deleteOrder:self.model.ID];
}

//删除订单
-(void)deleteOrder:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"DeleteCloseOrder"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"orderID"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestOrderRefundMoneyTips:(NSString *)orderNum{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"IsRefundTips"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderNum forKey:@"OrderNumber"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMRefundTipsModel *model = [MMRefundTipsModel mj_objectWithKeyValues:jsonDic];
            weakself.refundTipPopView.model = model;
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.refundTipPopView];
            [weakself.refundTipPopView showView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
        }else if ([self.model.AllState isEqualToString:@"7"]){
            [self chatKeFu];
        }
    }else if (sender.tag == 101){
        if([self.model.CanPay isEqualToString:@"1"]){
            [self chatKeFu];
//            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"iservice"]];
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
            [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"idelete"]];
        }
    }else{
        if([self.model.CanPay isEqualToString:@"1"]){
            KweakSelf(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                           message:[UserDefaultLocationDic valueForKey:@"conCleanOrder"]
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
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:[UserDefaultLocationDic valueForKey:@"ifYouReceipt"]
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
-(void)getApplyAfter{
    MMOrderAfterSalesVC *afterVC = [[MMOrderAfterSalesVC alloc]init];
    afterVC.model1 = self.model;
    [self.navigationController pushViewController:afterVC animated:YES];
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


-(void)chatKeFu{
    MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
    customVC.orderID = self.model.ID;
    [self.navigationController pushViewController:customVC animated:YES];
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
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"订单详情页面"];
}

@end
