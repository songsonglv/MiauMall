//
//  MMMineVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMMineVC.h"
#import "MMLoginViewController.h"
#import "MMAddressListViewController.h"
#import "MMSelectCountryVC.h"
#import "MMPartnerViewController.h"
#import "MMWalletViewController.h"
#import "MMMineMainDataModel.h"
#import "MMInvitationCodePopView.h"
#import "MMGetCouponsPopView.h"
#import "MMWishListViewController.h"
#import "MMLiveListViewController.h"
#import "MMOrderListViewController.h"
#import "MMUseMidouPopView.h"
#import "MMTitleContentPopView.h"
#import "MMSetUpViewController.h"
#import "MMMyAssessViewControllerView.h"
#import "MMAfterSalesAssessVC.h"
#import "MMContactUsViewController.h"
#import "MMPointCenterViewController.h"
#import "MMCouponViewController.h"
#import "MMMyCollectionViewController.h"
#import "MMFootPrintViewController.h"
#import "MMLegalProvisionVC.h"
#import "MMCommonProblemVC.h"
#import "MMSuggestedFeedbackVC.h"
#import "MMCustomerServiceVC.h"
#import "MMFootOrCollectGoodsModel.h"
#import "MMSignSuccessPopView.h"
#import "MYNumLabel.h"

@interface MMMineVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMMineMainDataModel *model;
@property (nonatomic, strong) MMInvitationCodePopView *popView;
@property (nonatomic, strong) MMGetCouponsPopView *popView1;
@property (nonatomic, strong) MMUseMidouPopView *popView2;
@property (nonatomic, strong) MMTitleContentPopView *popView3;
@property (nonatomic, strong) MMSignSuccessPopView *signPopView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UIButton *loginBt;//登录按钮
@property (nonatomic, strong) UILabel *codeLa;//邀请码
@property (nonatomic, strong) UILabel *vipLa;
@property (nonatomic, strong) UILabel *todayLa;//领取积分
@property (nonatomic, strong) UIButton *todayBt;//签到领取积分按钮
@property (nonatomic, strong) UIButton *countryBt;//国家按钮 展示国旗

@property (nonatomic, strong) UIButton *payBt;//待付款
@property (nonatomic, strong) UIButton *deliverBt;//待发货
@property (nonatomic, strong) UIButton *receiptBt;//待收货
@property (nonatomic, strong) UIButton *assessBt;//待评价
@property (nonatomic, strong) UIButton *refundBt;//售后/退款
@property (nonatomic, strong) MYNumLabel *readNumLa;
@property (nonatomic, strong) UIButton *partnerBt;
@property (nonatomic, strong) UIImageView *partnerImage;
@property (nonatomic, strong) UILabel *partnerLa;
@property (nonatomic, strong) UIButton *copBT;

@end

@implementation MMMineVC

