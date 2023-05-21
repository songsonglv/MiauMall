//
//  MMBalanceDetailInfoVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//。余额变动详情

#import "MMBalanceDetailInfoVC.h"

@interface MMBalanceDetailInfoVC ()

@end

@implementation MMBalanceDetailInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [TalkingDataSDK onPageBegin:@"余额使用详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"余额变动详情";
    titleView.line.hidden = YES;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self setUI];
}

-(void)setUI{
    UILabel *titlaLa = [UILabel publicLab:self.model.Transactions textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titlaLa.frame = CGRectMake(0, StatusBarHeight + 85, WIDTH, 18);
    [self.view addSubview:titlaLa];
    
    UILabel *moneyLa = [UILabel publicLab:self.model.PayMoney textColor:TCUIColorFromRGB(0x2a2c2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:26 numberOfLines:0];
    moneyLa.frame = CGRectMake(0, CGRectGetMaxY(titlaLa.frame) + 20, WIDTH, 26);
    [self.view addSubview:moneyLa];
    
    NSArray *arr = @[@"类型",@"时间",@"流水号",@"备注"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLa.frame) + 14 + 56 * i, WIDTH, 56)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.view addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
        lab.frame = CGRectMake(16, 25, 48, 16);
        [view addSubview:lab];
        
        UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x2a2c2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC" size:16 numberOfLines:0];
        conLa.preferredMaxLayoutWidth = WIDTH - 130;
        [conLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:conLa];
        
        [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(100);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(WIDTH - 130);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 55.5, WIDTH - 30, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdedede);
        [view addSubview:line];
        if(i == 0){
            conLa.text = self.model.Transactions;
        }else if (i == 1){
            conLa.text = self.model.AddTime;
        }else if (i == 2){
            conLa.text = @"20124567892102554661221124656145569877412";
        }else{
            
        }
    }
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"余额使用详情页面"];
}

@end
