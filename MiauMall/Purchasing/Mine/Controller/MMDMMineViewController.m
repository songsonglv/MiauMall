//
//  MMDMMineViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//

#import "MMDMMineViewController.h"
#import "MMDMMemberModel.h"
#import "MMDMMineOrderView.h"
#import "MMDMOrderViewController.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"
#import "MMMessageCenterVC.h"
#import "MMSelectCountryVC.h"
#import "MMSetUpViewController.h"
#import "MMCustomerServiceVC.h"
#import "MMDMShippingCalculatorVC.h"

@interface MMDMMineViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIButton *countryBt;
@property (nonatomic, strong) UIButton *signBt;//签到按钮
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *IDLa;
@property (nonatomic, strong) MMDMMemberModel *model;
@property (nonatomic, strong) MMDMMineOrderView *orderView;
@property (nonatomic, strong) UIView *serviceView;

@end

@implementation MMDMMineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买我的页面"];
    [self GetMember];
}

-(MMDMMineOrderView *)orderView{
    KweakSelf(self);
    if(!_orderView){
        _orderView = [[MMDMMineOrderView alloc]initWithFrame:CGRectMake(10, 184, WIDTH - 20, 112)];
        _orderView.clickPayBlock = ^(NSString * _Nonnull orderId) {
            [weakself GetPayHandleMoreOrders:orderId];
        };
        
        _orderView.clickOrderBlock = ^(NSString * _Nonnull typeId) {
            MMDMOrderViewController *orderVC = [[MMDMOrderViewController alloc]init];
            orderVC.type = typeId;
            [weakself.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return _orderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)GetMember{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetMember"];
    
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMDMMemberModel mj_objectWithKeyValues:jsonDic];
            weakself.nameLa.text = weakself.model.Name;
            [weakself.headImage sd_setImageWithURL:[NSURL URLWithString:weakself.model.HeadImg] placeholderImage:[UIImage imageNamed:@"dm_head_normal"]];
            weakself.IDLa.text = [NSString stringWithFormat:@"ID :%@",weakself.model.ID];
            [weakself.countryBt sd_setImageWithURL:[NSURL URLWithString:weakself.model.CurrencyImg] forState:(UIControlStateNormal)];
            weakself.orderView.model = weakself.model;
            if(weakself.model.ReadyPayModels.count > 0){
                weakself.orderView.height = 164;
            }else{
                weakself.orderView.height = 112;
            }
            weakself.serviceView.y = CGRectGetMaxY(weakself.orderView.frame) + 10;
            
           
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 220)];
    topImage.image = [UIImage imageNamed:@"dm_mine_bg"];
    topImage.userInteractionEnabled = YES;
    [self.view addSubview:topImage];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(22, 80, 50, 50)];
    headImg.image = [UIImage imageNamed:@"dm_head_normal"];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 25;
    [topImage addSubview:headImg];
    self.headImage = headImg;
    
    UILabel *nameLa = [UILabel publicLab:@"用户0223" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topImage addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(82);
            make.top.mas_equalTo(86);
            make.height.mas_equalTo(22);
    }];
    
    UILabel *IDLa = [UILabel publicLab:@"id:12344124124" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    IDLa.preferredMaxLayoutWidth = 120;
    [IDLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topImage addSubview:IDLa];
    self.IDLa = IDLa;
    
    [IDLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(82);
            make.top.mas_equalTo(114);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"fzCopy"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *copyBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(IDLa.frame) + 5, 112, size.width + 8, 16)];
    [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
    [copyBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    copyBt.titleLabel.font = [UIFont systemFontOfSize:12];
    copyBt.layer.masksToBounds = YES;
    copyBt.layer.cornerRadius = 2.5;
    copyBt.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
    copyBt.layer.borderWidth = 0.5;
    [copyBt addTarget:self action:@selector(clickCopy) forControlEvents:(UIControlEventTouchUpInside)];
    [topImage addSubview:copyBt];
    
    [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IDLa.mas_right).offset(5);
            make.top.mas_equalTo(112);
            make.width.mas_equalTo(size.width + 8);
            make.height.mas_equalTo(16);
    }];
    
    UIButton *newBt = [[UIButton alloc]init];
    [newBt setImage:[UIImage imageNamed:@"dm_news_icon"] forState:(UIControlStateNormal)];
    [newBt addTarget:self action:@selector(goKefu) forControlEvents:(UIControlEventTouchUpInside)];
    [topImage addSubview:newBt];
    
    [newBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(62);
            make.width.height.mas_equalTo(18);
    }];
    
    UIButton *setBt = [[UIButton alloc]init];
    [setBt setImage:[UIImage imageNamed:@"dm_setup_icon"] forState:(UIControlStateNormal)];
    [setBt addTarget:self action:@selector(clickSet) forControlEvents:(UIControlEventTouchUpInside)];
    [topImage addSubview:setBt];
    
    [setBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(newBt.mas_left).offset(-8);
            make.top.mas_equalTo(62);
            make.width.height.mas_equalTo(18);
    }];
    
    UIButton *countryBt = [[UIButton alloc]init];
    [countryBt setImage:[UIImage imageNamed:@"china_icon"] forState:(UIControlStateNormal)];
    [countryBt addTarget:self action:@selector(seleCountry) forControlEvents:(UIControlEventTouchUpInside)];
    countryBt.layer.masksToBounds = YES;
    countryBt.layer.cornerRadius = 9;
    [topImage addSubview:countryBt];
    self.countryBt = countryBt;
    
    [countryBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(setBt.mas_left).offset(-8);
            make.top.mas_equalTo(62);
            make.width.height.mas_equalTo(18);
    }];
    
    
    UIButton *signBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 84, 95, 70, 24)];
    signBt.selected = NO;
    [signBt setImage:[UIImage imageNamed:@"sign_icon"] forState:(UIControlStateNormal)];
    [signBt setImage:[UIImage imageNamed:@"signed_icon"] forState:(UIControlStateSelected)];
    [signBt addTarget:self action:@selector(goSign:) forControlEvents:(UIControlEventTouchUpInside)];
    [topImage addSubview:signBt];
    
    [self.view addSubview:self.orderView];
    
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.orderView.frame) + 10, WIDTH - 20, 232)];
    serviceView.backgroundColor = TCUIColorFromRGB(0xffffff);
    serviceView.layer.masksToBounds = YES;
    serviceView.layer.cornerRadius = 7.5;
    [self.view addSubview:serviceView];
    self.serviceView = serviceView;
    
    UILabel *lab2 = [UILabel publicLab:@"更多服务" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab2.frame = CGRectMake(10, 15, 150, 14);
    [serviceView addSubview:lab2];
    
    NSArray *arr2 = @[@"运费计算器",@"使用说明",@"联系客服"];
    NSArray *iconArr2 = @[@"dm_jsq_icon",@"dm_sysm_icon",@"dm_kf_icon"];
    for (int i = 0; i < arr2.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 46 + 60 * i, WIDTH - 20, 60)];
        [serviceView addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 0, WIDTH - 36, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
        [view addSubview:line];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 20, 20, 20)];
