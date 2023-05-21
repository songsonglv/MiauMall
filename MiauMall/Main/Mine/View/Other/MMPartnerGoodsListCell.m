//
//  MMPartnerGoodsListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import "MMPartnerGoodsListCell.h"
@interface MMPartnerGoodsListCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UILabel *signLa;
@property (nonatomic, strong) UILabel *priceLa;
@end

@implementation MMPartnerGoodsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"zhanweif"];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 5;
    image.layer.borderColor = TCUIColorFromRGB(0xaeaeae).CGColor;
    image.layer.borderWidth = 0.5;
    [self.contentView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.width.mas_equalTo(129);
            make.height.mas_equalTo(116);
    }];
    self.goodsImage = image;
    
    UILabel *nameLa = [UILabel publicLab:@"【日版】Arouge 持续保湿精华净白美容液30ml" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 180;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(152);
            make.top.mas_equalTo(26);
            make.width.mas_equalTo(WIDTH - 180);
    }];
    self.goodsNameLa = nameLa;
    
    UILabel *numLa = [UILabel publicLab:@"购买数量:12121" textColor:TCUIColorFromRGB(0x525252) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = WIDTH - 200;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(150);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(11);
    }];
    self.numLa = numLa;
    UILabel *priceLa = [UILabel publicLab:@"9092" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 120;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(13);
    }];
    self.priceLa = priceLa;
    
    
    UILabel *signLa = [UILabel publicLab:@"JPY" textColor:TCUIColorFromRGB(0xe1321a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    signLa.preferredMaxLayoutWidth = 100;
    [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:signLa];
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(priceLa.mas_left).offset(-7);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(11);
    }];
    self.signLa = signLa;
}


-(void)setModel:(MMPartnerHotSaleGoodsModel *)model{
    _model = model;
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zahnweif"]];
    self.goodsNameLa.text = _model.Name;
    self.numLa.text = [NSString stringWithFormat:@"购买数量:%@",_model.OrderCount];
    self.priceLa.text = _model.Price;
    self.signLa.hidden = YES;
}
@end
