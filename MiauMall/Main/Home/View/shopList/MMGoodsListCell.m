//
//  MMGoodsListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import "MMGoodsListCell.h"

@interface MMGoodsListCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *blurbLa;//简介
@property (nonatomic, strong) UIImageView *lightningImage;//闪电小图标
@property (nonatomic, strong) UIView *deliverView;//48小时发货view
@property (nonatomic, strong) UILabel *deliverLa;//48小时发货label
@property (nonatomic, strong) UILabel *discountLa;//折扣label
@property (nonatomic, strong) UILabel *giveLa;//赠送label
@property (nonatomic, strong) UILabel *signLa;//法币标识
@property (nonatomic, strong) UILabel *priceLa;//商品价格
@property (nonatomic, strong) UIButton *shopCarBt;//购物车按钮
@property (nonatomic, strong) UILabel *oldPriceLa;//原价
@property (nonatomic, strong) UILabel *saleLa;//销量
@property (nonatomic, strong) UIView *conV;
@end

@implementation MMGoodsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

//48h发货
-(UIView *)deliverView{
    if(!_deliverView){
        _deliverView = [[UIView alloc]init];
        _deliverView.backgroundColor = TCUIColorFromRGB(0xfddbd7);
        _deliverView.alpha = 0.7;
        _deliverView.layer.masksToBounds = YES;
        _deliverView.layer.cornerRadius = 4;
        
        UIImageView *ligntImage = [[UIImageView alloc]initWithFrame:CGRectMake(4.5, 2, 6, 12)];
        ligntImage.image = [UIImage imageNamed:@"lightning"];
        [_deliverView addSubview:ligntImage];
        
        UILabel *deliverLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"ship48h"] textColor:redColor1 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        
        deliverLa.frame = CGRectMake(13.5, 2, size.width, 12);
        [_deliverView addSubview:deliverLa];
    }
    return _deliverView;
}

//折扣label
-(UILabel *)discountLa{
    if(!_discountLa){
        _discountLa = [UILabel publicLab:@"" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _discountLa.layer.masksToBounds = YES;
        _discountLa.layer.cornerRadius = 4.0;
        _discountLa.layer.borderWidth = 0.5;
        _discountLa.layer.borderColor = redColor1.CGColor;
    }
    return _discountLa;
}

//赠送label
-(UILabel *)giveLa{
    if(!_giveLa){
        _giveLa = [UILabel publicLab:@"赠" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _giveLa.hidden = YES;
        _giveLa.layer.masksToBounds = YES;
        _giveLa.layer.cornerRadius = 4.0;
        _giveLa.layer.borderWidth = 0.5;
        _giveLa.layer.borderColor = redColor1.CGColor;
    }
    return _giveLa;
}

//原价
-(UILabel *)oldPriceLa{
    if(!_oldPriceLa){
        _oldPriceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x7d7d7d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        _oldPriceLa.preferredMaxLayoutWidth = 150;
        [_oldPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _oldPriceLa;
}

//购物车按钮
-(UIButton *)shopCarBt{
    if(!_shopCarBt){
        _shopCarBt = [[UIButton alloc]init];
        [_shopCarBt setBackgroundImage:[UIImage imageNamed:@"goodsCar"] forState:(UIControlStateNormal)];
        [_shopCarBt addTarget:self action:@selector(clickCar) forControlEvents:(UIControlEventTouchUpInside)];
        _shopCarBt.timeInterval = 2.0f;
    }
    return _shopCarBt;
}

-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xdddddd);
    UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 146)];
    conV.backgroundColor = TCUIColorFromRGB(0xffffff);
    conV.layer.masksToBounds = YES;
    conV.layer.cornerRadius = 7;
    [self.contentView addSubview:conV];
    self.conV = conV;
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 122, 128)];
    goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 7;
    [conV addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *goodsNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    goodsNameLa.preferredMaxLayoutWidth = WIDTH - 168;
    [goodsNameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [conV addSubview:goodsNameLa];
    self.nameLa = goodsNameLa;
    
    [goodsNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.top.mas_equalTo(16);
            make.width.mas_equalTo(WIDTH - 168);
    }];
    
    UILabel *blurLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    blurLa.preferredMaxLayoutWidth = WIDTH - 168;
    [blurLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:blurLa];
    
    [blurLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.top.mas_equalTo(goodsNameLa.mas_bottom).offset(6);
            make.height.mas_equalTo(12);
    }];
    self.blurbLa = blurLa;
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];

    [conV addSubview:self.deliverView];
    
    [self.deliverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(128);
        make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(7);
        make.width.mas_equalTo(size.width + 20);
        make.height.mas_equalTo(16);
    }];
    
    [conV addSubview:self.discountLa];
    
    [self.discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.deliverView.mas_right).offset(6);
            make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(7);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(16);
    }];
    
    [conV addSubview:self.giveLa];
    
    [self.giveLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.discountLa.mas_right).offset(5);
            make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(7);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(16);
    }];
    
    UILabel *saleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    saleLa.preferredMaxLayoutWidth = WIDTH - 168;
    [saleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:saleLa];
    self.saleLa = saleLa;
    
    [saleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.top.mas_equalTo(weakself.deliverView.mas_bottom).offset(8);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *signLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    signLa.preferredMaxLayoutWidth = 100;
    [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:signLa];
    self.signLa = signLa;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.bottom.mas_equalTo(-13);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 200;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(signLa.mas_right).offset(6);
            make.bottom.mas_equalTo(-13);
            make.height.mas_equalTo(15);
    }];
    
    [conV addSubview:self.oldPriceLa];
    
    [self.oldPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.priceLa.mas_right).offset(7);
            make.bottom.mas_equalTo(-13);
            make.height.mas_equalTo(10);
    }];
    
    [conV addSubview:self.shopCarBt];
    
    [self.shopCarBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-11);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(18);
    }];
}
-(void)setModel:(MMHomeRecommendGoodsModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.blurbLa.text = _model.ShortName;
    self.nameLa.text = _model.Name;
    float discount = [_model.UKDiscount floatValue];
    if(_model.DiscountShow.length > 0){
        self.discountLa.text = [NSString stringWithFormat:@"%@",_model.DiscountShow];
        CGSize size = [NSString sizeWithText:_model.DiscountShow font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        [self.discountLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size.width + 8);
        }];
    }else{
        self.discountLa.hidden = YES;
    }
    
    self.signLa.text = _model.PriceSign;
    self.priceLa.text = _model.PriceValue;
    self.saleLa.text = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"salesVol"],_model.Sales];
    self.oldPriceLa.text = _model.OldPriceShow;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_model.OldPriceShow attributes:attribtDic];
    self.oldPriceLa.attributedText = attribtStr;
    [self.conV addSubview:self.oldPriceLa];
    
    
    CGSize size = [NSString sizeWithText:_model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(WIDTH - 168,32)];
    if(size.height < 18){
        self.nameLa.numberOfLines = 1;
    }else{
        self.nameLa.numberOfLines = 2;
    }
}

-(void)clickCar{
    self.clickShopCar(self.model.ID);
}

@end
