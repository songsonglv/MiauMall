//
//  MMAddressListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import "MMAddressListCell.h"
@interface MMAddressListCell ()
@property (nonatomic, strong) UIImageView *seleImage;//是否默认的icon
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UILabel *addressLa;
@end

@implementation MMAddressListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 28, 15, 15)];
    seleImage.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:seleImage];
    self.seleImage = seleImage;
    
    UILabel *lab = [UILabel publicLab:@"默认地址" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab.frame = CGRectMake(40, 28.5, 60, 14);
    [self.contentView addSubview:lab];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 60;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(68);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *addressLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 64;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:addressLa];
    self.addressLa = addressLa;
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(15);
            make.right.mas_equalTo(-40);
    }];
    
    UIButton *deleteBt = [[UIButton alloc]init];
    [deleteBt setImage:[UIImage imageNamed:@"delete_account_icon"] forState:(UIControlStateNormal)];
    [deleteBt addTarget:self action:@selector(clickDele) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:deleteBt];
    
    [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(66);
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(14);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, WIDTH, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMAddressModel *)model{
    _model = model;
    if([_model.IsDefault isEqualToString:@"1"]){
        self.seleImage.image = [UIImage imageNamed:@"select_yes_black"];
    }else{
        self.seleImage.image = [UIImage imageNamed:@"select_no"];
    }
    
    self.nameLa.text = [NSString stringWithFormat:@"%@  %@",_model.Consignee,_model.MobilePhone];
    self.addressLa.text = [NSString stringWithFormat:@"%@-%@",_model.AreaName,_model.Address];
}

-(void)clickDele{
    self.clickDeleteBlock(self.model.ID);
}

@end