-(UILabel *)vipLa{
    if(!_vipLa){
        _vipLa = [UILabel publicLab:@"黑卡" textColor:TCUIColorFromRGB(0xf5cd86) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _vipLa.frame = CGRectMake(CGRectGetMaxX(self.nameLa.frame) + 5, StatusBarHeight + 75, 36, 18);
        _vipLa.backgroundColor = TCUIColorFromRGB(0x231815);
    }
    _vipLa.hidden = YES;
    return _vipLa;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.navigationController.navigationBarHidden = YES;
    [TalkingDataSDK onPageBegin:@"个人中心首页"];
    
    NSString *noReadMessage = [self.userDefaults valueForKey:@"NoReadMsg"];
    if([noReadMessage isEqualToString:@"0"]){
        self.minetabBarItem.badgeValue = nil;
        if(self.readNumLa){
            self.readNumLa.hidden = YES;
        }
    }else{
        self.minetabBarItem.badgeValue = noReadMessage;
        if(self.readNumLa){
            self.readNumLa.hidden = NO;
            self.readNumLa.text = noReadMessage;
        }
    }
    [self requestMemberInfo];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.ID = [self.userDefaults valueForKey:@"userID"];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCountryLogo) name:@"selectCountry" object:nil];
    
    [self setUI];
    
    KweakSelf(self);
    self.popView1 = [[MMGetCouponsPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView1.returnCouponBlck = ^(NSString * _Nonnull codeStr) {
        [weakself requestCoupon:codeStr];
    };
    
    self.popView2 = [[MMUseMidouPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView2.tapSureBlock = ^(NSString * _Nonnull money) {
        [ZTProgressHUD showMessage:money];
    };
    self.popView2.tapRuleBlock = ^(NSString * _Nonnull index) {
        [ZTProgressHUD showMessage:@"跳转进入使用规则"];
    };
    
    self.signPopView = [[MMSignSuccessPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    
}

-(void)setUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    [self.view addSubview:scrollView];
    self.mainScrollView = scrollView;
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -59, WIDTH, WIDTH + 65)];
    bgImage.image = [UIImage imageNamed:@"mine_top_bg"];
    [scrollView addSubview:bgImage];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,-59, WIDTH, StatusBarHeight + 255)];
    [scrollView addSubview:view];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(26, StatusBarHeight + 70, 50, 50)];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 25;
    [view addSubview:headImage];
    self.headImage = headImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 150;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(StatusBarHeight + 76);
            make.height.mas_equalTo(23);
    }];
    
    UIButton *loginBt = [[UIButton alloc]init];
    [loginBt addTarget:self action:@selector(goLogin) forControlEvents:(UIControlEventTouchUpInside)];
    loginBt.userInteractionEnabled = NO;
    [view addSubview:loginBt];
    self.loginBt = loginBt;
    
    [loginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(86);
        make.top.mas_equalTo(StatusBarHeight + 76);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *vipLa = [UILabel publicLab:@"黑卡" textColor:TCUIColorFromRGB(0xf5cd86) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    vipLa.backgroundColor = TCUIColorFromRGB(0x231815);
    vipLa.layer.masksToBounds = YES;
    vipLa.layer.cornerRadius = 4;
    vipLa.hidden = YES;
    [view addSubview:vipLa];
    self.vipLa = vipLa;
    
    [vipLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(5);
            make.top.mas_equalTo(StatusBarHeight + 76);
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *codeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    //codeLa.frame = CGRectMake(86, CGRectGetMaxY(nameLa.frame) + 10, MAXFLOAT, 12);
    codeLa.preferredMaxLayoutWidth = 180;
    [codeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:codeLa];
    self.codeLa = codeLa;
    
    [codeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size00 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"fzCopy"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *copyBt = [[UIButton alloc]init];
    [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
    [copyBt setTitleColor:TCUIColorFromRGB(0x131815) forState:(UIControlStateNormal)];
    copyBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    copyBt.layer.masksToBounds = YES;
    copyBt.layer.cornerRadius = 2.5;
    copyBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
    copyBt.layer.borderWidth = 0.5;
    copyBt.hidden = YES;
    [copyBt addTarget:self action:@selector(clickCopyNo) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:copyBt];
    self.copBT = copyBt;
    
    [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(codeLa.mas_right).offset(5);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(7);
            make.width.mas_equalTo(size00.width + 8);
            make.height.mas_equalTo(18);
    }];
    
    UIButton *setUpBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 27, StatusBarHeight + 38, 18, 18)];
    [setUpBt setImage:[UIImage imageNamed:@"setup_icon"] forState:(UIControlStateNormal)];
    [setUpBt addTarget:self action:@selector(clickSetup) forControlEvents:(UIControlEventTouchUpInside)];
    [setUpBt setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [view addSubview:setUpBt];
    
    UIButton *countryBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 54, StatusBarHeight + 38, 18, 18)];
    NSString *img = [self.userDefaults valueForKey:@"countryimage"];
    [countryBt sd_setImageWithURL:[NSURL URLWithString:img] forState:(UIControlStateNormal)];
    countryBt.layer.masksToBounds = YES;
    countryBt.layer.cornerRadius = 9;
    [countryBt addTarget:self action:@selector(seleCountry) forControlEvents:(UIControlEventTouchUpInside)];
    [countryBt setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [view addSubview:countryBt];
    self.countryBt = countryBt;
    
    NSString *str = [UserDefaultLocationDic valueForKey:@"recHoney"];
    CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    
    UIView *todayView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - size.width - 30, StatusBarHeight + 82, size.width + 45, 28)];
    [self setView:todayView andCorlors:@[TCUIColorFromRGB(0x87d51c),TCUIColorFromRGB(0x5dbf02)]];
    todayView.layer.masksToBounds = YES;
    todayView.layer.cornerRadius = 14;
    [view addSubview:todayView];

    UIImageView *iconImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 12, 12)];
    iconImage1.image = [UIImage imageNamed:@"today_icon"];
    [todayView addSubview:iconImage1];
    
    UILabel *todayLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"recHoney"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
