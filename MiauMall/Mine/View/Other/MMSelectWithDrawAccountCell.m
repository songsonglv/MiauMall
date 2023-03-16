//
//  MMSelectWithDrawAccountCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMSelectWithDrawAccountCell.h"

@interface MMSelectWithDrawAccountCell ()
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *noLa;

@end

@implementation MMSelectWithDrawAccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(32, 15, 50, 50)];
    logoImage.image = [UIImage imageNamed:@"miau_pay_icon"];
    [self.contentView addSubview:logoImage];
    
    self.logoImage = logoImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x494645) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 120;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(102);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(16);
    }];
    self.nameLa = nameLa;
    
    UILabel *noLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x5a5a5a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    noLa.preferredMaxLayoutWidth = 220;
    [noLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:noLa];
    
    [noLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(102);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(11);
            make.height.mas_equalTo(14);
    }];
    self.noLa = noLa;
    
    
    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 52, 32, 16, 16)];
    selectImage.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:selectImage];
    self.selectImage = selectImage;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 79.5, WIDTH - 20, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [self.contentView addSubview:line];
    
}

-(void)setModel:(MMPartnerAccountModel *)model{
    _model = model;
    if([_model.Type isEqualToString:@"0"]){
        self.logoImage.image = [UIImage imageNamed:@"ali_pay_icon"];
        self.nameLa.text = @"支付宝账户";
        self.noLa.text = _model.AccountNo;
    }else if ([_model.Type isEqualToString:@"1"]){
        self.logoImage.image = [UIImage imageNamed:@"wx_pay_icon"];
        self.nameLa.text = @"微信账户";
        self.noLa.text = _model.AccountNo;
    }else if ([_model.Type isEqualToString:@"2"]){
        self.logoImage.image = [UIImage imageNamed:@"paypal_pay_icon"];
        self.nameLa.text = @"银行卡账户";
        self.noLa.text = _model.AccountNo;
    }else{
        self.logoImage.image = [UIImage imageNamed:@"miau_pay_icon"];
        self.nameLa.text = @"MIAU钱包";
        self.noLa.text = @"";
    }
    
}

@end
