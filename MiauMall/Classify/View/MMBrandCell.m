//
//  MMBrandCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import "MMBrandCell.h"
@interface MMBrandCell ()
@property (nonatomic, strong) UIImageView *brandImage;
@property (nonatomic, strong) UILabel *brandNameLa;
@end

@implementation MMBrandCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 48, 48)];
    logoImage.image = [UIImage imageNamed:@"zhanweif"];
    [self.contentView addSubview:logoImage];
    self.brandImage = logoImage;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH - 105;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab];
    self.brandNameLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(72);
            make.centerY.mas_equalTo(weakself.contentView);
            make.height.mas_equalTo(14);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 77.5, WIDTH - 24, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xf6f6f6);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMBrandModel *)model{
    _model = model;
    [self.brandImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.brandNameLa.text = _model.Name;
}
@end
