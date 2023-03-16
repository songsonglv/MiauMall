//
//  MMPartnerTeamDataView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import "MMPartnerTeamDataView.h"

@interface MMPartnerTeamDataView  ()
@property (nonatomic, strong) UILabel *conversionRateLa;//团队转化率
@property (nonatomic, strong) UILabel *repurchaseRateLa;//团队复购率
@property (nonatomic, strong) UILabel *buyNumLa;//购买商品用户数量
@property (nonatomic, strong) UILabel *repurNumLa;//复购数量
@property (nonatomic, strong) UILabel *memberNumLa;//新增用户数量
@property (nonatomic, strong) UILabel *teamOrderNumLa;//团队订单数量
@end

@implementation MMPartnerTeamDataView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    NSArray *arr = @[@"团队转化率",@"团队复购率"];
    NSArray *arr1 = @[@"新增用户数",@"团队订单数"];
    CGFloat wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 0, wid, 78.5)];
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 100;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(26);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = 180;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab.mas_right).offset(16);
                    make.top.mas_equalTo(20);
                    make.height.mas_equalTo(18);
        }];
        
        UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x909090) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        conLa.preferredMaxLayoutWidth = wid - 34;
        [conLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:conLa];
        
        [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(17);
                    make.top.mas_equalTo(53);
                    make.height.mas_equalTo(11);
        }];
        
        if(i == 0){
            self.conversionRateLa = numLa;
            self.buyNumLa = conLa;
        }else{
            self.repurchaseRateLa = numLa;
            self.repurNumLa = conLa;
        }
    }
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    [self addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(132);
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    [self addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
    }];
    
    for (int i = 0; i < arr1.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 79, wid, 73)];
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0x44342) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = wid - 34;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(17);
                    make.top.mas_equalTo(14);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = wid - 34;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(17);
                    make.top.mas_equalTo(40);
                    make.height.mas_equalTo(18);
        }];
        if(i == 0){
            self.memberNumLa = numLa;
        }else{
            self.teamOrderNumLa = numLa;
        }
        
    }
    
}

-(void)setModel:(MMPartnerDataModel *)model{
    _model = model;
    self.conversionRateLa.text = _model.TeamConversionRate;
    self.repurchaseRateLa.text = _model.TeamRepurchaseRate;
    self.buyNumLa.text = [NSString stringWithFormat:@"购买商品用户数%@",_model.TeamConversionCount];
    self.repurNumLa.text = [NSString stringWithFormat:@"复购数量%@",_model.TeamRepurchaseCount];
    self.memberNumLa.text = _model.TeamNum;
    self.teamOrderNumLa.text = _model.TeamOrderNum;
}

@end
