//
//  MMGoodsListEnglishCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import "MMGoodsListEnglishCell.h"

@interface MMGoodsListEnglishCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *blurLa;//简介
@property (nonatomic, strong) UILabel *signLa;//发货时间
@property (nonatomic, strong) UILabel *priceLa;

@end

@implementation MMGoodsListEnglishCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 123, 123)];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 155;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(22);
            make.width.mas_equalTo(WIDTH - 155);
    }];
    
    UILabel *blurLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
//    blurLa.preferredMaxLayoutWidth = WIDTH - 155;
//    [blurLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:blurLa];
    self.blurLa = blurLa;
    
    [blurLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(8);
            make.width.mas_equalTo(WIDTH - 155);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *signLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xf0730d) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    
    signLa.backgroundColor = [UIColor colorWithWzx:0xf0730d alpha:0.2];
    signLa.layer.masksToBounds = YES;
    signLa.layer.cornerRadius = 4;
    signLa.layer.borderColor = TCUIColorFromRGB(0xe13925).CGColor;
    signLa.layer.borderWidth = 0.5;
    [self.contentView addSubview:signLa];
    self.signLa = signLa;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(blurLa.mas_bottom).offset(8);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(17);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 150;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(blurLa.mas_bottom).offset(36);
            make.height.mas_equalTo(17);
    }];
    
    UIButton *cartBt = [[UIButton alloc]init];
    [cartBt setImage:[UIImage imageNamed:@"cart_english"] forState:(UIControlStateNormal)];
    cartBt.timeInterval = 2.0;
    [cartBt addTarget:self action:@selector(clickCart) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:cartBt];
    [cartBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(blurLa.mas_bottom).offset(22);
            make.width.height.mas_equalTo(32);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 155.5, WIDTH - 20, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xebebeb);
    [self.contentView addSubview:line];;
    
    
    
}

-(void)setModel:(MMHomeRecommendGoodsModel *)model{
    KweakSelf(self);
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.blurLa.text = _model.ShortName;
    self.nameLa.text = _model.Name;
    self.priceLa.text = _model.PriceShow;
    
    CGSize size = [NSString sizeWithText:_model.Name font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 155,MAXFLOAT)];
    if(size.height < 18){
        self.nameLa.numberOfLines = 1;
    }else{
        self.nameLa.numberOfLines = 2;
    }
    
    if(_model.ProductSignTimeStr.length == 0 || !_model.ProductSignTimeStr){
        self.signLa.hidden = YES;
    }else{
        CGSize size1 = [NSString sizeWithText:_model.ProductSignTimeStr font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        self.signLa.text = _model.ProductSignTimeStr;
        [self.signLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(140);
                make.top.mas_equalTo(weakself.blurLa.mas_bottom).offset(8);
                make.width.mas_equalTo(size1.width + 11);
                make.height.mas_equalTo(17);
        }];
    }
    
    
    
}

-(void)clickCart{
    self.clickShopCar(self.model.ID);
}
@end
