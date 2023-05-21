//
//  MMDMOrderDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import "MMDMOrderDetailVC.h"
#import "MMDMOrderDetailModel.h"
#import "MMDMOrderDetailAddressView.h"
#import "MMDMOrderDetailGoodsView.h"
#import "MMDMOrderDetailMoneyView.h"
#import "MMDMOrderDetailPhotoView.h"
#import "MMDMOrderDetailTrackView.h"
#import "MMDMOrderTrackModel.h"
#import "MMCustomerServiceVC.h"
#import "MMDMChooseLogisticsVC.h"
#import "MMLogisticsInfomoationVC.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"
#import "MMDMPhotoTipsModel.h"
#import "MMDMPhotoPopView.h"

@interface MMDMOrderDetailVC ()<WKNavigationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMDMOrderDetailModel *model;
@property (nonatomic, strong) MMDMOrderDetailAddressView *addressView;
@property (nonatomic, strong) MMDMOrderDetailGoodsView *goodsView;
@property (nonatomic, strong) MMDMOrderDetailMoneyView *moneyView;
@property (nonatomic, strong) MMDMOrderDetailPhotoView *photoView;
@property (nonatomic, strong) MMDMOrderDetailTrackView *trackView;

@property (nonatomic, strong) MMDMPhotoTipsModel *photoTipsModel;
@property (nonatomic, strong) MMDMPhotoPopView *photoPopview;
@end

@implementation MMDMOrderDetailVC

-(MMDMOrderDetailAddressView *)addressView{
    if(!_addressView){
        _addressView = [[MMDMOrderDetailAddressView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _addressView.model = self.model;
    }
    return _addressView;
}

-(MMDMOrderDetailGoodsView *)goodsView{
    if(!_goodsView){
        _goodsView = [[MMDMOrderDetailGoodsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame), WIDTH, self.model.OrderProducts.count * 116 + 40)];
        _goodsView.goodsArr = self.model.OrderProducts;
    }
    return _goodsView;
}

-(MMDMOrderDetailPhotoView *)photoView{
    KweakSelf(self);
    if(!_photoView){
        _photoView = [[MMDMOrderDetailPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsView.frame), WIDTH, 172)];
        _photoView.model = self.model;
        if(self.model.PhotoPicture.count > 0){
            float wid = (WIDTH - 48)/3;
            NSInteger i = self.model.PhotoPicture.count/3;
            NSInteger j = self.model.PhotoPicture.count%3;
            if(j > 0){
                i += 1;
            }
            _photoView.height = (wid + 12) * i + 64;
            _photoView.tapImageBlock = ^(NSArray * _Nonnull arr, NSInteger index) {
                [weakself showBigImage:arr andIndex:index];
            };
        }
    }
    return _photoView;
}

-(MMDMOrderDetailMoneyView *)moneyView{
    if(!_moneyView){
        _moneyView = [[MMDMOrderDetailMoneyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsView.frame), WIDTH, 385)];
        if(self.model.PhotoPicture.count > 0 || self.model.PhoteTips.length > 0){
            _moneyView.y = CGRectGetMaxY(self.photoView.frame) + 8;
        }
        _moneyView.model = self.model;
    }
    return _moneyView;
}

