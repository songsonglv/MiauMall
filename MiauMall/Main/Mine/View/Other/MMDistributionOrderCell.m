//
//  MMDistributionOrderCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMDistributionOrderCell.h"
@interface MMDistributionOrderCell ()
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UILabel *stateLa;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *superiorLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *signLa;
@property (nonatomic, strong) UIImageView *headImage;
@end

@implementation MMDistributionOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UILabel *noLa = [UILabel publicLab:@"订单编号：1245687964545" textColor:TCUIColorFromRGB(0x2a2b2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    noLa.preferredMaxLayoutWidth = 250;
    [noLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:noLa];
    self.orderNoLa = noLa;
    
    [noLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *stateLa = [UILabel publicLab:@"待发货" textColor:TCUIColorFromRGB(0x2a2b2a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Mdeium" size:14 numberOfLines:0];
    stateLa.preferredMaxLayoutWidth = 180;
    [stateLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:stateLa];
    self.stateLa = stateLa;
    
    [stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(14);
    }];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"partner_head_normal"];
    [self.contentView addSubview:headImage];
    self.headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(noLa.mas_bottom).offset(18);
            make.width.height.mas_equalTo(56);
    }];
    
    UILabel *nickLa = [UILabel publicLab:@"喵喵可乐" textColor:TCUIColorFromRGB(0x2a2b2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
    nickLa.preferredMaxLayoutWidth = 220;
    [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:nickLa];
    self.nameLa = nickLa;
    
    [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.top.mas_equalTo(noLa.mas_bottom).offset(20);
            make.height.mas_equalTo(17);
    }];
    
    UILabel *superiorLa = [UILabel publicLab:@"上级合伙人:喵喵可乐" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    superiorLa.preferredMaxLayoutWidth = 220;
    [superiorLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:superiorLa];
    self.superiorLa = superiorLa;
    
    [superiorLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.top.mas_equalTo(nickLa.mas_bottom).offset(8);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"2021-10-08 12:22:44" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 220;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *signLa = [UILabel publicLab:@"JPY" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    signLa.preferredMaxLayoutWidth = 100;
    [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:signLa];
    self.signLa = signLa;
    signLa.hidden = YES;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-40);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"198230" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:19 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 220;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-40);
            make.height.mas_equalTo(17);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 129.5, WIDTH - 20, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMPartnerOrderModel *)model{
    _model = model;
    self.nameLa.text = [NSString stringWithFormat:@"订单编号:%@",_model.ID];
    self.stateLa.text = _model.Processing;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.ChildName;
    self.superiorLa.text = [NSString stringWithFormat:@"上级合伙人：%@",_model.FatherName];
    self.timeLa.text = _model.AddTime;
    self.priceLa.text = _model.MyYongMoney;
    
}

@end
