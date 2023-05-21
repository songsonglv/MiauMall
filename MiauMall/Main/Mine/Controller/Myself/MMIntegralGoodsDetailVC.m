//
//  MMIntegralGoodsDetailVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//  积分商品详情

#import "MMIntegralGoodsDetailVC.h"
#import "MMIntegralModel.h"
#import "MMGoodsDetailBottomView.h"
#import "MMSharePopView.h"
#import "MMCretPosterView.h"
#import <WebKit/WebKit.h>
#import "MMCustomerServiceVC.h"

@interface MMIntegralGoodsDetailVC ()<SDCycleScrollViewDelegate,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMIntegralModel *model;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *pageLabel;//滚动到了第几页
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) CGFloat detailHei;//详情图总高度
@property (nonatomic, strong) NSMutableArray *goodsImageHArr;

@property (nonatomic, strong) MMSharePopView *sharePopView;//分享弹窗
@property (nonatomic, strong) MMCretPosterView *creatPopView;//生成海报弹窗

@property (nonatomic, strong) MMGoodsDetailBottomView *bottomView;
@property (nonatomic, strong) UIButton *collectionBt;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *detailImgView;
@property (nonatomic, strong) UILabel *saleLa;
@property (nonatomic, assign) CGFloat webHei;

@end

@implementation MMIntegralGoodsDetailVC

-(MMGoodsDetailBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[MMGoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
        _bottomView.addCarBt.backgroundColor = TCUIColorFromRGB(0x87d51c);
        _bottomView.exchangeBt.backgroundColor = TCUIColorFromRGB(0x060505);
        [_bottomView.exchangeBt setTitle:[UserDefaultLocationDic valueForKey:@"redeemNow"] forState:(UIControlStateNormal)];
        _bottomView.num = self.model.cartnum;
    }
    return _bottomView;
}


-(SDCycleScrollView *)bannerView{
    if(!_bannerView){
        _bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, -59, WIDTH, WIDTH)];
        _bannerView.imageURLStringsGroup = self.model.Albums;
    }
    return _bannerView;
}

-(WKWebView *)detailImgView{
    if(!_detailImgView){
        _detailImgView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.saleLa.frame) + 20, WIDTH,self.webHei)];
        _detailImgView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _detailImgView.navigationDelegate = self;
        _detailImgView.UIDelegate = self;
        _detailImgView.opaque = NO;
        _detailImgView.scrollView.scrollEnabled = NO;
        [_detailImgView loadHTMLString:self.model.Conts baseURL:nil];
       
        //WKWebView
//        [_detailImgView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _detailImgView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"积分商品详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
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
    
    
    self.sharePopView = [[MMSharePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.sharePopView.tapNumBlock = ^(NSInteger index) {
        if(index == 3){
            [weakself showCreatView];
        }else{
            [ZTProgressHUD showMessage:[NSString stringWithFormat:@"点击了第%ld个按钮",index]];
        }
        
    };
    
//    self.creatPopView = [[MMCretPosterView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.homeModel andGoodsInfo:self.proInfoModel];
//    self.creatPopView.tapNumBlock = ^(NSInteger index) {
//        [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",index]];
//    };
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetInteInfo"];
    NSDictionary *param;
    if(self.ID){
        param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"id":self.ID};
    }else{
        param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"id":self.param[@"id"]};
    }
   
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMIntegralModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{

    KweakSelf(self);
    [ZTProgressHUD hide];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 80)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight, 30, 30)];
    [returnBt setImage:[UIImage imageNamed:@"return_black"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
//    UIButton *moreBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, StatusBarHeight, 30, 30)];
//    [moreBt setImage:[UIImage imageNamed:@"more_black"] forState:(UIControlStateNormal)];
//    [moreBt addTarget:self action:@selector(clickMore) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:moreBt];
    
    UIButton *starBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, StatusBarHeight, 30, 30)];
    [starBt setImage:[UIImage imageNamed:@"star_black"] forState:(UIControlStateNormal)];
    [starBt setImage:[UIImage imageNamed:@"star_icon_select"] forState:(UIControlStateSelected)];
    [starBt addTarget:self action:@selector(requestCollection) forControlEvents:(UIControlEventTouchUpInside)];
    if([self.model.IsColl isEqualToString:@"1"]){
        starBt.selected = YES;
    }
    [self.view addSubview:starBt];
    self.collectionBt = starBt;
    
    [self.view addSubview:self.bottomView];
    
    self.bottomView.homeTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goHome];
    };
    
    self.bottomView.kefuTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goKeFu];
    };
    
    self.bottomView.carTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goShopCar];
    };
    
    self.bottomView.addCarTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself addCar];
    };
    
    self.bottomView.buyNowTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself buyNow];
    };
    
    [scrollView addSubview:self.bannerView];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 42, WIDTH - 28, 28, 14)];
    bgImage.image = [UIImage imageNamed:@"dark_icon"];
    [self.bannerView addSubview:bgImage];
    
    
    UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"1/%ld",self.model.Albums.count] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:9 numberOfLines:0];
    lab.frame = CGRectMake(0, 0, 28, 14);
    [bgImage addSubview:lab];
    self.pageLabel = lab;
    
    UILabel *nameLa = [UILabel publicLab:self.model.Name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    CGSize size = [NSString sizeWithText:self.model.Name font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16] maxSize:CGSizeMake(WIDTH - 48,MAXFLOAT)];
    nameLa.frame = CGRectMake(24, CGRectGetMaxY(self.bannerView.frame) + 25, WIDTH - 48, size.height);
    [scrollView addSubview:nameLa];
    
    UILabel *integralLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",self.model.IntegralFull,[UserDefaultLocationDic valueForKey:@"integral"]] textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:19 numberOfLines:0];
    integralLa.frame = CGRectMake(24, CGRectGetMaxY(nameLa.frame) + 14, WIDTH - 48, 20);
    [scrollView addSubview:integralLa];
    
    UILabel *stockLa = [UILabel publicLab:[NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"istock"],self.model.Number] textColor:TCUIColorFromRGB(0x272727) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    CGSize size1 = [NSString sizeWithText:stockLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    stockLa.frame = CGRectMake(24, CGRectGetMaxY(integralLa.frame) + 14, size1.width, 13);
    [scrollView addSubview:stockLa];
    self.saleLa = stockLa;
    
    UILabel *salesLa = [UILabel publicLab:[NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"iredeemed"],self.model.Sales] textColor:TCUIColorFromRGB(0x272727) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    CGSize size2 = [NSString sizeWithText:salesLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    salesLa.frame = CGRectMake(CGRectGetMaxX(stockLa.frame) + 20, CGRectGetMaxY(integralLa.frame) + 14, size2.width, 13);
    [scrollView addSubview:salesLa];
    
    [scrollView addSubview:self.detailImgView];
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailImgView.frame) + 10);
}

