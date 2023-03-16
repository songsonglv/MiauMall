//
//  MMPartnerViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/27.
//  合伙人页面

#import "MMPartnerViewController.h"
#import "MMPartnerDataModel.h"
#import "MMERCodeViewController.h"
#import "MMMyCommissionVC.h"
#import "MMPartnerDataVC.h"
#import "MMPartnerAccountVC.h"
#import "MMDistributionOrderVC.h"
#import "MMMyTeamViewController.h"
#import "MMWithdrawViewController.h"
#import "MMPartnerTextPopView.h"
#import "MMTextModel.h"
#import "MMPartnerRulesVC.h"

@interface MMPartnerViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableArray *hightArr;//文本高度
@property (nonatomic, strong) MMPartnerDataModel *model;
@property (nonatomic, strong) MMPartnerTextPopView *popView;
@end

@implementation MMPartnerViewController

-(NSMutableArray *)textArr{
    if(!_textArr){
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

-(NSMutableArray *)hightArr{
    if(!_hightArr){
        _hightArr = [NSMutableArray array];
    }
    return _hightArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"合伙人页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [self requestData];
    
    [self requestText];
    
    // Do any additional setup after loading the view.
}

-(void)requestText{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetQuestionInfo"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"4208" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSArray *arr = jsonDic[@"StrList"];
        
        dispatch_queue_t q = dispatch_queue_create(@"hei", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q, ^{
            NSMutableArray *contArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                NSString *str = arr[i];
                NSDictionary *param = @{@"content":str};
                MMTextModel *textModel = [MMTextModel mj_objectWithKeyValues:param];
                [contArr addObject:textModel];
            }
            weakself.textArr = [NSMutableArray arrayWithArray:contArr];
            
            
            for (int i = 0; i < arr.count; i++) {
                NSString *context = arr[i];
                //这是获取字符串在指定的size内(宽度超过175，则换行)，所需要的宽度和高度。
                CGSize maxSize = CGSizeMake(WIDTH - 60, MAXFLOAT);
                CGSize size = [context sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
                //字符串所占高度
                CGFloat labelHeight = size.height;
                NSString *heiStr = [NSString stringWithFormat:@"%.2f",labelHeight];
                [weakself.hightArr addObject:heiStr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showPop];
            });
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SalesHome"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMPartnerDataModel mj_objectWithKeyValues:jsonDic];
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
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 224)];
    bgImage.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgImage.image = [UIImage imageNamed:@"black_bg"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 18, 8, 16)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:returnBt];
    
    UILabel *titleLa = [UILabel publicLab:@"合伙人" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(50, StatusBarHeight + 18, WIDTH - 100, 18);
    [bgImage addSubview:titleLa];
    
    UIImageView *contentImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 54, WIDTH - 20, 196)];
    contentImage.userInteractionEnabled = YES;
    contentImage.image = [UIImage imageNamed:@"partner_bg"];
    [self.view addSubview:contentImage];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 64, 64)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.memberInfo.Picture] placeholderImage:[UIImage imageNamed:@"partner_head_nomal"]];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 32;
    [contentImage addSubview:headImage];
    
    UILabel *nickLa = [UILabel publicLab:self.model.memberInfo.Name textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    nickLa.preferredMaxLayoutWidth = 200;
    [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:nickLa];
    
    [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(22);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *inviCodeLa = [UILabel publicLab:[NSString stringWithFormat:@"邀请码%@",self.model.memberInfo.RegCode] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    inviCodeLa.preferredMaxLayoutWidth = 150;
    [inviCodeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:inviCodeLa];
    
    [inviCodeLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(nickLa.mas_bottom).offset(6);
        make.height.mas_equalTo(11);
    }];
    
    UIButton *copyBt = [[UIButton alloc]init];
    [copyBt setImage:[UIImage imageNamed:@"copy_icon"] forState:(UIControlStateNormal)];
    [copyBt addTarget:self action:@selector(clickCopy) forControlEvents:(UIControlEventTouchUpInside)];
    [contentImage addSubview:copyBt];
    
    [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inviCodeLa.mas_right).offset(6);
        make.top.mas_equalTo(nickLa.mas_bottom).offset(7);
        make.width.height.mas_equalTo(10);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"我的佣金" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"pingFangSC-Regular" size:11 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 120;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(inviCodeLa.mas_bottom).offset(8);
        make.height.mas_equalTo(11);
    }];
    
    //佣金百分比
    UILabel *perLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%%",self.model.memberInfo.YongRate] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    perLa.preferredMaxLayoutWidth = 100;
    [perLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:perLa];
    
    [perLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lab1.mas_right).offset(3);
        make.top.mas_equalTo(inviCodeLa.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
    }];
    
    UIImageView *erCodeImage = [[UIImageView alloc]init];
    erCodeImage.image = [UIImage imageNamed:@"ercode_icon"];
    [contentImage addSubview:erCodeImage];
    
    [erCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-28);
        make.top.mas_equalTo(38);
        make.width.height.mas_equalTo(28);
    }];
    
    UIButton *erCodeBt = [[UIButton alloc]init];
    [erCodeBt setBackgroundColor:UIColor.clearColor];
    [erCodeBt addTarget:self action:@selector(clickErCode) forControlEvents:(UIControlEventTouchUpInside)];
    [contentImage addSubview:erCodeBt];
    
    [erCodeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-28);
            make.top.mas_equalTo(38);
            make.width.height.mas_equalTo(28);
    }];
    
    
    UILabel *canLa = [UILabel publicLab:@"可提现(JPY)" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    canLa.preferredMaxLayoutWidth = 100;
    [canLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [contentImage addSubview:canLa];
    
    [canLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(11);
    }];
    
    UILabel *moneyLa = [UILabel publicLab:self.model.memberInfo.YongBalanceJPY textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:20 numberOfLines:0];
    moneyLa.preferredMaxLayoutWidth = 180;
    [moneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:moneyLa];
    
    [moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(canLa.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *moneyLa1 = [UILabel publicLab:self.model.memberInfo.YongBalance textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    moneyLa1.preferredMaxLayoutWidth = 120;
    [moneyLa1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:moneyLa1];
    
    [moneyLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyLa.mas_right).offset(6);
        make.top.mas_equalTo(perLa.mas_bottom).offset(60);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *allMoneyLa = [UILabel publicLab:[NSString stringWithFormat:@"累计佣金%@(JPY)",self.model.memberInfo.YongTotal] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    allMoneyLa.preferredMaxLayoutWidth = 200;
    [allMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentImage addSubview:allMoneyLa];
    
    [allMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(moneyLa.mas_bottom).offset(15);
        make.height.mas_equalTo(11);
    }];
    
    UIButton *withDrawBt = [[UIButton alloc]init];
    [withDrawBt setTitle:@"提现" forState:(UIControlStateNormal)];
    [withDrawBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    withDrawBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    withDrawBt.layer.masksToBounds = YES;
    withDrawBt.layer.cornerRadius = 12;
    withDrawBt.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
    withDrawBt.layer.borderWidth = 0.5;
    [withDrawBt addTarget:self action:@selector(clickWithDraw) forControlEvents:(UIControlEventTouchUpInside)];
    [contentImage addSubview:withDrawBt];
    
    [withDrawBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(erCodeImage.mas_bottom).offset(50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(24);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"right_while"];
    [contentImage addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-36);
        make.top.mas_equalTo(withDrawBt.mas_bottom).offset(20);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickEnter) forControlEvents:(UIControlEventTouchUpInside)];
    [contentImage addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(withDrawBt.mas_bottom).offset(10);
        make.right.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contentImage.frame) + 12, WIDTH - 20, 250)];
    dataView.backgroundColor = TCUIColorFromRGB(0xffffff);
    dataView.layer.masksToBounds = YES;
    dataView.layer.cornerRadius = 7.5;
    [self.view addSubview:dataView];
    
    UILabel *tiLa = [UILabel publicLab:@"团队数据" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    tiLa.frame = CGRectMake(16, 16, 80, 16);
    [dataView addSubview:tiLa];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, 47, WIDTH - 36, 0.5)];
    line1.backgroundColor = TCUIColorFromRGB(0xdedede);
    [dataView addSubview:line1];
    
    NSArray *arr = @[@"会员数量",@"售后订单数",@"待发货订单"];
    CGFloat wid = (WIDTH - 20)/3;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, CGRectGetMaxY(line1.frame), wid, 102)];
        [dataView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:@"42233" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(21);
        }];
        
        UILabel *lab2 = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        [view addSubview:lab2];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(lab.mas_bottom).offset(20);
            make.height.mas_equalTo(13);
        }];
        
        if(i == 0){
            lab.text = self.model.TeamNum;
        }else if (i == 1){
            lab.text = self.model.daishouhuo;
        }else{
            lab.text = self.model.daifahuo;
        }
    }
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, 150, WIDTH - 36, 0.5)];
    line2.backgroundColor = TCUIColorFromRGB(0xdedede);
    [dataView addSubview:line2];
    
    NSArray *arr1 = @[@"团队转化率",@"团队复购率"];
    CGFloat wid1 = (WIDTH - 20)/2;
    for (int i = 0; i < arr1.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid1 * i, CGRectGetMaxY(line2.frame),wid1 , 100)];
        [dataView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 100;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(28);
            make.height.mas_equalTo(13);
        }];
        
        UILabel *numLa = [UILabel publicLab:self.model.TeamConversionRate textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = 100;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_right).offset(16);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(21);
        }];
        
        UILabel *textLa = [UILabel publicLab:@"购买商品用户数 2121,12" textColor:TCUIColorFromRGB(0x909090) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        textLa.preferredMaxLayoutWidth = wid1 - 36;
        [textLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:textLa];
        
        [textLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(lab.mas_bottom).offset(19);
            make.height.mas_equalTo(11);
        }];
        
        if(i == 0){
            numLa.text = self.model.TeamConversionRate;
            textLa.text = [NSString stringWithFormat:@"购买商品用户数%@",self.model.TeamConversionCount];
        }else{
            numLa.text = self.model.TeamRepurchaseRate;
            textLa.text = [NSString stringWithFormat:@"复购数量%@",self.model.TeamRepurchaseCount];
        }
    }
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = TCUIColorFromRGB(0xdedede);
    [dataView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dataView);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(66);
    }];
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setBackgroundColor:UIColor.clearColor];
    [btn1 addTarget:self action:@selector(lookData) forControlEvents:(UIControlEventTouchUpInside)];
    [dataView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(dataView.frame) + 12, WIDTH - 20, 112)];
    view1.backgroundColor = TCUIColorFromRGB(0xffffff);
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 7.5;
    [self.view addSubview:view1];
    
    NSArray *arr2 = @[@"我的团队",@"分销规则",@"分销订单",@"我的账户"];
    NSArray *imgArr = @[@"team_icon",@"fx_rule_icon",@"fx_order_icon",@"my_account_icon"];
    CGFloat wid3 = (WIDTH - 284)/3;
    for (int i = 0; i < arr2.count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:arr2[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x36393d) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:(UIControlStateNormal)];
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:15];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(12 + (60 + wid3) * i, 20, 60, 70);
        [view1 addSubview:btn];
    }
    
}



