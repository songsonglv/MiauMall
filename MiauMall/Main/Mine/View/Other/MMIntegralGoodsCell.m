//
//  MMIntegralGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import "MMIntegralGoodsCell.h"

@interface MMIntegralGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *priceLa;
@end

@implementation MMIntegralGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.borderColor = TCUIColorFromRGB(0xe6e6e6).CGColor;
        self.contentView.layer.borderWidth = 1;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    CGFloat wid = (WIDTH - 28)/2;
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 8, wid - 12, 170)];
    goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *goodsNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x2c2c2c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    goodsNameLa.frame = CGRectMake(10, CGRectGetMaxY(goodsImage.frame) + 8, wid - 20, 13);
    [self.contentView addSubview:goodsNameLa];
    self.nameLa = goodsNameLa;
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xfe4a30) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    priceLa.frame = CGRectMake(10, CGRectGetMaxY(goodsNameLa.frame) + 12, wid - 20, 16);
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(32, CGRectGetMaxY(priceLa.frame) + 12, wid - 64, 26)];
    [btn setBackgroundColor:TCUIColorFromRGB(0xfe4a30)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"redeemNow"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 13;
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    
    
    
    
}

-(void)setModel:(MMIntegralListGoodsModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture]];
    self.nameLa.text = _model.Name;
    self.priceLa.text = [NSString stringWithFormat:@"%@%@",_model.IntegralFull,[UserDefaultLocationDic valueForKey:@"integral"]];
}

-(void)clickBt{
    self.tapExchangeBlock(self.model.ID);
}
@end
