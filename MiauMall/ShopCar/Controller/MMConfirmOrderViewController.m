//
//  MMConfirmOrderViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//  确认订单页面

#import "MMConfirmOrderViewController.h"
#import "MMAddressModel.h"
#import "MMConfirmOrderModel.h"
#import "MMPackageView.h"
#import "MMAddressListViewController.h"
#import "MMConfirmOrderMoneyView.h"
#import "MMConfirmGoodsPopView.h"
#import "MMUseMidouPopView.h"
#import "MMConfirmShipDateModel.h"
#import "MMCouponInfoModel.h"
#import "MMSelectCouponPopView.h"
#import "MMCalendarViewController.h"
#import "MMShipMentPopView.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"
#import "MMCollageListViewController.h"

@interface MMConfirmOrderViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMAddressModel *addressModel;
@property (nonatomic, strong) NSString *adsid;//默认空
@property (nonatomic, strong) NSString *adsid2;
@property (nonatomic, strong) NSString *adsid3;
@property (nonatomic, strong) NSString *remark1;//默认空
@property (nonatomic, strong) NSString *remark2;
@property (nonatomic, strong) NSString *remark3;
@property (nonatomic, strong) NSString *CouponID;//优惠券ID 默认为空
@property (nonatomic, strong) NSString *UseCoupon; //使用优惠券 默认0

@property (nonatomic, strong) NSString *UseInt; //使用积分 默认0
@property (nonatomic, strong) NSString *UseInteg; //使用积分数量？ 默认0
@property (nonatomic, strong) NSString *UseDiscountCode; //使用折扣码 默认0
@property (nonatomic, strong) NSString *DiscountCode; //折扣码 默认空
@property (nonatomic, strong) NSString *UseCardGift; //使用优惠券 默认0
@property (nonatomic, strong) NSString *GiftID; //默认0
@property (nonatomic, strong) NSString *UseSign;
@property (nonatomic, strong) MMPackageView *packView1;
@property (nonatomic, strong) MMPackageView *packView2;
@property (nonatomic, strong) MMPackageView *packView3;

@property (nonatomic, strong) MMConfirmOrderModel *model;
@property (nonatomic, strong) MMConfirmShipDateModel *dateModel;

@property (nonatomic, strong) UILabel *tipLa;//中国地址的提示性文字
@property (nonatomic, strong) UIImageView *tipIcon;
@property (nonatomic, assign) CGFloat topHei;

@property (nonatomic, strong) UIView *couView;//凑单显示

@property (nonatomic, strong) MMConfirmOrderMoneyView *moneyView;
@property (nonatomic, strong) MMUseMidouPopView *midouPop;

@property (nonatomic, strong) NSMutableArray *couponArr;//优惠券数组
@property (nonatomic, strong) MMSelectCouponPopView *couponPop;
@property (nonatomic, strong) UIView *shipView;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UILabel *moneyLa;

@property (nonatomic, strong) MMShipMentPopView *shipPop;
@end

@implementation MMConfirmOrderViewController

-(NSMutableArray *)couponArr{
    if(!_couponArr){
        _couponArr = [NSMutableArray array];
    }
    return _couponArr;
}

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
        _bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
        UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"应付%@(共%@件)",self.model.PayMoneyShow,self.model.BuyNum] textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 138;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_bottomV addSubview:lab];
        self.moneyLa = lab;
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(22);
                    make.height.mas_equalTo(18);
        }];
        
        NSArray *temp=[_model.PayMoneyShow componentsSeparatedByString:@" "];
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"应付：").textColor(TCUIColorFromRGB(0x6c6c6c)).font([UIFont systemFontOfSize:13]);
            confer.text(temp[0]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:11]);
            confer.text(temp[1]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:20]);
            confer.text([NSString stringWithFormat:@"(共%@件)",self.model.BuyNum]).textColor(TCUIColorFromRGB(0x6c6c6c)).font([UIFont systemFontOfSize:12]);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 120, 8, 100, 40)];
        [btn setTitle:@"提交订单" forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20;
        [btn setBackgroundColor:redColor2];
        [btn addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomV addSubview:btn];
    }
    return _bottomV;
}