//        iconImg.centerY = view.centerY;
        iconImg.image = [UIImage imageNamed:iconArr2[i]];
        [view addSubview:iconImg];
        
        UILabel *lab = [UILabel publicLab:arr2[i] textColor:TCUIColorFromRGB(0x6b6b6b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(38);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UIButton *rightBt = [[UIButton alloc]init];
        [rightBt setImage:[UIImage imageNamed:@"right_icon_black"] forState:(UIControlStateNormal)];
        rightBt.tag = 100 + i;
        [rightBt setEnlargeEdgeWithTop:24 right:12 bottom:24 left:300];
        [rightBt addTarget:self action:@selector(clickRight:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:rightBt];
        
        [rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-12);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(6);
                    make.height.mas_equalTo(12);
        }];
        
    }
}

-(void)clickRight:(UIButton *)sender{
    if(sender.tag == 100){
        MMDMShippingCalculatorVC *customVC = [[MMDMShippingCalculatorVC alloc]init];
        [self.navigationController pushViewController:customVC animated:YES];
    }else if (sender.tag == 101){
        [ZTProgressHUD showMessage:@"使用说明"];
    }else{
        MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
        [self.navigationController pushViewController:customVC animated:YES];
    }
}

-(void)goSign:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(void)clickOrder:(UIButton *)sender{
    [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",sender.tag - 200]];
}

-(void)goKefu{
    MMMessageCenterVC *messageVC = [[MMMessageCenterVC alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)clickSet{
    MMSetUpViewController *setupVC = [[MMSetUpViewController alloc]init];
    [self.navigationController pushViewController:setupVC animated:YES];
}

-(void)clickCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.ID;
    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
}

-(void)seleCountry{
    MMSelectCountryVC *countryVC = [[MMSelectCountryVC alloc]init];
    countryVC.isDM = @"1";
    [self.navigationController pushViewController:countryVC animated:YES];
}

//付款页面
-(void)GetPayHandleMoreOrders:(NSString *)orderID{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetPayHandleFirst"];
    NSDictionary *param = @{@"orderid":orderID,@"membertoken":self.memberToken,@"lang":self.lang};
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买我的页面"];
}
@end
