//
//  MMBrandGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/10.
//

#import "MMBrandGoodsCell.h"
@interface MMBrandGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *shortNameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *saleLa;
@end

@implementation MMBrandGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 146)];
    conV.backgroundColor = TCUIColorFromRGB(0xffffff);
    conV.layer.masksToBounds = YES;
    conV.layer.cornerRadius = 7.5;
    [self.contentView addSubview:conV];
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 122, 128)];
    goodsImage.image = [UIImage imageNamed:@"zanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 7.5;
    [conV addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *goodsNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    goodsNameLa.preferredMaxLayoutWidth = WIDTH - 160;
    [goodsNameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [conV addSubview:goodsNameLa];
    self.goodsNameLa = goodsNameLa;
    
    [goodsNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(126);
            make.top.mas_equalTo(18);
            make.width.mas_equalTo(WIDTH - 160);
    }];
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa8a8a8) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH - 160;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
//    lab.frame = CGRectMake(126, 60, WIDTH - 160, 12);
    [conV addSubview:lab];
    self.shortNameLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(126);
            make.top.mas_equalTo(goodsNameLa.mas_bottom).offset(10);
            make.width.mas_equalTo(WIDTH - 160);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:17 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = WIDTH - 226;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(126);
            make.top.mas_equalTo(115);
            make.height.mas_equalTo(15);
    }];
    
    UILabel *saleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    saleLa.preferredMaxLayoutWidth = 120;
    [saleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:saleLa];
    self.saleLa = saleLa;
    
    [saleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(11);
    }];
}

-(void)setModel:(MMHomeRecommendGoodsModel *)model{
    _model = model;
    KweakSelf(self);
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.Name;
    CGSize size = [NSString sizeWithText:_model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(WIDTH - 168,32)];
    if(size.height < 18){
        self.goodsNameLa.numberOfLines = 1;
    }else{
        self.goodsNameLa.numberOfLines = 2;
    }
    self.shortNameLa.text = _model.ShortName;
    self.priceLa.text = [NSString stringWithFormat:@"%@%@",_model.PriceSign,_model.PriceValue];
    [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(weakself.model.PriceSign).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
        confer.text(weakself.model.PriceValue).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:17]);
    }];
    self.saleLa.text = [NSString stringWithFormat:@"销量%@",_model.Sales];
}


@end