-(UIView *)shipView{
    KweakSelf(self);
    if(!_shipView){
        _shipView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 115, WIDTH, 35)];
        _shipView.backgroundColor = TCUIColorFromRGB(0xfee6e3);
        UILabel *lab = [UILabel publicLab:self.model.EstimatedShipment textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 66;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_shipView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.centerY.mas_equalTo(weakself.shipView);
                    make.height.mas_equalTo(12);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 150, 35)];
        btn.backgroundColor = UIColor.clearColor;
        [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_shipView addSubview:btn];
        
        UIButton *dateBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50, 7, 20, 20)];
        [dateBt setImage:[UIImage imageNamed:@"date_icon"] forState:(UIControlStateNormal)];
        [dateBt addTarget:self action:@selector(clickDate) forControlEvents:(UIControlEventTouchUpInside)];
        [_shipView addSubview:dateBt];
    }
    return _shipView;
}

-(UIView *)couView{
    KweakSelf(self);
    if(!_couView){
        _couView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topHei, WIDTH - 10, 32)];
        if([self.cry isEqualToString:@"9"]){
            _couView.y = CGRectGetMaxY(self.tipLa.frame) + 12;
        }
        _couView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 104;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [_couView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(8);
                    make.centerY.mas_equalTo(weakself.couView);
                    make.width.mas_equalTo(WIDTH - 104);
        }];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"包邮小助手您还差").textColor(TCUIColorFromRGB(0x1e1e1e));
            confer.text(self.model.FreeShipNeedMoneyShow).textColor(redColor2);
            confer.text(@"可包邮").textColor(TCUIColorFromRGB(0x1e1e1e));
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"去补单" forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [btn setBackgroundColor:redColor2];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 12;
        [btn addTarget:self action:@selector(clickCou) forControlEvents:(UIControlEventTouchUpInside)];
        [_couView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.centerY.mas_equalTo(weakself.couView);
                    make.width.mas_equalTo(66);
                    make.height.mas_equalTo(24);
        }];
    }
    return _couView;
}

-(MMConfirmOrderMoneyView *)moneyView{
    KweakSelf(self);
    if(!_moneyView){
        _moneyView = [[MMConfirmOrderMoneyView alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(self.couView.frame) +  12, WIDTH - 10, 248) andType:@"0"];
        _moneyView.model = self.model;
        _moneyView.dateModel = self.dateModel;
        if([self.model.FreeShipNeedMoney isEqualToString:@"0"]){
            if([self.cry isEqualToString:@"9"]){
                _moneyView.y = CGRectGetMaxY(self.tipLa.frame) + 12;
            }else{
                _moneyView.y = self.topHei;
            }
        }
        _moneyView.selectCouponBlock = ^(NSString * _Nonnull str) {
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.couponPop];
            [weakself.couponPop showView];
        };
        
        _moneyView.inputDiscoundCodeBlock = ^(NSString * _Nonnull code) {
            weakself.UseCoupon = @"0";
            weakself.UseDiscountCode = @"1";
            weakself.CouponID = @"";
            [weakself CheckDiscountCode:code];
        };
        
        _moneyView.selectInteBlock = ^(NSString * _Nonnull str) {
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.midouPop];
            [weakself.midouPop showView];
        };
    }
    return _moneyView;
}