//    todayLa.preferredMaxLayoutWidth = 150;
//    [todayLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [todayView addSubview:todayLa];
    self.todayLa = todayLa;
    
    [todayLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(size.width + 4);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 88, StatusBarHeight + 82, 100, 28)];
    [btn1 setBackgroundColor:UIColor.clearColor];
    [btn1 addTarget:self action:@selector(clickToday) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn1];
    self.todayBt = btn1;
    
    
    CGFloat spac = (WIDTH - 226)/2;
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"ipurse"],[UserDefaultLocationDic valueForKey:@"mintegral"],[UserDefaultLocationDic valueForKey:@"icoupon"]];
    NSArray *iconArr = @[@"wallet_icon",@"integral_icon",@"coupon_icon"];
    for (int i = 0; i < arr.count; i++) {
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/3 * i, StatusBarHeight + 140, WIDTH/3, 42)];
        btnView.backgroundColor = UIColor.clearColor;
        [view addSubview:btnView];
        UIImageView *iconI = [[UIImageView alloc]init];
        iconI.image = [UIImage imageNamed:iconArr[i]];
        [btnView addSubview:iconI];
        
        [iconI mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(21);
                    make.height.mas_equalTo(21);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x161616) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(0, 18, WIDTH/3, 42);
        [btnView addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = UIColor.clearColor;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(WIDTH/3 * i, StatusBarHeight + 140, WIDTH/3, 42);
        [view addSubview:btn];
    }
    
    
