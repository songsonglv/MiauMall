//
//  MMDMOrderConfirmationVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMOrderConfirmationVC.h"
#import "MMDMConfirmOrderModel.h"
#import "MMDMConfirmOrderGoodsView.h"
#import "MMDMConfirmOrderAddressView.h"
#import "MMAddressListViewController.h"
#import "MMDMConfirmOrderMoneyView.h"
#import "MMDMUseIntegView.h"
#import "MMDMOrderKnowView.h"
#import "MMDMAddressSelectPopView.h"
#import "MMAddShippingAddressVC.h"
#import "MMDMOrderViewController.h"


#define kMaxTextCount 100 //限制的500个字


@interface MMDMOrderConfirmationVC ()<UITextViewDelegate>{
    UILabel *textNumberLabel;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMAddressModel *addressModel;
@property (nonatomic, strong) NSString *adsid;
@property (nonatomic, strong) NSString *UseInteg;
@property (nonatomic, strong) NSString *lyStr;
@property (nonatomic, strong) MMDMConfirmOrderModel *model;
@property (nonatomic, strong) MMDMConfirmOrderAddressView *addressView;
@property (nonatomic, strong) MMDMConfirmOrderGoodsView *goodsView;
@property (nonatomic, strong) MMDMConfirmOrderMoneyView *moneyView;
@property (nonatomic, strong) MMDMUseIntegView *useIntegView;
@property (nonatomic, strong) UIView *messageView;//留言view
@property (nonatomic, strong) UITextView *textView;//留言输入框
@property (nonatomic, strong) UILabel *textLa;//textView里面的占位label 提示性文字
@property (nonatomic, strong) MMDMOrderKnowView *knowView;//下单须知
@property (nonatomic, strong) NSMutableArray *seleArr;//已选择的须知数组
@property (nonatomic, strong) UIButton *submitBt;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MMDMAddressSelectPopView *popView;

@end

@implementation MMDMOrderConfirmationVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁止返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [TalkingDataSDK onPageBegin:@"代买确认订单页面"];
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.knowView.frame) + 42, WIDTH, 120)];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xefefef);
        [_bottomView addSubview:line];
        
        UILabel *moneyLa = [UILabel publicLab:@"" textColor:redColor3 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
        moneyLa.frame = CGRectMake(0, 15, WIDTH, 18);
        [_bottomView addSubview:moneyLa];
        self.moneyLa = moneyLa;
        
        NSArray *arr = [self.model.PayMoneyShow  componentsSeparatedByString:@" "];
        
        [moneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"%@:",[UserDefaultLocationDic valueForKey:@"itotal"]]).textColor(TCUIColorFromRGB(0x464646)).font([UIFont systemFontOfSize:12]);
            confer.text(arr[0]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
            confer.text(arr[1]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:18]);
            confer.text([NSString stringWithFormat:@"(%@%@)",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.PayMoneySignShow]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
        }];
        
        UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(12, 48, WIDTH - 24, 40)];
        [subBt setBackgroundColor:TCUIColorFromRGB(0xbfbfbf)];
        subBt.layer.masksToBounds = YES;
        subBt.layer.cornerRadius = 20;
        [subBt setTitle:[UserDefaultLocationDic valueForKey:@"submitorder"] forState:(UIControlStateNormal)];
        [subBt setTitleColor:TCUIColorFromRGB(0xfdfdfd) forState:(UIControlStateNormal)];
        subBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
        subBt.userInteractionEnabled = NO;
        [_bottomView addSubview:subBt];
        self.submitBt = subBt;
    }
    return _bottomView;
}

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(MMDMOrderKnowView *)knowView{
    KweakSelf(self);
    if(!_knowView){
        NSArray *arr = self.model.OrderKnowTips;
        float hei = 42;
        for (int i = 0; i < arr.count; i++) {
            NSString *str = arr[i];
            CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 56,MAXFLOAT)];
            hei += size.height + 24;
        }
        _knowView = [[MMDMOrderKnowView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageView.frame) + 20, WIDTH, hei)];
        _knowView.model = self.model;
        _knowView.clickKnowBlock = ^(NSString * _Nonnull str, NSString * _Nonnull isSelect) {
            if([isSelect isEqualToString:@"1"]){
                [weakself.seleArr addObject:str];
            }else{
                [weakself.seleArr removeObject:str];
            }
            [weakself updateBtState];
            
        };
    }
    return _knowView;
}