-(UILabel *)tipLa{
    if(!_tipLa){
        _tipLa = [UILabel publicLab:[NSString stringWithFormat:@"    %@",self.model.ShunfengTips] textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        CGSize size = [NSString sizeWithText:_tipLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(WIDTH - 40,MAXFLOAT)];
        _tipLa.frame = CGRectMake(18, self.topHei, WIDTH - 40, size.height);
    }
    return _tipLa;
}

-(UIImageView *)tipIcon{
    if(!_tipIcon){
        _tipIcon = [[UIImageView alloc]initWithFrame:CGRectMake(18, self.topHei + 2, 12, 12)];
        _tipIcon.image = [UIImage imageNamed:@"tips_icon"];
    }
    return _tipIcon;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"确认订单页面"];
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
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
    titleView.titleLa.text = @"确认订单";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    NSData *data = [NSData dataWithContentsOfFile:UserDefaultsAddressPath];
    if(!data || data == nil){
//        NSDictionary * addressDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        self.addressModel = [MMAddressModel mj_objectWithKeyValues:addressDic];
    }else{
        NSDictionary * addressDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.addressModel = [MMAddressModel mj_objectWithKeyValues:addressDic];
    }
    if(self.addressModel){
        self.adsid = self.addressModel.ID;
    }
    self.CouponID = @"0";
    
    self.UseInt = @"0";
    self.UseSign = @"0";
    self.UseInteg = @"0";
    self.UseCoupon = @"0";
    self.UseCardGift = @"0";
    self.UseDiscountCode = @"0";
    self.GiftID = @"0";
    
    self.couponPop = [[MMSelectCouponPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.couponPop.tapSureBlock = ^(NSString * _Nonnull isSelect) {
        weakself.UseCoupon = @"0";
        weakself.UseDiscountCode = @"1";
        weakself.CouponID = @"";
        [weakself refreshData];
    };
    self.couponPop.selectCouponBlock = ^(NSString * _Nonnull couponID, NSString * _Nonnull isSelect) {
        weakself.UseDiscountCode = @"0";
        weakself.UseCoupon = @"1";
        weakself.CouponID= couponID;
        [weakself refreshData];
    };
   
    
    [self loadHttpRequest];
    // Do any additional setup after loading the view.
}

-(void)loadHttpRequest{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求购物车商品数据
        [weakself GetCanNotShipmentDate];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求足迹列表
        [weakself GetDownMsgMoreOrders];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求优惠券列表
        [weakself GetPayCoupon];
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

-(void)GetCanNotShipmentDate{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCanNotShipmentDate"];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.dateModel = [MMConfirmShipDateModel mj_objectWithKeyValues:jsonDic];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetDownMsgMoreOrders{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSDictionary *param1 = @{@"GiftID":self.GiftID,@"UseInt":self.UseInt,@"UseInteg":self.UseInteg,@"UseCoupon":self.UseCoupon,@"UseDiscountCode":self.UseDiscountCode,@"UseSign":self.UseSign,@"UseCardGift":self.UseCardGift,@"lang":self.lang,@"cry":self.cry};
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetDownMsgMoreOrders"];
   
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    
    if(self.adsid){
        [param setValue:self.adsid forKey:@"adsid"];
    }
   
    if(self.adsid2){
        [param setValue:self.adsid2 forKey:@"adsid2"];
    }
    
    if(self.adsid3){
        [param setValue:self.adsid3 forKey:@"adsid3"];
    }
    
    if(self.CouponID){
        [param setValue:self.CouponID forKey:@"CouponID"];
    }
    
    if(self.DiscountCode){
        [param setValue:self.DiscountCode forKey:@"DiscountCode"];
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([str isEqualToString:@"1"]){
            weakself.model = [MMConfirmOrderModel mj_objectWithKeyValues:jsonDic];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    self.DiscountCode = self.dateModel.DiscountCode;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 64);
    [self.view addSubview:scrollView];
    
    self.midouPop = [[MMUseMidouPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.midouPop.model = self.model;
    self.midouPop.tapSureBlock = ^(NSString * _Nonnull money) {
        [ZTProgressHUD showMessage:money];
    };
    self.midouPop.tapSureBlock = ^(NSString * _Nonnull num) {
        if([num isEqualToString:@"0"]){
            
        }else{
            weakself.UseInt = @"1";
            weakself.UseInteg = num;
            [weakself refreshData];
        }
    };
    self.midouPop.tapRuleBlock = ^(NSString * _Nonnull index) {
        [weakself goIntegralRule];
    };
    
    self.shipPop = [[MMShipMentPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andContent:self.model.ShipmentTips];
    
    NSInteger index = 0;
    if(self.model.list3.count > 0){
        index = 3;
    }else if (self.model.list2.count > 0){
        index = 2;
    }else{
        index = 1;
    }
    
  
    CGFloat hei = 317;
    self.topHei =  hei * (index - 1) + hei + 27;
    
    for (int i = 0; i < index; i++) {
        NSString *weight = self.model.Weight[index - 1];
        MMConfirmGoodsPopView *goodsPop = [[MMConfirmGoodsPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andIndex:i];
        goodsPop.model = self.model;
        goodsPop.jumpRouterBlock = ^(NSString * _Nonnull router) {
            [weakself RouteJump:router];
        };
        
        MMPackageView *packageView = [[MMPackageView alloc]initWithFrame:CGRectMake(5,10 + hei * i, WIDTH - 10, 305)];
        packageView.weightStr = weight;
        packageView.index = i;
        packageView.model = self.model;
        
        
           
        if(i == 0){
            if(self.addressModel){
                packageView.addressModel = self.addressModel;
            }
        }
        
        
        
        
        packageView.tapListBlock = ^(NSInteger index) {
            [[UIApplication sharedApplication].keyWindow addSubview:goodsPop];
            [goodsPop showView];
        };
        
        packageView.returnRemarkBlock = ^(NSString * _Nonnull remark, NSInteger index) {
            if(index == 0){
                weakself.remark1 = remark;
            }else if (index == 1){
                weakself.remark2 = remark;
            }else{
                weakself.remark3 = remark;
            }
        };
        packageView.seleAddressBlock = ^(NSInteger index) {
            [weakself selectAddress:index];
        };
       
        [scrollView addSubview:packageView];
        
        
       
        
        
        if(i == 0){
            self.packView1 = packageView;
        }else if ( i == 1){
            self.packView2 = packageView;
        }else{
            self.packView3 = packageView;
        }
    }
    
    if([self.cry isEqualToString:@"9"]){
        [scrollView addSubview:self.tipLa];
        [scrollView addSubview:self.tipIcon];
    }
    
    if([self.model.FreeShipNeedMoney isEqualToString:@"0"]){
        
    }else{
        [scrollView addSubview:self.couView];
    }
    
    [scrollView addSubview:self.moneyView];
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.moneyView.frame) + 80);
    
    [self.view addSubview:self.shipView];
    [self.view addSubview:self.bottomV];
    
    if(self.couponArr.count > 0){
        MMCouponInfoModel *model = self.couponArr[0];
        self.UseDiscountCode = @"0";
        self.UseCoupon = @"1";
        self.CouponID= model.ID;
        [self refreshData];
    }else{
        self.DiscountCode = self.dateModel.DiscountCode;
        self.UseDiscountCode = @"1";
        [self refreshData];
    }
    
    
    
    
}

-(void)GetPayCoupon{
    KweakSelf(self);

     NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayCoupon"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMCouponInfoModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.couponArr = [NSMutableArray arrayWithArray:arr];
            weakself.couponPop.arr = weakself.couponArr;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)CheckDiscountCode:(NSString *)code{
    KweakSelf(self);
    NSDictionary *param = @{@"membertoken":self.memberToken,@"DiscountCode":code,@"lang":self.lang,@"cry":self.cry};
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CheckDiscountCode"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([str isEqualToString:@"1"]){
            weakself.DiscountCode = code;
            [weakself refreshData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//重写请求接口 刷新数据
-(void)refreshData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetDownMsgMoreOrders"];
   
    NSDictionary *param1 = @{@"GiftID":self.GiftID,@"UseInt":self.UseInt,@"UseInteg":self.UseInteg,@"UseCoupon":self.UseCoupon,@"UseDiscountCode":self.UseDiscountCode,@"UseSign":self.UseSign,@"UseCardGift":self.UseCardGift,@"lang":self.lang,@"cry":self.cry};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.adsid){
        [param setValue:self.adsid forKey:@"adsid"];
    }
   
    if(self.adsid2){
        [param setValue:self.adsid2 forKey:@"adsid2"];
    }
    
    if(self.adsid3){
        [param setValue:self.adsid3 forKey:@"adsid3"];
    }
    
    if(self.DiscountCode){
        [param setValue:self.DiscountCode forKey:@"DiscountCode"];
    }
    if(self.CouponID){
        [param setValue:self.CouponID forKey:@"CouponID"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMConfirmOrderModel mj_objectWithKeyValues:jsonDic];
            weakself.moneyView.model = weakself.model;
            NSArray *temp=[weakself.model.PayMoneyShow componentsSeparatedByString:@" "];
            [weakself.moneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text(@"应付：").textColor(TCUIColorFromRGB(0x6c6c6c)).font([UIFont systemFontOfSize:13]);
                confer.text(temp[0]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:11]);
                confer.text(temp[1]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:20]);
                confer.text([NSString stringWithFormat:@"(共%@件)",self.model.BuyNum]).textColor(TCUIColorFromRGB(0x6c6c6c)).font([UIFont systemFontOfSize:12]);
            }];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickBtn{
    [[UIApplication sharedApplication].keyWindow addSubview:self.shipPop];
    [self.shipPop showView];
}

//凑单
-(void)clickCou{
    MMCollageListViewController *collageListVC = [[MMCollageListViewController alloc]init];
    [self.navigationController pushViewController:collageListVC animated:YES];
}

#pragma mark -- 弹出日历
-(void)clickDate{
    MMCalendarViewController *calendarVC = [[MMCalendarViewController alloc]init];
    calendarVC.timeArr = self.dateModel.TimeStr;
    
    calendarVC.timeStr = [self.model.DelayShipmentTime substringToIndex:10];
    calendarVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:calendarVC animated:YES completion:nil];
}

#pragma mark -- 选择地址
-(void)selectAddress:(NSInteger)index{
    KweakSelf(self);
    MMAddressListViewController *addressVC = [[MMAddressListViewController alloc]init];
    addressVC.isEnter = @"0";
    addressVC.returnAddressBlock = ^(MMAddressModel * _Nonnull model) {
        weakself.addressModel = model;
        if(index == 0){
            weakself.packView1.addressModel = model;
            weakself.adsid = model.ID;
        }else if (index == 1){
            weakself.packView2.addressModel = model;
            weakself.adsid2 = model.ID;
        }else{
            weakself.packView3.addressModel = model;
            weakself.adsid3 = model.ID;
        }
        [weakself refreshData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goIntegralRule{
    MMIntegralRuleVC *vc = [[MMIntegralRuleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)RouteJump:(NSString *)routers{
        NSLog(@"跳转route为%@",routers);
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
        
   
}


-(void)clickPay{
   
    NSString *ProductList;
    NSString *ProductList2;
    NSString *ProductList3;
    
    if(self.model.list3.count > 0){
        ProductList = [self gs_jsonStringCompactFormatForNSArray:self.model.list];
        ProductList2 = [self gs_jsonStringCompactFormatForNSArray:self.model.list2];
        ProductList3 = [self gs_jsonStringCompactFormatForNSArray:self.model.list3];

    }else if (self.model.list2.count > 0){
        ProductList = [self gs_jsonStringCompactFormatForNSArray:self.model.list];
        ProductList2 = [self gs_jsonStringCompactFormatForNSArray:self.model.list2];
    }else{
        ProductList = [self gs_jsonStringCompactFormatForNSArray:self.model.list];
    }
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderDownMoreOrders"];
    
    NSDictionary *param1 = @{@"Transactions":@"0",@"Shipping":@"0",@"Source":@"0",@"GiftID":self.GiftID,@"UseInt":self.UseInt,@"UseInteg":self.UseInteg,@"UseCoupon":self.UseCoupon,@"UseDiscountCode":self.UseDiscountCode,@"UseSign":self.UseSign,@"UseCardGift":self.UseCardGift,@"lang":self.lang,@"cry":self.cry};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.model.list.count > 0){
        [param setValue:ProductList forKey:@"ProductList"];
    }
    if(self.model.list2.count > 0){
        [param setValue:ProductList2 forKey:@"ProductList2"];
    }
    if(self.model.list3.count > 0){
        [param setValue:ProductList3 forKey:@"ProductList3"];
    }
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    if(self.adsid){
        [param setValue:self.adsid forKey:@"adsid"];
    }
   
    if(self.adsid2){
        [param setValue:self.adsid2 forKey:@"adsid2"];
    }
    
    if(self.adsid3){
        [param setValue:self.adsid3 forKey:@"adsid3"];
    }
    
    if(self.DiscountCode){
        [param setValue:self.DiscountCode forKey:@"DiscountCode"];
    }
    if(self.CouponID){
        [param setValue:self.CouponID forKey:@"CouponID"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [weakself GetPayHandleMoreOrders:key];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

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
            payVC.isEnter = @"1";
            [weakself.navigationController pushViewController:payVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark -- 数组转json字符串

//将数组转换成json格式字符串,不含 这些符号

-(NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    strJson = [strJson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //iOS9.0（包括9.0）以上使用
//    NSString *encodeUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];


    return strJson;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"确认订单页面"];
}
@end
