//
//  MMGoodsSortCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/8.
//

#import "MMGoodsSortCell.h"
@interface MMGoodsSortCell ()
@property (nonatomic, strong) UIImageView *sortImage;
@property (nonatomic, strong) UILabel *titleLa;
@end

@implementation MMGoodsSortCell
-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}

-(void)setupUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 0, 52, 52)];
    logoImage.image = [UIImage imageNamed:@"sort_all_icon"];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    logoImage.layer.masksToBounds = YES;
    logoImage.layer.cornerRadius = 7.5;
    logoImage.layer.borderColor = TCUIColorFromRGB(0xefefef).CGColor;
    logoImage.layer.borderWidth = 0.5;
    [self.contentView addSubview:logoImage];
    self.sortImage = logoImage;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab.frame = CGRectMake(0, 62, 80, 11);
    [self.contentView addSubview:lab];
    self.titleLa = lab;
}

-(void)setModel:(MMSortModel *)model{
    _model = model;
    [self.sortImage sd_setImageWithURL:[NSURL URLWithString:_model.SmallPicture] placeholderImage:[UIImage imageNamed:@"sort_all_icon"]];
    self.titleLa.text = _model.Name;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLa.font = selected ? [UIFont fontWithName:@"PingFangSC-SemiBold" size:12] : [UIFont systemFontOfSize:11];
    
}
@end