-(UIView *)messageView{
    if(!_messageView){
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.useIntegView.frame), WIDTH, 164)];
        UILabel *tiLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"orderPl"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        tiLa.frame = CGRectMake(17, 15, WIDTH - 34, 15);
        [_messageView addSubview:tiLa];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(tiLa.frame) + 20, WIDTH - 28, 114)];
        bgView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 6;
        [_messageView addSubview:bgView];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 1, WIDTH - 48, 80)];
        textView.delegate = self;
        textView.textColor = TCUIColorFromRGB(0x3c3c3c);
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        textView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
        [bgView addSubview:textView];
        self.textView = textView;
        
        UILabel *textLa = [UILabel publicLab:@"您可以在这里留言，我们会尽量满足您的需求" textColor:TCUIColorFromRGB(0xa9a9a9) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        textLa.frame = CGRectMake(13, 7, WIDTH - 55, 13);
        [textLa sizeToFit];
        [bgView addSubview:textLa];
        self.textLa = textLa;
        
        //添加下面计数的label
        textNumberLabel = [[UILabel alloc]init];
        textNumberLabel.textAlignment = NSTextAlignmentRight;
        textNumberLabel.font = [UIFont systemFontOfSize:12];
        textNumberLabel.textColor = TCUIColorFromRGB(0xa9a9a9);
        textNumberLabel.text = [NSString stringWithFormat:@"0/%d   ",kMaxTextCount];
        [bgView addSubview:textNumberLabel];
        
        [textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-12);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(12);
        }];
        
    }
    return _messageView;
}

-(MMDMUseIntegView *)useIntegView{
    KweakSelf(self);
    if(!_useIntegView){
        _useIntegView = [[MMDMUseIntegView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyView.frame) + 20, WIDTH, 60)];
        _useIntegView.model = self.model;
        _useIntegView.returnUseBlock = ^(NSString * _Nonnull str) {
            if([str isEqualToString:@"1"]){
                weakself.UseInteg = weakself.model.MyIntegral;
            }else{
                weakself.UseInteg = @"0";
            }
            
            [weakself refresh];
        };
    }
    return _useIntegView;
}

-(MMDMConfirmOrderMoneyView *)moneyView{
    if(!_moneyView){
        _moneyView = [[MMDMConfirmOrderMoneyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsView.frame) + 20, WIDTH, 260)];
        _moneyView.model = self.model;
    }
    return _moneyView;
}

