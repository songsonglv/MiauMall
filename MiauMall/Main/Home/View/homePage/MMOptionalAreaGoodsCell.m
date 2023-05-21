//
//  MMOptionalAreaGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//

#import "MMOptionalAreaGoodsCell.h"

@interface MMOptionalAreaGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *optionalLa;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *oldPriceLa;
@property (nonatomic, strong) UILabel *saleLa;//销量
@end

@implementation MMOptionalAreaGoodsCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 6;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    CGFloat wid = (WIDTH - 30)/2;
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, wid)];
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel*optionalLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    optionalLa.frame = CGRectMake(7, 148, wid - 14, 16);
    optionalLa.backgroundColor = TCUIColorFromRGB(0xf47606);
    optionalLa.layer.masksToBounds = YES;
    optionalLa.layer.cornerRadius = 2.5;
    [self.contentView addSubview:optionalLa];
    self.optionalLa = optionalLa;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x2c2c2c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = wid - 14;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.top.mas_equalTo(wid + 8);
            make.width.mas_equalTo(wid - 14);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = wid - 14;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.bottom.mas_equalTo(-32);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *oldLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x7d7d7d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    oldLa.preferredMaxLayoutWidth = 130;
    [oldLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:oldLa];
    self.oldPriceLa = oldLa;
    
    [oldLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(9);
            make.bottom.mas_equalTo(-12);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *saleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    saleLa.preferredMaxLayoutWidth = 120;
    [saleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:saleLa];
    self.saleLa = saleLa;
    
    [saleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-12);
            make.height.mas_equalTo(11);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)setModel:(MMHomeRecommendGoodsModel *)model{
    _model = model;
    KweakSelf(self);
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.Name;
    CGSize size = [NSString sizeWithText:_model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake((WIDTH - 30)/2 - 14,MAXFLOAT)];
    if(size.height < 18){
        self.nameLa.numberOfLines = 1;
    }else{
        self.nameLa.numberOfLines = 2;
    }
    
    self.priceLa.text = _model.PriceShow;
    [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(weakself.model.PriceSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
        confer.text(weakself.model.PriceValue).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
    }];
    
    self.oldPriceLa.text = _model.OldPriceShow;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_model.OldPriceShow attributes:attribtDic];
    self.oldPriceLa.attributedText = attribtStr;
    
    self.saleLa.text = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"salesVolume"],_model.Sales];
    
}

-(void)setOptionalName:(NSString *)optionalName{
    _optionalName = optionalName;
    CGSize size = [NSString sizeWithText:_optionalName font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    self.optionalLa.text = _optionalName;
    self.optionalLa.width = size.width + 10;
}


-(void)clickBt{
    self.tapGoodsBlock(self.model.Url);
}
@end
