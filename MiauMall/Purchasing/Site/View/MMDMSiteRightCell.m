//
//  MMDMSiteRightCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import "MMDMSiteRightCell.h"

@interface MMDMSiteRightCell ()
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;
@end

@implementation MMDMSiteRightCell

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self creatUI];
}
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
    CGFloat wid = (WIDTH - 138)/3;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, wid)];
    image.image = [UIImage imageNamed:@"zhanweif"];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 6.5;
    image.layer.borderColor = TCUIColorFromRGB(0xdbdbdb).CGColor;
    image.layer.borderWidth = 0.5;
    [self.contentView addSubview:image];
    self.logoImage = image;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x393939) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab.frame = CGRectMake(0, wid + 12, wid, 12);
    [self.contentView addSubview:lab];
    self.nameLa = lab;
}

-(void)setModel:(MMDMHomeItemModel *)model{
    _model = model;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.Name;
}



@end
