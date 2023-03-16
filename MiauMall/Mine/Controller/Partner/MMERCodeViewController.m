//
//  MMERCodeViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/28.
//  分销二维码

#import "MMERCodeViewController.h"
#import "MMSalesShareModel.h"

@interface MMERCodeViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMSalesShareModel *model;
@end

@implementation MMERCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"分销二维码页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSalesShare"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMSalesShareModel mj_objectWithKeyValues:jsonDic];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(WIDTH *self.model.Pictures.count, HEIGHT);
    for (int i = 0; i < self.model.Pictures.count; i++) {
        NSDictionary *dic = self.model.Pictures[i];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [image sd_setImageWithURL:[NSURL URLWithString:dic[@"Picture"]]];
        [scrollView addSubview:image];
    }
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 18, 8, 16)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 375, WIDTH, 375)];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:bottomV];
    
    UILabel *titleLa = [UILabel publicLab:[NSString stringWithFormat:@"%@ %@",self.model.Title1,self.model.Title3] textColor:TCUIColorFromRGB(0x363636) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 15, WIDTH, 14);
    [bottomV addSubview:titleLa];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 122)/2, CGRectGetMaxY(titleLa.frame) + 12, 122, 116)];
    [codeImage sd_setImageWithURL:[NSURL URLWithString:self.model.CodeUrl] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    [bottomV addSubview:codeImage];
    
    UILabel *regCodeLa = [UILabel publicLab:[NSString stringWithFormat:@"邀请码: %@",self.model.RegCode] textColor:TCUIColorFromRGB(0x0a0a0a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    regCodeLa.frame = CGRectMake((WIDTH - 180)/2, CGRectGetMaxY(codeImage.frame) + 10, 138, 14);
    [bottomV addSubview:regCodeLa];
    
    UIButton *copyBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(regCodeLa.frame) + 4, CGRectGetMaxY(codeImage.frame) + 10, 34, 14)];
    [copyBt setBackgroundColor:TCUIColorFromRGB(0x0a0a0a)];
    [copyBt setTitle:@"复制" forState:(UIControlStateNormal)];
    [copyBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    copyBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    copyBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    copyBt.layer.masksToBounds = YES;
    copyBt.layer.cornerRadius = 7;
    [copyBt addTarget:self action:@selector(clickCopy) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:copyBt];
    
    UIButton *invitiBt = [[UIButton alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(regCodeLa.frame) + 98, WIDTH - 48, 48)];
    [invitiBt setBackgroundColor:TCUIColorFromRGB(0xe1321a)];
    [invitiBt setTitle:@"邀请合伙人" forState:(UIControlStateNormal)];
    [invitiBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    invitiBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    invitiBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [invitiBt addTarget:self action:@selector(clickInvi) forControlEvents:(UIControlEventTouchUpInside)];
    invitiBt.layer.masksToBounds = YES;
    invitiBt.layer.cornerRadius = 15;
    [bottomV addSubview:invitiBt];
}

-(void)clickInvi{
    [ZTProgressHUD showMessage:@"邀请合伙人"];
}

-(void)clickCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.RegCode;
    [ZTProgressHUD showMessage:@"复制成功！"];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"分销二维码页面"];
}


@end
