//
//  MMAfterSalesResultVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/19.
//  售后/退款 结果页面

#import "MMAfterSalesResultVC.h"
#import "MMRefundResultModel.h"
#import "MMRefundDetailTopView.h"
#import "MMRefundGoodsInfoView.h"
#import "MMCustomerServiceVC.h"
#import "MMOrderProcessView.h"
#import "MMOrderDetailTrackModel.h"

@interface MMAfterSalesResultVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMRefundResultModel *model;
@property (nonatomic, strong) MMRefundDetailTopView *topView;
@property (nonatomic, strong) MMRefundGoodsInfoView *goodsInfoView;
@property (nonatomic, strong) MMOrderProcessView *processView;//订单进程view
@property (nonatomic, strong) NSString *isAfter;
@end

@implementation MMAfterSalesResultVC

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
        _processView = [[MMOrderProcessView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.goodsInfoView.frame) + 12, WIDTH - 20, hei + 12)];
        _processView.layer.masksToBounds = YES;
        _processView.layer.cornerRadius = 6;
        _processView.tracklist = self.model.tracklist;
    }
    return _processView;
}

-(MMRefundDetailTopView *)topView{
    if(!_topView){
        _topView = [[MMRefundDetailTopView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 90)];
    }
    return _topView;
}

-(MMRefundGoodsInfoView *)goodsInfoView{
    
    if(!_goodsInfoView){
        _goodsInfoView = [[MMRefundGoodsInfoView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.topView.frame) + 12, WIDTH - 20, self.model.itemlist.count * 124 + 168)];
    }
    return _goodsInfoView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"处理结果页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isAfter = @"0";
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"processingResults"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 62, WIDTH, HEIGHT - StatusBarHeight - 62 - 86)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 62 - 86);
    [self.view addSubview:scrollView];
    
    self.topView.model = self.model;
    [scrollView addSubview:self.topView];
    
    self.goodsInfoView.model = self.model;
    self.goodsInfoView.tapGoodsBlock = ^(NSString * _Nonnull router) {
        [weakself RouteJump:router];
    };
    [scrollView addSubview:self.goodsInfoView];
    
    [scrollView addSubview:self.processView];
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.processView.frame) + 20, WIDTH - 40, 36)];
    [cancleBt setBackgroundColor:redColor2];
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"cancelApp"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cancleBt.titleLabel.numberOfLines = 0;
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 18;
    [scrollView addSubview:cancleBt];
    
    if([self.model.CanCancelMoney isEqualToString:@"1"] || [self.model.CanCancelItem isEqualToString:@"1"]){
        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(cancleBt.frame) + 20);
    }else{
        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.processView.frame) + 20);
    }
    
    
//    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 86, WIDTH, 86)];
//    bottomView.backgroundColor = TCUIColorFromRGB(0xffffff);
//    [self.view addSubview:bottomView];
    
//    UIButton *receiptBt = [[UIButton alloc]init];
//    [receiptBt setBackgroundColor:redColor2];
//    [receiptBt setTitle:[UserDefaultLocationDic valueForKey:@"confirmReceipt"] forState:(UIControlStateNormal)];
//    [receiptBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
//    [receiptBt addTarget:self action:@selector(clickReceipt) forControlEvents:(UIControlEventTouchUpInside)];
//    receiptBt.titleLabel.numberOfLines = 0;
//    receiptBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    receiptBt.layer.masksToBounds = YES;
//    receiptBt.layer.cornerRadius = 18;
//    [bottomView addSubview:receiptBt];
//
//    [receiptBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-20);
//            make.top.mas_equalTo(12);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(36);
//    }];
//
//    UIButton *chatBt = [[UIButton alloc]init];
//    [chatBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//    [chatBt setTitle:[UserDefaultLocationDic valueForKey:@"iservice"] forState:(UIControlStateNormal)];
//    [chatBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
//    [chatBt addTarget:self action:@selector(chatKeFu) forControlEvents:(UIControlEventTouchUpInside)];
//    chatBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    chatBt.titleLabel.numberOfLines = 0;
//    chatBt.layer.masksToBounds = YES;
//    chatBt.layer.cornerRadius = 18;
//    chatBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
//    chatBt.layer.borderWidth = 0.5;
//    [bottomView addSubview:chatBt];
//
//    [chatBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(receiptBt.mas_left).offset(-18);
//            make.top.mas_equalTo(12);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(36);
//    }];
    
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetOrderResult"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:self.orderID forKey:@"id"]; //订单ID
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMRefundResultModel mj_objectWithKeyValues:jsonDic];
            if([weakself.model.CanCancelMoney isEqualToString:@"1"]){
                weakself.isAfter = @"0";
            }else if ([weakself.model.CanCancelItem isEqualToString:@"1"]){
                weakself.isAfter = @"1";
            }else{
                weakself.isAfter = @"2";
            }
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickCancle{
    KweakSelf(self);
    NSString *cont;
    if([self.isAfter isEqualToString:@"0"]){
        cont = [UserDefaultLocationDic valueForKey:@"comfigTuikaun"];
    }else{
        cont = [UserDefaultLocationDic valueForKey:@"wantCancel"];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                   message:cont
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:redColor2 forKey:@"titleTextColor"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"iconfirm"]
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [action setValue:selectColor forKey:@"titleTextColor"];
        [weakself requestCancle];
    }]];
    
    

    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)requestCancle{
    KweakSelf(self);
    NSString *url;
    if([self.isAfter isEqualToString:@"0"]){
        url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CancelBuyerRefundMoneyNew"];
    }else{
        url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CancelBuyerRefundMoneyNew"];
    }
    NSDictionary *param = @{@"membertoken":self.memberToken,@"id":self.model.ID,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refundSuccess1" object:nil];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickReceipt{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderReceipt"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)chatKeFu{
    MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
    [self.navigationController pushViewController:customVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

//路由跳转
-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"处理结果页面"];
}
@end
