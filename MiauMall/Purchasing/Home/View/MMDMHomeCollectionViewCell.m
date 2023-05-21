//
//  MMDMHomeCollectionViewCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import "MMDMHomeCollectionViewCell.h"

@interface MMDMHomeCollectionViewCell ()
@property (nonatomic, strong) UIImageView *picImage;
@property (nonatomic, strong) UILabel *nameLa;

@end

@implementation MMDMHomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}

-(void)setupUI{
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    imageIcon.image = [UIImage imageNamed:@"zhanweif"];
    imageIcon.layer.masksToBounds = YES;
    imageIcon.layer.cornerRadius = 6.5;
    imageIcon.layer.borderColor = TCUIColorFromRGB(0xdbdbdb).CGColor;
    imageIcon.layer.borderWidth = 0.5;
    [self.contentView addSubview:imageIcon];
    self.picImage = imageIcon;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x393939) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
    nameLa.frame = CGRectMake(0, CGRectGetMaxY(imageIcon.frame) + 10, self.width, 12);
    [self.contentView addSubview:nameLa];
    self.nameLa = nameLa;
}

-(void)setModel:(MMDMHomeItemModel *)model{
    _model = model;
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.Name;
}




@end