//    UIButton *vipBt = [[UIButton alloc]initWithFrame:CGRectMake(9, StatusBarHeight + 200, WIDTH - 18, 43)];
//    [vipBt setImage:[UIImage imageNamed:@"vip_bg"] forState:(UIControlStateNormal)];
//    [vipBt addTarget:self action:@selector(clickVip) forControlEvents:(UIControlEventTouchUpInside)];
//    [view addSubview:vipBt];
//    
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view.frame) - 43, WIDTH - 20, 160)];
    orderView.backgroundColor = TCUIColorFromRGB(0xffffff);
    orderView.layer.masksToBounds = YES;
    orderView.layer.cornerRadius = 6;
    [scrollView addSubview:orderView];
    
    CGSize size01 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"myCollect"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
    UIButton *collectionBt = [[UIButton alloc]initWithFrame:CGRectMake(16, 15, size01.width + 23, 17)];
    [collectionBt setImage:[UIImage imageNamed:@"collection_icon"] forState:(UIControlStateNormal)];
    [collectionBt setTitle:[UserDefaultLocationDic valueForKey:@"myCollect"] forState:(UIControlStateNormal)];
    [collectionBt setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
    collectionBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [collectionBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:7];
    [collectionBt addTarget:self action:@selector(clickCollection) forControlEvents:(UIControlEventTouchUpInside)];
    [orderView addSubview:collectionBt];
    
    
    CGSize size02 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"myFootprint"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
    UIButton *footPrintBt = [[UIButton alloc]initWithFrame:CGRectMake(orderView.width - size02.width - 43, 15, size02.width + 23, 17)];
    [footPrintBt setImage:[UIImage imageNamed:@"footprint_icon"] forState:(UIControlStateNormal)];
    [footPrintBt setTitle:[UserDefaultLocationDic valueForKey:@"myFootprint"] forState:(UIControlStateNormal)];
    [footPrintBt setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
    footPrintBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [footPrintBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:6];
    [footPrintBt addTarget:self action:@selector(clickFootPrint) forControlEvents:(UIControlEventTouchUpInside)];
    [orderView addSubview:footPrintBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(7, 46, WIDTH - 34, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [orderView addSubview:line];
    
    UILabel *orderLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"myOrder"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    orderLa.frame = CGRectMake(7, 62, 65, 15);
    [orderView addSubview:orderLa];
    
    
    CGSize size03 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"viewAllOrders"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *lookAllBt = [[UIButton alloc]initWithFrame:CGRectMake(orderView.width - size03.width - 16, 62, size03.width + 6, 13)];
    [lookAllBt setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
    [lookAllBt setTitle:[UserDefaultLocationDic valueForKey:@"viewAllOrders"] forState:(UIControlStateNormal)];
    [lookAllBt setTitleColor:TCUIColorFromRGB(0xa0a0a0) forState:(UIControlStateNormal)];
    lookAllBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [lookAllBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    lookAllBt.tag = 200;
    [lookAllBt addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    [orderView addSubview:lookAllBt];
    
    NSArray *arr2 = @[[UserDefaultLocationDic valueForKey:@"pendingPayment"],[UserDefaultLocationDic valueForKey:@"toBeShipped"],[UserDefaultLocationDic valueForKey:@"toReceived"],[UserDefaultLocationDic valueForKey:@"toEvaluated"]];
                      //,[UserDefaultLocationDic valueForKey:@"afterSales"]];
    NSArray *iconArr2 = @[@"pay_icon",@"deliver_icon",@"receipt_icon",@"assess_icon"];
                          //,@"refund_icon"];
    CGFloat wid0 = (WIDTH - 20)/arr2.count;
    for (int i = 0; i < arr2.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid0 * i, 97, wid0, 50)];
        [orderView addSubview:view];
        
        UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        ima.centerX = view.width/2;
        ima.image = [UIImage imageNamed:iconArr2[i]];
        [view addSubview:ima];
        
        if(i == 0 || i == 2){
            ima.size = CGSizeMake(24, 22);
        }
        
        UILabel *lab = [UILabel publicLab:arr2[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
//        lab.frame = CGRectMake(0, 38, wid0, 12);
        lab.preferredMaxLayoutWidth = wid0;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(38);
                    make.width.mas_equalTo(wid0);
        }];
        
        if([self.lang isEqualToString:@"1"]){
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.top.mas_equalTo(26);
                        make.width.mas_equalTo(wid0);
            }];
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid0, 50)];
        btn.tag = 201 + i;
        [btn addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((spac2 + 60) * i + spac2, 97, 60, 50)];
//        [btn setImage:[UIImage imageNamed:iconArr2[i]] forState:(UIControlStateNormal)];
//        [btn setTitle:arr2[i] forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:17];
//        btn.tag = 201 + i;
        
    }
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderView.frame) + 12, WIDTH - 20, 96)];
    centerView.backgroundColor = TCUIColorFromRGB(0xffffff);
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 6;
    [scrollView addSubview:centerView];
    
    CGFloat wid = (WIDTH - 20)/4;
    NSArray *arr3 = @[[UserDefaultLocationDic valueForKey:@"liveStream"],[UserDefaultLocationDic valueForKey:@"shaidan"],[UserDefaultLocationDic valueForKey:@"wishList"],[UserDefaultLocationDic valueForKey:@"starPushMan"]];
    NSArray *iconArr3 = @[@"live_icon_orange",@"share_order_icon",@"wish_icon",@"recommend_icon"];
    for (int i = 0; i < arr3.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 12, wid, 66)];
        [btn setTitle:arr3[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:iconArr3[i]] forState:(UIControlStateNormal)];
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:7];
        btn.tag = 300 + i;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [btn addTarget:self action:@selector(clickCenter:) forControlEvents:(UIControlEventTouchUpInside)];
        [centerView addSubview:btn];
    }
    
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(centerView.frame) + 12, WIDTH - 20, 240)];
    serviceView.backgroundColor = TCUIColorFromRGB(0xffffff);
    serviceView.layer.masksToBounds = YES;
    serviceView.layer.cornerRadius = 6;
    [scrollView addSubview:serviceView];
    
    UILabel *serviceLa = [UILabel publicLab:@"我的服务" textColor:TCUIColorFromRGB(0x281315) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    serviceLa.frame = CGRectMake(7, 17, 65, 15);
    [serviceView addSubview:serviceLa];
    CGFloat wid1 = (WIDTH - 20)/4;
    NSArray *arr4 = @[[UserDefaultLocationDic valueForKey:@"yqCode"],[UserDefaultLocationDic valueForKey:@"collectCoupons"],[UserDefaultLocationDic valueForKey:@"myEvaluation"],[UserDefaultLocationDic valueForKey:@"customerService"],[UserDefaultLocationDic valueForKey:@"gouManyi"],[UserDefaultLocationDic valueForKey:@"clauseAgreement"],[UserDefaultLocationDic valueForKey:@"commonProblem"],[UserDefaultLocationDic valueForKey:@"woYaoTuZao"],[UserDefaultLocationDic valueForKey:@"address"],[UserDefaultLocationDic valueForKey:@"heHuoRen"]];
    NSArray *iconArr4 = @[@"invitation_icon",@"exchange_icon",@"my_assess_icon",@"kefu_icon",@"chat_me_icon",@"clause_icon",@"question_icon",@"roast_icon",@"address_icon",@"partner_icon_black"];
    
    
    for (int i = 0; i < arr4.count; i++) {
        NSInteger h = i/4;
        NSInteger v = i%4;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * v, 46 + 66 * h, wid1, 44)];
        [serviceView addSubview:view];

        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageV.centerX = wid1/2;
        imageV.image = [UIImage imageNamed:iconArr4[i]];
        [view addSubview:imageV];

        UILabel *lab = [UILabel publicLab:arr4[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        lab.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame) + 10, wid1, 11);
        [view addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid1, 44)];
