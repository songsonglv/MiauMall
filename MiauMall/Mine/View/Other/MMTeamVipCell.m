//
//  MMTeamVipCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMTeamVipCell.h"
@interface MMTeamVipCell ()
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *todayMoneyLa;
@property (nonatomic, strong) UILabel *totalMoneyLa;
@property (nonatomic, strong) UILabel *orderLa;


@end

@implementation MMTeamVipCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, 178)];
    [self setView:contentV andCorlors:@[TCUIColorFromRGB(0xf7f7f8),TCUIColorFromRGB(0xf2f0f2)]];
    contentV.layer.masksToBounds = YES;
    contentV.layer.cornerRadius = 9;
    [self.contentView addSubview:contentV];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 60, 60)];
    [contentV addSubview:headImage];
    self.headImage = headImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 220;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(17);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"vip_icon"];
    [contentV addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(41);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"会员" textColor:TCUIColorFromRGB(0xf25240) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    [contentV addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(105);
            make.top.mas_equalTo(41);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 200;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(61);
            make.height.mas_equalTo(11);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 92, 41, 62, 20)];
    [self setView:btn andCorlors:@[TCUIColorFromRGB(0xff7650),TCUIColorFromRGB(0xff5f5d)]];
    [btn setTitle:@"立即升级" forState:(UIControlStateNormal)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:btn];
    
    NSArray *arr = @[@"今日消费",@"累计消费",@"累计订单"];
    CGFloat wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 96, wid, 80)];
        [contentV addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(14);
                    make.width.mas_equalTo(wid);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:19 numberOfLines:0];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(-22);
                    make.height.mas_equalTo(17);
        }];
        if(i == 0){
            self.todayMoneyLa = numLa;
        }else if (i == 1){
            self.totalMoneyLa = numLa;
        }else{
            self.orderLa = numLa;
        }
    }
}

-(void)setModel:(MMMyTeamListModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"partner_head_normal"]];
    self.nameLa.text = _model.Name;
    self.timeLa.text = _model.SalesNameStr;
    self.todayMoneyLa.text = _model.ToDayMoney;
    self.totalMoneyLa.text = _model.TotalMoney;
    self.orderLa.text = _model.TotalOrder;
}


-(void)clickBtn{
    self.clickUpBlock(self.model.ID);
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


@end