-(MMDMConfirmOrderAddressView *)addressView{
    KweakSelf(self);
    if(!_addressView){
        _addressView = [[MMDMConfirmOrderAddressView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        if(self.addressModel){
            _addressView.model = self.addressModel;
        }
        _addressView.seleAddressBlock = ^(NSString * _Nonnull str) {
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.popView];
            [weakself.popView showView];
//            MMAddressListViewController *addressVC = [[MMAddressListViewController alloc]init];
//            addressVC.isEnter = @"0";
//            addressVC.returnAddressBlock = ^(MMAddressModel * _Nonnull model) {
//                weakself.addressView.model = model;
//                weakself.addressModel = model;
//                weakself.adsid = model.ID;
//                [weakself refresh];
//                [weakself updateBtState];
//            };
//            [weakself.navigationController pushViewController:addressVC animated:YES];
        };
    }
    return _addressView;
}

-(MMDMConfirmOrderGoodsView *)goodsView{
    if(!_goodsView){
        _goodsView = [[MMDMConfirmOrderGoodsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 20, WIDTH, self.model.ProductItems.count * 130 + 42)];
        _goodsView.model = self.model;
    }
    return _goodsView;
}

-(void)updateBtState{
    if(self.seleArr.count == self.model.OrderKnowTips.count && self.adsid != nil){
        [self.submitBt setBackgroundColor:redColor3];
        self.submitBt.userInteractionEnabled = YES;
    }else{
        [self.submitBt setBackgroundColor:TCUIColorFromRGB(0xbfbfbf)];
        self.submitBt.userInteractionEnabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.UseInteg = @"0";
    
    
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"订单确认";
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
        self.adsid = self.addressModel.ID;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress) name:@"addAddressSuccess" object:nil];
    
    self.popView = [[MMDMAddressSelectPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.addAddressBlock = ^(NSString * _Nonnull str) {
        MMAddShippingAddressVC *addressVC = [[MMAddShippingAddressVC alloc]init];
        [weakself.navigationController pushViewController:addressVC animated:YES];
    };
    
    self.popView.editAddressBlock = ^(MMAddressModel * _Nonnull model) {
        MMAddShippingAddressVC *addressVC = [[MMAddShippingAddressVC alloc]init];
        addressVC.model = model;
        [weakself.navigationController pushViewController:addressVC animated:YES];
    };
    
    self.popView.returnAddressBlock = ^(MMAddressModel * _Nonnull model) {
        weakself.addressView.model = model;
        weakself.addressModel = model;
        weakself.adsid = model.ID;
        [weakself refresh];
        [weakself updateBtState];
    };
    
    [self requestData];
    
    [self requestAddress];
    
    // Do any additional setup after loading the view.
}

-(void)requestAddress{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAddressList"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *addressArr = [MMAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:addressArr];
            weakself.popView.addressArr = weakself.dataArr;
            
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refreshAddress{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAddressList"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
   
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *addressArr = [MMAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            [weakself.dataArr removeAllObjects];
            weakself.dataArr = [NSMutableArray arrayWithArray:addressArr];
            weakself.popView.addressArr = weakself.dataArr;
           
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.adsid){
        [param setValue:self.adsid forKey:@"adsid"];
    }
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetDownMsgMoreOrders"];
    [param setValue:self.memberToken forKey:@"membertoken"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.UseInteg){
        [param setValue:self.UseInteg forKey:@"UseInteg"];
    }
    
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMConfirmOrderModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)refresh{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.adsid){
        [param setValue:self.adsid forKey:@"adsid"];
    }
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetDownMsgMoreOrders"];
    [param setValue:self.memberToken forKey:@"membertoken"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.UseInteg){
        [param setValue:self.UseInteg forKey:@"UseInteg"];
    }
    
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMConfirmOrderModel mj_objectWithKeyValues:jsonDic];
            weakself.moneyView.model = weakself.model;
            weakself.useIntegView.model = weakself.model;
            weakself.UseInteg = weakself.model.UseIntegral;
            
            NSArray *arr = [weakself.model.PayMoneyShow  componentsSeparatedByString:@" "];
            [weakself.moneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text([NSString stringWithFormat:@"%@:",[UserDefaultLocationDic valueForKey:@"itotal"]]).textColor(TCUIColorFromRGB(0x464646)).font([UIFont systemFontOfSize:12]);
                confer.text(arr[0]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
                confer.text(arr[1]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:18]);
                confer.text([NSString stringWithFormat:@"(%@%@)",[UserDefaultLocationDic valueForKey:@"iabout"],weakself.model.PayMoneySignShow]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
            }];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.contentSize = CGSizeMake(WIDTH, 900);
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.addressView];
    [scrollView addSubview:self.goodsView];
    [scrollView addSubview:self.moneyView];
    [scrollView addSubview:self.useIntegView];
    [scrollView addSubview:self.messageView];
    [scrollView addSubview:self.knowView];
    [scrollView addSubview:self.bottomView];
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.bottomView.frame) + 20);
}

-(void)clickSub{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s%@",baseurl1,@"OrderDownMoreOrders"];
    [param setValue:self.memberToken forKey:@"membertoken"];
    [param setValue:self.model.IsRemotely forKey:@"IsRemotely"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:@"0" forKey:@"DownFrom"];
    [param setValue:self.adsid forKey:@"adsid"];
    if(self.UseInteg){
        [param setValue:self.UseInteg forKey:@"UseInteg"];
    }else{
        [param setValue:@"0" forKey:@"UseInteg"];
    }
    if(self.textView.text.length > 0){
        [param setValue:self.textView.text forKey:@"Remark"];
    }else{
        [param setValue:@"" forKey:@"Remark"];
    }

    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        if([code isEqualToString:@"1"]){
            MMDMOrderViewController *orderVC = [[MMDMOrderViewController alloc]init];
            orderVC.type = @"0";
            [weakself.navigationController pushViewController:orderVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark -- uitextviewdelegate
//判断开始输入
-(void)textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length > 0){
        self.textLa.hidden = YES;
    }else{
        self.textLa.hidden = NO;
    }
    
    textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)textView.text.length,kMaxTextCount];
    if(textView.text.length >= kMaxTextCount){
        //截取字符串
        textView.text = [textView.text substringToIndex:100];
        textNumberLabel.text = @"100/100";
    }else{
        
    }
}



-(void)clickReturn{
    self.navigationController.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买确认订单页面"];
}

@end
