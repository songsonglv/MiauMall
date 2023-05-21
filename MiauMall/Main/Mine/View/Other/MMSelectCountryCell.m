//
//  MMSelectCountryCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//

#import "MMSelectCountryCell.h"

@interface MMSelectCountryCell ()

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;
@end

@implementation MMSelectCountryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(24, 20, 14, 14)];
    selectImage.image = [UIImage imageNamed:@"select_no"];
    [self.contentView addSubview:selectImage];
    self.selectImage = selectImage;
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectImage.frame) + 10, 15, 40, 24)];
    logoImage.layer.masksToBounds = YES;
    logoImage.layer.cornerRadius = 2.4;
    [self.contentView addSubview:logoImage];
    self.logoImage = logoImage;
    
    UILabel *label = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    label.frame = CGRectMake(CGRectGetMaxX(logoImage.frame) + 18, 19, 200, 16);
    [self.contentView addSubview:label];
    self.nameLa = label;
    
    
}

-(void)setModel:(MMCountryInfoModel *)model{
    _model = model;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture]];
    self.nameLa.text = [NSString stringWithFormat:@"%@ %@ ",_model.UKShortName,_model.Name];
    
}

@end