-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 100){
        MMMyTeamViewController *teamVC = [[MMMyTeamViewController alloc]init];
        [self.navigationController pushViewController:teamVC animated:YES];
    }else if (sender.tag == 101){
        MMPartnerRulesVC *ruleVC = [[MMPartnerRulesVC alloc]init];
        [self.navigationController pushViewController:ruleVC animated:YES];
    }else if (sender.tag == 102){
       
        MMDistributionOrderVC *orderVC = [[MMDistributionOrderVC alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        MMPartnerAccountVC *accountVC = [[MMPartnerAccountVC alloc]init];
        [self.navigationController pushViewController:accountVC animated:YES];
    }
}

-(void)showPop{
    self.popView = [[MMPartnerTextPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.textArr andHeightArr:self.hightArr];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)lookData{
    MMPartnerDataVC *dataVC = [[MMPartnerDataVC alloc]init];
    [self.navigationController pushViewController:dataVC animated:YES];
}

-(void)clickErCode{
    MMERCodeViewController *erCodeVC = [[MMERCodeViewController alloc]init];
    [self.navigationController pushViewController:erCodeVC animated:YES];
}

-(void)clickWithDraw{
    MMWithdrawViewController *withdrawVC = [[MMWithdrawViewController alloc]init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

-(void)clickEnter{
    MMMyCommissionVC *commissionVC = [[MMMyCommissionVC alloc]init];
    [self.navigationController pushViewController:commissionVC animated:YES];
}

-(void)clickCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.memberInfo.RegCode;
    [ZTProgressHUD showMessage:@"复制成功！"];
}



-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"合伙人页面"];
}
@end