/**  < 法2 >  */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //document.body.offsetHeight
    //document.body.scrollHeight
    //document.body.clientHeight
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        self.detailImgView.height = webView.frame.size.height;
        self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailImgView.frame) + 10);
    }];
 
    
//    CGRect webFrame = self.wkWebView.frame;
//    CGFloat contentHeight = webView.scrollView.contentSize.height;
//    webFrame.size.height = contentHeight;
//    webView.frame = webFrame;
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}
 

#pragma mark -- 监听webview高度变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        self.detailImgView.height =  self.detailImgView.scrollView.contentSize.height;
//        self.detailImgView.height =  self.detailImgView.scrollView.contentSize.height;
//        self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailImgView.frame));
//    }
//}


-(void)goHome{
    self.detailImgView.navigationDelegate = nil;
    self.detailImgView.UIDelegate = nil;
    self.scrollView.delegate = nil;
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)goShopCar{
    self.detailImgView.navigationDelegate = nil;
    self.detailImgView.UIDelegate = nil;
    self.scrollView.delegate = nil;
    self.navigationController.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


-(void)goKeFu{
    MMCustomerServiceVC *serviceVC = [[MMCustomerServiceVC alloc]init];
    serviceVC.goodsName = self.model.Name;
    [self.navigationController pushViewController:serviceVC animated:YES];
}

//请求加入购物车
-(void)addCar{
    NSInteger integralBalance = [self.integral integerValue];
    NSInteger price = [self.model.IntegralFull integerValue];
    if(integralBalance < price){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"jfbuzu"]];
    }else{
        KweakSelf(self);
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }else{
            [param setValue:self.tempcart forKey:@"tempcart"];
        }
       // [param setValue:@"CartPlus" forKey:@"t"];
        
        [param setValue:self.ID forKey:@"id"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [param setValue:@"1" forKey:@"num"];
        [param setValue:@"1" forKey:@"back"];
        [param setValue:@"0" forKey:@"attid"];
        
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
    
    
    
}



-(void)buyNow{
    NSInteger integralBalance = [self.integral integerValue];
    NSInteger price = [self.model.IntegralFull integerValue];
    if(integralBalance < price){
        [ZTProgressHUD showMessage:@"积分不足"];
    }else{
        KweakSelf(self);
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"FastAdd"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
       // [param setValue:@"CartPlus" forKey:@"t"];
        [param setValue:self.tempcart forKey:@"tempcart"];
        [param setValue:self.model.ID forKey:@"id"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
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
}



-(void)clickMore{
    [self showShareView];
}

//分享弹窗
-(void)showShareView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharePopView];
    [self.sharePopView showView];
}

//生成海报弹窗
-(void)showCreatView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.creatPopView];
    [self.creatPopView showView];
}



//请求收藏
-(void)requestCollection{
    KweakSelf(self);
    if(self.memberToken){
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"Collection"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        if(self.ID){
            [param setValue:self.ID forKey:@"id"];
        }else{
            [param setValue:self.param[@"id"] forKey:@"id"];
        }
        
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            weakself.collectionBt.selected = !weakself.collectionBt.selected;
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
        loginVC.modalPresentationStyle = 0;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

-(void)clickReturn{
    self.detailImgView.navigationDelegate = nil;
    self.detailImgView.UIDelegate = nil;
    self.scrollView.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    
    [TalkingDataSDK onPageEnd:@"积分商品详情页面"];
}
@end
