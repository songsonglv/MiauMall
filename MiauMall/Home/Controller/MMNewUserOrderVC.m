//
//  MMNewUserOrderVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//  新人下单

#import "MMNewUserOrderVC.h"
#import "MMNewUserGoodsModel.h"

@interface MMNewUserOrderVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MMNewUserOrderVC

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"新人首单有礼页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleView.titleLa.text = @"下单有礼";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    [self GetTreeOrder];
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)GetTreeOrder{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetTreeOrder"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMNewUserGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"Free"]];
            weakself.goodsArr = [NSMutableArray arrayWithArray:arr];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, 802)];
    bgImage.image = [UIImage imageNamed:@"xinren_bg"];
    bgImage.userInteractionEnabled = YES;
    [scrollView addSubview:bgImage];
    
    UILabel *lab1 = [UILabel publicLab:@"首单有礼" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:22 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 200;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(22);
    }];
    
    UILabel *lab2 = [UILabel publicLab:@"新人首单免费送" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = 200;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62);
            make.top.mas_equalTo(44);
            make.height.mas_equalTo(12);
    }];
    
    CGFloat wid = (WIDTH - 60)/3;
    for (int i = 0; i < self.goodsArr.count; i++) {
        MMNewUserGoodsModel *model = self.goodsArr[i];
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + column * (wid + 10), 76 + 170 * row, wid, 160)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [bgImage addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 92)/2, 10, 92, 92)];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:goodsImage];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 54, 15)];
        iconImage.image = [UIImage imageNamed:@"xinren_icon"];
        [view addSubview:iconImage];
        
        UILabel *newLa = [UILabel publicLab:@"新人有礼" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        newLa.frame = CGRectMake(0, 0, 54, 15);
        [iconImage addSubview:newLa];
        
        UILabel *lab = [UILabel publicLab:@"JPY0" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.frame = CGRectMake(0, CGRectGetMaxY(goodsImage.frame) + 3, wid, 12);
        [view addSubview:lab];
        
        UILabel *goLa = [UILabel publicLab:@"立即领取" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        CGSize size = [NSString sizeWithText:goLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        goLa.frame = CGRectMake((wid - (size.width + 20))/2, CGRectGetMaxY(lab.frame) + 10, size.width + 20, 22);
        goLa.backgroundColor = TCUIColorFromRGB(0xd0ab6d);
        goLa.layer.masksToBounds = YES;
        goLa.layer.cornerRadius = 11;
        [view addSubview:goLa];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 160)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
    
    UIView *ruleView = [[UIView alloc]initWithFrame:CGRectMake(10, 76 + 500 + 28, WIDTH - 40, 184)];
    ruleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    ruleView.layer.masksToBounds = YES;
    ruleView.layer.cornerRadius = 4;
    [bgImage addSubview:ruleView];
    
    UILabel *titleLa = [UILabel publicLab:@"- 活动规则 -" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, WIDTH - 40, 18);
    [ruleView addSubview:titleLa];

    NSArray *titleArr = @[@"* 新用户首次下单时，可免费领取一份首单赠礼。",@"* 首单赠礼产品仅限首单领取，首单未领即视作自动放弃。",@"* 首单赠礼与首单其他商品同遵循MiauMall运费政策。",@"* 首单赠礼产品不做退换货处理。"];
    float hei = 0;
    for (int i = 0; i < titleArr.count; i++) {
        NSString *str = titleArr[i];
        CGSize size1 = [NSString sizeWithText:str font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(WIDTH - 76,MAXFLOAT)];
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 76;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
//        lab.frame = CGRectMake(16,67 + hei, size1.width, size1.height);
        [ruleView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.top.mas_equalTo(67 + hei);
                    make.width.mas_equalTo(WIDTH - 76);
        }];
        
        hei += (size1.height + 12);
    }
    ruleView.height = hei + 100;
    bgImage.height = CGRectGetMaxY(ruleView.frame) + 12;
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bgImage.frame) + 10, WIDTH - 20, 346)];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    bottomV.layer.masksToBounds = YES;
    bottomV.layer.cornerRadius = 10;
    bottomV.layer.borderColor = TCUIColorFromRGB(0xd0ab6d).CGColor;
    bottomV.layer.borderWidth = 1;
    [scrollView addSubview:bottomV];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 36, 36)];
    topImage.image = [UIImage imageNamed:@"new_icon"];
    [bottomV addSubview:topImage];
    
    UILabel *lab3 = [UILabel publicLab:@"三单有礼" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:22 numberOfLines:0];
    lab3.preferredMaxLayoutWidth = 200;
    [lab3 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:lab3];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(22);
    }];
    
    UILabel *lab4 = [UILabel publicLab:@"下满三单 好礼相赠" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab4.preferredMaxLayoutWidth = 200;
    [lab4 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:lab4];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62);
            make.top.mas_equalTo(44);
            make.height.mas_equalTo(12);
    }];
    
    NSArray *arr = @[@"第一单",@"第二单",@"第三单"];
    CGFloat wid1 = (WIDTH - 20 - 24)/3;
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((wid1 + 12) * i, 80, wid1, 82)];
        [bottomV addSubview:view];
        
        UIImageView *orderIcon = [[UIImageView alloc]initWithFrame:CGRectMake((wid1 - 54)/2, 0, 54, 54)];
        orderIcon.image = [UIImage imageNamed:@"order_icon"];
        [view addSubview:orderIcon];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.frame = CGRectMake(0, 68, wid1, 14);
        [view addSubview:lab];
        
        if(i < 2){
            UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 96, 12, 24)];
            rightIcon.image = [UIImage imageNamed:@"right_sele_icon"];
            [bottomV addSubview:rightIcon];
        }
        
    }
    
    UILabel *titleLa2 = [UILabel publicLab:@"- 活动规则 -" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    titleLa2.frame = CGRectMake(0, 184, WIDTH - 20, 14);
    [bottomV addSubview:titleLa2];
    
    NSArray *titleArr2 = @[@"新用户在 MiauMall 的前三笔订单均有奖励可领取：",@"*第一单：首次购物时，可在【首单赠礼】挑选任一礼品。确认收货后，可得无门槛1000日币优惠券一张。",@" *第二单：确认收货后，可得无门槛1000日币优惠券一张。",@" *第三单：确认收货后，可得无门槛1000日币优惠券一张。"];
    float hei1 = 0;
    for (int i = 0; i < titleArr2.count; i++) {
        NSString *str = titleArr2[i];
        CGSize size1 = [NSString sizeWithText:str font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(WIDTH - 56,MAXFLOAT)];
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
//        lab.frame = CGRectMake(16,216 + hei1, size1.width, size1.height);
        lab.preferredMaxLayoutWidth = WIDTH - 56;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [bottomV addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.top.mas_equalTo(216 + hei1);
                    make.width.mas_equalTo(WIDTH - 56);
        }];
        
        hei1 += (size1.height + 12);
    }
    bottomV.height = hei1 + 236;

    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(bottomV.frame) + 32);
}

-(void)clickBt:(UIButton *)sender{
    MMNewUserGoodsModel *model = self.goodsArr[sender.tag - 100];
    MMHomeGoodsDetailController *detailVC = [[MMHomeGoodsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"新人首单有礼页面"];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
