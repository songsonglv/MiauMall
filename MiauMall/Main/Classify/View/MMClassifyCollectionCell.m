//
//  MMClassifyCollectionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import "MMClassifyCollectionCell.h"

@interface MMClassifyCollectionCell ()
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;

@end

@implementation MMClassifyCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self creatUI];
}
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    CGFloat wid = (WIDTH - 130)/3;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 64)/2, 0, 64, 64)];
    image.image = [UIImage imageNamed:@"zhanweif"];
    [self.contentView addSubview:image];
    self.logoImage = image;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab.frame = CGRectMake(0, 72, wid, 11);
    [self.contentView addSubview:lab];
    self.nameLa = lab;
}

-(void)setModel:(MMSortDataModel *)model{
    _model = model;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.name;
}


@end