//        [btn setTitle:arr4[i] forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
//        [btn setImage:[UIImage imageNamed:iconArr4[i]] forState:(UIControlStateNormal)];
//        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:12];
    
        btn.tag = 400 + i;
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        [btn addTarget:self action:@selector(clickService:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        if(i == 9){
            self.partnerBt = btn;
            self.partnerImage = imageV;
            self.partnerLa = lab;
        }
        
        if(i == 3){
            MYNumLabel *numLa = [[MYNumLabel alloc]initWithFrame:CGRectMake(btn.width/2 + 10, -5, 14, 14)];
            numLa.backgroundColor = redColor2;
            numLa.layer.masksToBounds = YES;
            numLa.layer.cornerRadius = 7;
            numLa.textColor = TCUIColorFromRGB(0xffffff);
            numLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
            numLa.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:numLa];
            self.readNumLa = numLa;
            
            NSString *readNum = [self.userDefaults valueForKey:@"NoReadMsg"];
            if([readNum isEqualToString:@"0"]){
                self.readNumLa.hidden = YES;
            }else{
                self.readNumLa.text = readNum;
            }
        }
    }
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(serviceView.frame) + 20);
    
}

-(void)clickSetup{
    MMSetUpViewController *setupVC = [[MMSetUpViewController alloc]init];
    [self.navigationController pushViewController:setupVC animated:YES];
}

-(void)changeCountryLogo{
   NSString *img = [self.userDefaults valueForKey:@"countryimage"];
    [self.countryBt sd_setImageWithURL:[NSURL URLWithString:img] forState:(UIControlStateNormal)];
}