-(MMDMOrderDetailTrackView *)trackView{
    if(!_trackView){
        NSArray *arr1 = [MMDMOrderTrackModel mj_objectArrayWithKeyValuesArray:self.model.OrderTracks];
        float hei = 70;
        for (int i = 0; i < arr1.count; i++) {
            MMDMOrderTrackModel *model = arr1[i];
            
            CGSize size = [NSString sizeWithText:model.AddTime font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
            
            CGSize size1 = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 16 - size.width - 24,MAXFLOAT)];
            hei += size1.height + 12;
        }
        _trackView = [[MMDMOrderDetailTrackView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyView.frame) + 8, WIDTH, hei)];
        _trackView.arr = self.model.OrderTracks;
    }
    return _trackView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代卖订单详情"];
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
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"orderDetails"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    UIButton *kefuBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 38, 17, 26, 20)];
    [kefuBt setImage:[UIImage imageNamed:@"kefu_balck_icon"] forState:(UIControlStateNormal)];
    [kefuBt addTarget:self action:@selector(clickKefu) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:kefuBt];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)GetRequestPhotoTips{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetRequestPhotoTips"];
    NSDictionary *param = @{@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        webView.navigationDelegate = self;
        [weakself.view addSubview:webView];

        

        
        if([code isEqualToString:@"1"]){
            weakself.photoTipsModel = [MMDMPhotoTipsModel mj_objectWithKeyValues:jsonDic];
            
            weakself.photoPopview = [[MMDMPhotoPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andModel:weakself.photoTipsModel andHeight:760];
            weakself.photoPopview.returnSureBlock = ^(NSInteger num) {
                [weakself RequestPhoto:num];
            };
            
            
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"OrderInfo"];
    
    NSDictionary *param = @{@"id":self.orderID,@"memberToken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMOrderDetailModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//提交申请拍照
-(void)RequestPhoto:(NSInteger )num{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"RequestPhoto"];
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    NSDictionary *param = @{@"id":self.orderID,@"num":numStr,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [self GetRequestPhotoTips];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.addressView];
    
    [scrollView addSubview:self.goodsView];
    
    if(self.model.PhotoPicture.count > 0 || self.model.PhoteTips.length > 0){
        [scrollView addSubview:self.photoView];
    }
    
    [scrollView addSubview:self.moneyView];
    
    [scrollView addSubview:self.trackView];
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.trackView.frame) + 72 + TabbarSafeBottomMargin);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - TabbarSafeBottomMargin - 72, WIDTH, HEIGHT + TabbarSafeBottomMargin)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x464646) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH/2;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(13);
    }];
    
    NSArray *temp = [self.model.PayMoneyShow componentsSeparatedByString:@" "];
    
    [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%@:",[UserDefaultLocationDic valueForKey:@"itotal"]]).textColor(TCUIColorFromRGB(0x464646)).font([UIFont systemFontOfSize:13]);
        confer.text(temp[0]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
        confer.text(temp[1]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
    }];
    
    UILabel *lab1 = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.PaySignMoney] textColor:TCUIColorFromRGB(0x464646) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = WIDTH/2;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(lab.mas_bottom).offset(12);
            make.height.mas_equalTo(12);
    }];
    
    float wid = (WIDTH - 40)/4;
    
    NSString *str0 = [UserDefaultLocationDic valueForKey:@"confirmReceipt"];
    CGSize size0 = [NSString sizeWithText:str0 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *receiptBt = [[UIButton alloc]init];
                           //WithFrame:CGRectMake(WIDTH - 30, contView.height - 56, size1.width + 26, 30)];
    [receiptBt setBackgroundColor:redColor3];
    [receiptBt setTitle:str0 forState:(UIControlStateNormal)];
    [receiptBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    receiptBt.titleLabel.font = [UIFont systemFontOfSize:14];
    receiptBt.titleLabel.numberOfLines = 0;
    receiptBt.layer.masksToBounds = YES;
    receiptBt.hidden = YES;
    receiptBt.layer.cornerRadius = 15;
    [receiptBt addTarget:self action:@selector(clickReceipt) forControlEvents:(UIControlEventTouchUpInside)];
    receiptBt.frame = CGRectMake(WIDTH - wid - 12, 12, wid, 30);
    [view addSubview:receiptBt];
    
    if([self.model.CanCompleteOrder isEqualToString:@"1"]){
        receiptBt.hidden = NO;
    }else{
        receiptBt.x = WIDTH;
        receiptBt.width = 0;
    }
    
    NSString *str1 = @"选择物流";
    CGSize size1 = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *lastPayBt = [[UIButton alloc]init];
                           //WithFrame:CGRectMake(WIDTH - 30, contView.height - 56, size1.width + 26, 30)];
    [lastPayBt setBackgroundColor:redColor3];
    [lastPayBt setTitle:str1 forState:(UIControlStateNormal)];
    [lastPayBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    lastPayBt.titleLabel.font = [UIFont systemFontOfSize:14];
    lastPayBt.layer.masksToBounds = YES;
    lastPayBt.titleLabel.numberOfLines = 0;
    lastPayBt.hidden = YES;
    lastPayBt.layer.cornerRadius = 15;
    [lastPayBt addTarget:self action:@selector(clickLastPay) forControlEvents:(UIControlEventTouchUpInside)];
    lastPayBt.frame = CGRectMake(receiptBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:lastPayBt];

    
//    [lastPayBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-12);
//            make.top.mas_offset(12);
//            make.width.mas_equalTo(size1.width + 26);
//            make.height.mas_equalTo(30);
//    }];
//
    if([self.model.CanLastPay isEqualToString:@"1"]){
        lastPayBt.hidden = NO;
    }else{
        lastPayBt.x = receiptBt.x;
        lastPayBt.width = 0;
    }
    
    NSString *str2 = @"支付订单";
    CGSize size2 = [NSString sizeWithText:str2 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *payOrderBt = [[UIButton alloc]init];
    [payOrderBt setBackgroundColor:redColor3];
    [payOrderBt setTitle:str2 forState:(UIControlStateNormal)];
    [payOrderBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    payOrderBt.titleLabel.font = [UIFont systemFontOfSize:14];
    payOrderBt.titleLabel.numberOfLines = 0;
    payOrderBt.layer.masksToBounds = YES;
    payOrderBt.layer.cornerRadius = 15;
    payOrderBt.hidden = YES;
    [payOrderBt addTarget:self action:@selector(clickPayOrder) forControlEvents:(UIControlEventTouchUpInside)];
    payOrderBt.frame = CGRectMake(lastPayBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:payOrderBt];
    
    
    
    if([self.model.CanFirstPay isEqualToString:@"1"]){
        payOrderBt.hidden = NO;
    }else{
        payOrderBt.x = lastPayBt.x;
        payOrderBt.width = 0;
    }
    
    
    NSString *str4 = @"拍照申请";
    CGSize size4 = [NSString sizeWithText:str4 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *photoBt = [[UIButton alloc]init];
    [photoBt setBackgroundColor:TCUIColorFromRGB(0x333333)];
    [photoBt setTitle:str4 forState:(UIControlStateNormal)];
    [photoBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    photoBt.titleLabel.font = [UIFont systemFontOfSize:14];
    photoBt.titleLabel.numberOfLines = 0;
    photoBt.layer.masksToBounds = YES;
    photoBt.layer.cornerRadius = 15;
    photoBt.hidden = YES;
    [photoBt addTarget:self action:@selector(clickPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    photoBt.frame = CGRectMake(payOrderBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:photoBt];
    
    if([self.model.CanPhoto isEqualToString:@"1"]){
        photoBt.hidden = NO;
    }else{
        photoBt.x = payOrderBt.x;
        photoBt.width = 0;
    }
    
    NSString *str5 = [UserDefaultLocationDic valueForKey:@"cleanOrder"];
    CGSize size5 = [NSString sizeWithText:str5 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *cancleBt = [[UIButton alloc]init];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [cancleBt setTitle:str5 forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:14];
    cancleBt.titleLabel.numberOfLines = 0;
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    cancleBt.layer.borderWidth = 0.5;
    cancleBt.hidden = YES;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    cancleBt.frame = CGRectMake(photoBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:cancleBt];
    
        
    if([self.model.CanCancel isEqualToString:@"1"]){
        cancleBt.hidden = NO;
    }else{
        cancleBt.x = photoBt.x;
        cancleBt.width = 0;
    }
        
    
    NSString *str6 = [UserDefaultLocationDic valueForKey:@"proResults"];
    CGSize size6 = [NSString sizeWithText:str6 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *resultBt = [[UIButton alloc]init];
    [resultBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [resultBt setTitle:str6 forState:(UIControlStateNormal)];
    [resultBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    resultBt.titleLabel.font = [UIFont systemFontOfSize:14];
    resultBt.titleLabel.numberOfLines = 0;
    resultBt.layer.masksToBounds = YES;
    resultBt.layer.cornerRadius = 15;
    resultBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    resultBt.layer.borderWidth = 0.5;
    resultBt.hidden = YES;
    [resultBt addTarget:self action:@selector(clickResult) forControlEvents:(UIControlEventTouchUpInside)];
    resultBt.frame = CGRectMake(cancleBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:resultBt];
    
   
    
    if([self.model.CanResult isEqualToString:@"1"]){
        resultBt.hidden = NO;
    }else{
        resultBt.x = cancleBt.x;
        resultBt.width = 0;
    }
    
    NSString *str7 = [UserDefaultLocationDic valueForKey:@"idelete"];
    CGSize size7 = [NSString sizeWithText:str7 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *refundBt = [[UIButton alloc]init];
    [refundBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [refundBt setTitle:str7 forState:(UIControlStateNormal)];
    [refundBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    refundBt.titleLabel.font = [UIFont systemFontOfSize:14];
    refundBt.titleLabel.numberOfLines = 0;
    refundBt.layer.masksToBounds = YES;
    refundBt.layer.cornerRadius = 15;
    refundBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    refundBt.layer.borderWidth = 0.5;
    refundBt.hidden = YES;
    [refundBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
    refundBt.frame = CGRectMake(resultBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:refundBt];
    
    if([self.model.CanDeleteOrder isEqualToString:@"1"]){
        refundBt.hidden = NO;
    }else{
        refundBt.x = resultBt.x;
        refundBt.width = 0;
    }
    
    NSString *str8 = [UserDefaultLocationDic valueForKey:@"ckanWuliu"];
    CGSize size8 = [NSString sizeWithText:str8 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *viewLogictisBt = [[UIButton alloc]init];
    [viewLogictisBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [viewLogictisBt setTitle:str8 forState:(UIControlStateNormal)];
    [viewLogictisBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    viewLogictisBt.titleLabel.font = [UIFont systemFontOfSize:14];
    viewLogictisBt.titleLabel.numberOfLines = 0;
    viewLogictisBt.layer.masksToBounds = YES;
    viewLogictisBt.layer.cornerRadius = 15;
    viewLogictisBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    viewLogictisBt.layer.borderWidth = 0.5;
    viewLogictisBt.hidden = YES;
    [viewLogictisBt addTarget:self action:@selector(viewLogistic) forControlEvents:(UIControlEventTouchUpInside)];
    viewLogictisBt.frame = CGRectMake(refundBt.x - 12 - wid, 12, wid, 30);
    [view addSubview:viewLogictisBt];
    
    if([self.model.CanShowTrack isEqualToString:@"1"]){
        viewLogictisBt.hidden = NO;
    }else{
        viewLogictisBt.x = refundBt.x;
        viewLogictisBt.width = 0;
    }
}


//点击看大图
-(void)showBigImage:(NSArray *)arr andIndex:(NSInteger)index{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    mg.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
    [mg showPhotoViewerModels:arr controller:self selectViewIndex:index];
}

-(void)clickLastPay{
    MMDMChooseLogisticsVC *chooseVC = [[MMDMChooseLogisticsVC alloc]init];
    chooseVC.orderId = self.model.ID;
    [self.navigationController pushViewController:chooseVC animated:YES];
}

-(void)clickPhoto{
    [[UIApplication sharedApplication].keyWindow addSubview:self.photoPopview];
    [self.photoPopview showView];
}

-(void)clickCancle{
    [self CancleOrderl];
}

-(void)viewLogistic{
    MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
    logictisVC.isEnter = @"1";
    logictisVC.orderID = self.model.ID;
    [self.navigationController pushViewController:logictisVC animated:YES];
}

-(void)clickReceipt{
    KweakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:[UserDefaultLocationDic valueForKey:@"ifYouReceipt"]
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself OrderReceipt:weakself.model.ID];
    }]];
    [weakself presentViewController:alert animated:true completion:nil];
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
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)CancleOrderl{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"CancelOrder"];
    NSDictionary *param = @{@"id":self.model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickDelete{
    [self DeleteCancelOrder];
}

-(void)DeleteCancelOrder{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"DeleteCancelOrder"];
    NSDictionary *param = @{@"id":self.model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickKefu{
    MMCustomerServiceVC *serviceVC = [[MMCustomerServiceVC alloc]init];
    serviceVC.isDM = @"1";
    serviceVC.orderID = self.model.ID;
    [self.navigationController pushViewController:serviceVC animated:YES];
}

-(void)clickPayOrder{
    [self GetPayHandleMoreOrders];
}

//付款页面
-(void)GetPayHandleMoreOrders{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetPayHandleFirst"];
    NSDictionary *param = @{@"orderid":self.model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
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
        } RequestFaile:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代卖订单详情"];
}
@end
