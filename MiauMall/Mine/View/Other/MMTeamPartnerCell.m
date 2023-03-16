//
//  MMTeamPartnerCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMTeamPartnerCell.h"
@interface MMTeamPartnerCell ()
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *todayMoneyLa;
@property (nonatomic, strong) UILabel *totalMoneyLa;
@property (nonatomic, strong) UILabel *orderLa;
@property (nonatomic, strong) UILabel *conRateLa;//转化率
@property (nonatomic, strong) UILabel *purRateLa;//复购率
@property (nonatomic, strong) UILabel *rateLa;//分佣比例


@end
@implementation MMTeamPartnerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    self.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, 234)];
    bgImage.image = [UIImage imageNamed:@"team_partner_bg"];
    bgImage.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImage];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 20, 60, 60)];
    [bgImage addSubview:headImage];
    self.headImage = headImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 220;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(17);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"partner_icon"];
    [bgImage addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(47);
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(15);
    }];
    
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 200;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.top.mas_equalTo(67);
            make.height.mas_equalTo(11);
    }];
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 92, 41, 62, 20)];
//    [self setView:btn andCorlors:@[TCUIColorFromRGB(0xff7650),TCUIColorFromRGB(0xff5f5d)]];
//    [btn setTitle:@"立即升级" forState:(UIControlStateNormal)];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 10;
//    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
//    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
//    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [contentV addSubview:btn];
    
    NSArray *arr = @[@"今日消费",@"累计消费",@"累计订单"];
    CGFloat wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 96, wid, 80)];
        [bgImage addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(14);
                    make.width.mas_equalTo(wid);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:19 numberOfLines:0];
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
    
    UILabel *lab2 = [UILabel publicLab:@"佣金比例" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    [bgImage addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(26);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *editBt = [[UIButton alloc]init];
    [editBt setImage:[UIImage imageNamed:@"edit_rate_icon"] forState:(UIControlStateNormal)];
    [editBt addTarget:self action:@selector(clickEdi) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:editBt];
    
    [editBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(51);
            make.width.height.mas_equalTo(16);
    }];
    
    UILabel *rateLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
    rateLa.preferredMaxLayoutWidth = 100;
    [rateLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:rateLa];
    self.rateLa = rateLa;
    
    [rateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(editBt.mas_left).offset(-3);
            make.top.mas_equalTo(51);
            make.height.mas_equalTo(16);
    }];
    
    NSArray *arr1 = @[@"团队转化率",@"团队复购率"];
    CGFloat wid1 = (WIDTH - 20)/arr1.count;
    for (int i = 0; i < arr1.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid1 * i, 194, wid1, 40)];
        [bgImage addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(27);
                    make.top.mas_equalTo(1);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = 120;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab.mas_right).offset(12);
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(14);
        }];
        if(i == 0){
            self.conRateLa = numLa;
        }else{
            self.purRateLa = numLa;
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
    self.conRateLa.text = _model.TeamConversionRate;
    self.purRateLa.text = _model.TeamRepurchaseRate;
    self.rateLa.text = [NSString stringWithFormat:@"%@%%",_model.YongRate];
}

-(void)clickEdi{
    self.clickEditBlcok(self.model.ID);
}
@end