-(void)requestNoRead{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetKeFuNotice"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)requestMemberInfo{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMMineMainDataModel mj_objectWithKeyValues:jsonDic];
            NSInteger newCount = [weakself.model.newcount integerValue];
           
            if([weakself.model.memberInfo.ID isEqualToString:@"0"]){
                weakself.nameLa.text = weakself.model.memberInfo.Name;
                weakself.headImage.image = [UIImage imageNamed:@"me_head"];
                weakself.loginBt.userInteractionEnabled = YES;
                weakself.codeLa.text = @"";
                weakself.copBT.hidden = YES;
            }else{
                weakself.copBT.hidden = NO;
                weakself.loginBt.userInteractionEnabled = NO;
                [[NSUserDefaults standardUserDefaults] setValue:weakself.model.memberInfo.WeixinAccount forKey:@"WXAccount"];
                [[NSUserDefaults standardUserDefaults] setValue:weakself.model.memberInfo.Email forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults] setValue:weakself.model.memberInfo.CurrencyImg forKey:@"countryimage"];
                [weakself.userDefaults setValue:weakself.model.memberInfo.Currency_Bind forKey:@"area"];
                [weakself.countryBt sd_setImageWithURL:[NSURL URLWithString:weakself.model.memberInfo.CurrencyImg] forState:(UIControlStateNormal)];
                if(!weakself.model.memberInfo.Picture || [weakself.model.memberInfo.Picture isEqualToString:@""]){
                    weakself.headImage.image = [UIImage imageNamed:@"me_head"];
                }else{
                    [weakself.headImage sd_setImageWithURL:[NSURL URLWithString:weakself.model.memberInfo.Picture]];
                }
                
                if([weakself.model.memberInfo.IsAnchor isEqualToString:@"0"]){
                    weakself.partnerBt.hidden = YES;
                    weakself.partnerLa.hidden = YES;
                    weakself.partnerImage.hidden = YES;
                }else{
                    weakself.partnerBt.hidden = NO;
                    weakself.partnerLa.hidden = NO;
                    weakself.partnerImage.hidden = NO;
                }
                
                weakself.nameLa.text = weakself.model.memberInfo.Name;
                weakself.codeLa.text = [NSString stringWithFormat:@"ID:%@",weakself.model.memberInfo.ID];
                NSDictionary *memberDic = @{@"name":weakself.model.memberInfo.Name,@"pic":weakself.model.memberInfo.Picture,@"ID":weakself.model.memberInfo.ID};
                BOOL success =  [NSKeyedArchiver archiveRootObject:memberDic toFile:MemberInfoPath];
                
                [weakself.userDefaults synchronize];
                if([weakself.model.memberInfo.IsClickToday isEqualToString:@"1"]){
                    weakself.todayLa.text = [UserDefaultLocationDic valueForKey:@"received"];
                    weakself.todayBt.userInteractionEnabled = YES;
                }else{
                    weakself.todayLa.text = [UserDefaultLocationDic valueForKey:@"recHoney"];
                }
            }
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickGetCoupon{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView1];
    [self.popView1 showView];
}


