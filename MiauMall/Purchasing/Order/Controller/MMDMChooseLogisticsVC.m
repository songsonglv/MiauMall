//
//  MMDMChooseLogisticsVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMChooseLogisticsVC.h"
#import "MMDMChooseLogisticsModel.h"
#import "MMDMOrderDetailAddressView.h"
#import "MMDMLogisticInfoView.h"
#import "MMDMLogisticChooseView.h"
#import "MMDMJiaGuView.h"
#import "MMDMChooseLogisticBottomView.h"
#import "MMDMExpressFeesModel.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"

@interface MMDMChooseLogisticsVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *expressid;
@property (nonatomic, strong) NSString *isjiagu;
@property (nonatomic, strong) MMDMChooseLogisticsModel *model;
@property (nonatomic, strong) MMDMOrderDetailAddressView *addressView;
@property (nonatomic, strong) MMDMLogisticInfoView *infoView;
@property (nonatomic, strong) MMDMLogisticChooseView *logisticView;
@property (nonatomic, strong) MMDMJiaGuView *jiaguView;
@property (nonatomic, strong) MMDMChooseLogisticBottomView *bottomView;
@end

@implementation MMDMChooseLogisticsVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买确认物流页面"];
}

-(MMDMOrderDetailAddressView *)addressView{
    if(!_addressView){
        _addressView = [[MMDMOrderDetailAddressView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _addressView.model1 = self.model;
    }
    return _addressView;
}

-(MMDMLogisticInfoView *)infoView{
    if(!_infoView){
        _infoView = [[MMDMLogisticInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jiaguView.frame) + 8, WIDTH, 395)];
        _infoView.model = self.model;
        _infoView.attachStr = @"JPY 0";
    }
    return _infoView;
}

-(MMDMLogisticChooseView *)logisticView{
    KweakSelf(self);
    if(!_logisticView){
        CGFloat hei = 60;
        NSArray *arr = [MMDMExpressFeesModel mj_objectArrayWithKeyValuesArray:self.model.ExpressFees];
        for (int i = 0; i < arr.count; i++) {
            MMDMExpressFeesModel *model = arr[i];
            
            CGSize size1 = [NSString sizeWithText:model.Conts font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
            hei += size1.height + 47;
        }
        _logisticView = [[MMDMLogisticChooseView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.addressView.frame), WIDTH, hei) andArr:self.model.ExpressFees];
        _logisticView.returnModelBlock = ^(NSString * _Nonnull ID) {
            weakself.expressid = ID;
            [weakself refresh];
        };
    }
    return _logisticView;
}

-(MMDMJiaGuView *)jiaguView{
    if(!_jiaguView){
        KweakSelf(self);
        CGSize size1 = [NSString sizeWithText:self.model.ReinforcementTips font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
        _jiaguView = [[MMDMJiaGuView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logisticView.frame) + 8, WIDTH, size1.height + 64 + 47) andModel:self.model];
        _jiaguView.selectJiaguBlock = ^(NSString * _Nonnull str) {
            weakself.isjiagu = str;
            [weakself refresh];
            
            if([str isEqualToString:@"1"]){
                weakself.infoView.attachStr = weakself.model.ReinforcementMoneyShow;
            }else{
                weakself.infoView.attachStr = @"JPY 0";
            }
        };
    }
    return _jiaguView;
}

-(MMDMChooseLogisticBottomView *)bottomView{
    KweakSelf(self);
    if(!_bottomView){
        _bottomView = [[MMDMChooseLogisticBottomView alloc]initWithFrame:CGRectMake(0, HEIGHT - 104 - TabbarSafeBottomMargin, WIDTH, 104 + TabbarSafeBottomMargin)];
        _bottomView.model = self.model;
        _bottomView.returnSubBlock = ^(NSString * _Nonnull str) {
            [weakself ChooeseExpress];
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xf5f6f7);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.expressid = @"1";
    self.isjiagu = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"确认物流";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"ChooeseExpressInit"];
    
    NSDictionary *param = @{@"id":self.orderId,@"expressid":self.expressid,@"lang":self.lang,@"isjiagu":self.isjiagu};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMChooseLogisticsModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refresh{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"ChooeseExpressInit"];
    
    NSDictionary *param = @{@"id":self.orderId,@"expressid":self.expressid,@"lang":self.lang,@"isjiagu":self.isjiagu};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMChooseLogisticsModel mj_objectWithKeyValues:jsonDic];
            weakself.bottomView.model = weakself.model;
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - 104 - TabbarSafeBottomMargin)];
    scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.addressView];
    [scrollView addSubview:self.logisticView];
    [scrollView addSubview:self.jiaguView];
    [scrollView addSubview:self.infoView];
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.infoView.frame) + 150);
    
    [self.view addSubview:self.bottomView];
}

-(void)ChooeseExpress{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"ChooeseExpress"];
    
    NSDictionary *param = @{@"id":self.orderId,@"expressid":self.expressid,@"lang":self.lang,@"isjiagu":self.isjiagu};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
//        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        if([code isEqualToString:@"1"]){
            [weakself GetPayHandleMoreOrders];
           
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//付款页面
-(void)GetPayHandleMoreOrders{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetPayHandleLast"];
    NSDictionary *param = @{@"orderid":self.orderId,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
//                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
//                [navigationArray removeObjectAtIndex: [navigationArray count]-1];
//                [weakself.navigationController setViewControllers: navigationArray animated:NO];
                MMPayResultModel *payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
                MMPayViewController *payVC = [[MMPayViewController alloc]init];
                payVC.model = payModel;
                payVC.isEnter = @"1";
                [weakself.navigationController pushViewController:payVC animated:YES];
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } RequestFaile:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买确认物流页面"];
}
@end
