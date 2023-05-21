//
//  MMCommissionDetailCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import "MMCommissionDetailCell.h"

@interface MMCommissionDetailCell ()
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) UILabel *banlanceLa;

@end

@implementation MMCommissionDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xfbfbfb);
    
    UILabel *textLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    textLa.preferredMaxLayoutWidth = 200;
    [textLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:textLa];
    
    [textLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(17);
    }];
    self.titleLa = textLa;
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 130;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:timeLa];
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-18);
            make.height.mas_equalTo(11);
    }];
    self.timeLa = timeLa;
    
    UILabel *moneyLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x2a2c2a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-MEdium" size:16 numberOfLines:0];
    moneyLa.preferredMaxLayoutWidth = 120;
    [moneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:moneyLa];
    
    [moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-6);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(16);
    }];
    self.moneyLa = moneyLa;
    
    UILabel *banlanceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    banlanceLa.preferredMaxLayoutWidth = 150;
    [banlanceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:banlanceLa];
    
    [banlanceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-6);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(11);
    }];
    self.banlanceLa = banlanceLa;
    
}

-(void)setModel:(MMCommissionModel *)model{
    _model = model;
    self.titleLa.text = _model.YongType;
    self.timeLa.text = _model.AddTime;
    self.moneyLa.text = _model.Money;
    self.banlanceLa.text = [NSString stringWithFormat:@"余额：%@",_model.Balance];
}

-(void)setModel1:(MMBalanceRecordModel *)model1{
    _model1 = model1;
    self.titleLa.text = _model1.Transactions;
    self.timeLa.text = _model1.AddTime;
    self.moneyLa.text = _model1.PayMoney;
    float total = [_model1.SurplusBalance floatValue];
    self.banlanceLa.text = [NSString stringWithFormat:@"%@：%.2f",[UserDefaultLocationDic valueForKey:@"zongTotal"],total];
}

@end