-(void)requestCoupon:(NSString *)code{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ExtractCoupon"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:code forKey:@"CouponCode"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself.popView1 hideView];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)goLogin{
    MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
    loginVC.modalPresentationStyle = 0;
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void)clickBt:(UIButton *)sender{
    if(self.memberToken){
        if(sender.tag == 100){
            MMWalletViewController *wallteVC = [[MMWalletViewController alloc]init];
            [self.navigationController pushViewController:wallteVC animated:YES];
        }else if (sender.tag == 101){
            MMPointCenterViewController *pointVC = [[MMPointCenterViewController alloc]init];
            [self.navigationController pushViewController:pointVC animated:YES];
        }else{
            MMCouponViewController *couponVC = [[MMCouponViewController alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
    }else{
        [self goLogin];
    }
    
}

-(void)clickVip{
    [ZTProgressHUD showMessage:@"进入黑卡"];
}

-(void)clickCollection{
    if(self.memberToken){
        MMMyCollectionViewController *collectionVC = [[MMMyCollectionViewController alloc]init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }else{
        [self goLogin];
    }
   
}

-(void)clickFootPrint{
    if(self.memberToken){
        MMFootPrintViewController *footVC = [[MMFootPrintViewController alloc]init];
        [self.navigationController pushViewController:footVC animated:YES];
    }else{
        [self goLogin];
    }
   
}

-(void)clickCenter:(UIButton *)sender{
    if(sender.tag == 300){
        [self clickLive];
    }else if (sender.tag == 301){
        if(self.memberToken){
            [self RouteJump:@"/member/share_order"];
        }else{
            [self goLogin];
        }
        
    }else if (sender.tag == 302){
        if(self.memberToken){
            [self clickWish];
        }else{
            [self goLogin];
        }
        
    }else{
        [self RouteJump:@"/secondPages/market/xingtui"];
    }
}

-(void)clickOutLogin{
    MMLoginViewController*loginVC = [[MMLoginViewController alloc]init];
    loginVC.modalPresentationStyle = 0;
    [self presentViewController:loginVC animated:NO completion:nil];
}

-(void)seleCountry{
    MMSelectCountryVC *countryVC = [[MMSelectCountryVC alloc]init];
    [self.navigationController pushViewController:countryVC animated:YES];
}

-(void)clickAddress{
    MMAddressListViewController *addressVC = [[MMAddressListViewController alloc]init];
    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)clickOrder:(UIButton *)sender{
    if(self.memberToken){
        MMOrderListViewController *orderVC = [[MMOrderListViewController alloc]init];
        orderVC.index = sender.tag - 200;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self goLogin];
    }
    
}

-(void)GetBrowseRecord{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetBrowseRecord"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"1" forKey:@"limit"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.lang forKey:@"lang"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMFootOrCollectGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            MMFootOrCollectGoodsModel *model1 = arr[0];
            MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
            customVC.goodsName = model1.Name;
            [weakself.navigationController pushViewController:customVC animated:YES];
        }else{
            MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
            [weakself.navigationController pushViewController:customVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickService:(UIButton *)sender{
    if(self.memberToken){
        if(sender.tag == 400){
            [self clickinvitation];
        }else if (sender.tag == 401){
            [self clickGetCoupon];
        }else if (sender.tag == 402){
            MMMyAssessViewControllerView *myAssessVC = [[MMMyAssessViewControllerView alloc]init];
            [self.navigationController pushViewController:myAssessVC animated:YES];
        }else if (sender.tag == 403){
            
            [self GetBrowseRecord];
        }else if (sender.tag == 404){
            MMContactUsViewController *contactUsVC = [[MMContactUsViewController alloc]init];
            [self.navigationController pushViewController:contactUsVC animated:YES];
        }else if (sender.tag == 405){
            MMLegalProvisionVC *legalVC = [[MMLegalProvisionVC alloc]init];
            [self.navigationController pushViewController:legalVC animated:YES];
        }else if (sender.tag == 406){
            MMCommonProblemVC *questionVC = [[MMCommonProblemVC alloc]init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }else if (sender.tag == 407){
            MMSuggestedFeedbackVC *feedVC = [[MMSuggestedFeedbackVC alloc]init];
            [self.navigationController pushViewController:feedVC animated:YES];
        }else if (sender.tag == 408){
            [self clickAddress];
        }else if (sender.tag == 409){
            [self clickPartner];
        }else{
            [ZTProgressHUD showMessage: [NSString stringWithFormat:@"%ld",sender.tag]];
        }
    }else{
        if (sender.tag == 403){
            [self GetBrowseRecord];
        }else if (sender.tag == 404){
            MMContactUsViewController *contactUsVC = [[MMContactUsViewController alloc]init];
            [self.navigationController pushViewController:contactUsVC animated:YES];
        }else if (sender.tag == 405){
            MMLegalProvisionVC *legalVC = [[MMLegalProvisionVC alloc]init];
            [self.navigationController pushViewController:legalVC animated:YES];
        }else if (sender.tag == 406){
            MMCommonProblemVC *questionVC = [[MMCommonProblemVC alloc]init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }else{
            [self goLogin];
        }
    }
    
}

-(void)clickToday{
    KweakSelf(self);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ClickToday"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];

    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.todayLa.text = @"已领取";
            weakself.signPopView.pointNum = jsonDic[@"key"];
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.signPopView];
            [weakself.signPopView showView];

        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



-(void)clickLive{
    MMLiveListViewController *liveVC = [[MMLiveListViewController alloc]init];
    [self.navigationController pushViewController:liveVC animated:YES];
}

-(void)clickPartner{
    MMPartnerViewController *partnerVC = [[MMPartnerViewController alloc]init];
    [self.navigationController pushViewController:partnerVC animated:YES];
}



-(void)clickMidou{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView2];
    [self.popView2 showView];
}

-(void)clickWish{
    MMWishListViewController *wishVC = [[MMWishListViewController alloc]init];
    [self.navigationController pushViewController:wishVC animated:YES];
}

-(void)clickCancle{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView3];
    [self.popView3 showView];
}

-(void)clickinvitation{
    self.popView = [[MMInvitationCodePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andModel:self.model];
    self.popView.clickShareBlock = ^(NSString * _Nonnull str) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)clickCopyNo{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.memberInfo.ID;
    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeLanguage:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"中文"]){
        [self.btn setTitle:@"英文" forState:(UIControlStateNormal)];
    }else{
        [self.btn setTitle:@"中文" forState:(UIControlStateNormal)];
    }
    //修改本地获取的语言文件
       NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
       if ([language isEqualToString: @"en"]) {
           [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
       }else {
           [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
       }
       [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
}

#pragma mark -- uiscrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"个人中心首页"];
}

@end
