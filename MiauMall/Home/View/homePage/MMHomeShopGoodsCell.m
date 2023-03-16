//
//  MMHomeShopGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import "MMHomeShopGoodsCell.h"
@interface MMHomeShopGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *stockLa;//库存不足显示
@property (nonatomic, strong) UILabel *blurbLa;//商品简介
@property (nonatomic, strong) UILabel *goodsNameLa;//商品名称
@property (nonatomic, strong) UILabel *japaneseLabel;//日版小标签
@property (nonatomic, strong) UIImageView *lightningImage;//闪电小图标
@property (nonatomic, strong) UIView *deliverView;//48小时发货view
@property (nonatomic, strong) UILabel *deliverLa;//48小时发货label
@property (nonatomic, strong) UILabel *discountLa;//折扣label
@property (nonatomic, strong) UILabel *giveLa;//赠送label
@property (nonatomic, strong) UILabel *flatMoneyLa;//法币标识
@property (nonatomic, strong) UILabel *priceLa;//商品价格
@property (nonatomic, strong) UIButton *shopCarBt;//购物车按钮
@property (nonatomic, strong) UILabel *oldPriceLa;//原价
@property (nonatomic, strong) UILabel *salesLa;//销量



@end

@implementation MMHomeShopGoodsCell


-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}

//图片
-(UIImageView *)goodsImage{
    if(!_goodsImage){
        _goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _goodsImage.image = [UIImage imageNamed:@"goods"];
        _goodsImage.userInteractionEnabled = YES;
    }
    return _goodsImage;
}
//库存不足
-(UILabel *)stockLa{
    if(!_stockLa){
        _stockLa = [UILabel publicLab:@"库存不足仅剩10件" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _stockLa.frame = CGRectMake(0, self.width - 22, self.width, 22);
        _stockLa.backgroundColor = textBlackColor;
        _stockLa.alpha = 0.5;
    }
    return _stockLa;
}
//商品简介
-(UILabel *)blurbLa{
    if(!_blurbLa){
        _blurbLa = [UILabel publicLab:@"" textColor:textBlackColor textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    }
    return _blurbLa;
}
//日版标签
-(UILabel *)japaneseLabel{
    if(!_japaneseLabel){
        _japaneseLabel = [UILabel publicLab:@"日版" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _japaneseLabel.backgroundColor = redColor2;
        _japaneseLabel.layer.masksToBounds = YES;
        _japaneseLabel.layer.cornerRadius = 2.5;
    }
    return _japaneseLabel;
}

//商品名称
-(UILabel *)goodsNameLa{
    if(!_goodsNameLa){
        _goodsNameLa = [UILabel publicLab:@"" textColor:textBlackColor textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _goodsNameLa.preferredMaxLayoutWidth = self.width - 14;
        [_goodsNameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    }
    return _goodsNameLa;
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
        
        UILabel *deliverLa = [UILabel publicLab:@"48h发货" textColor:redColor1 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        deliverLa.frame = CGRectMake(13.5, 2, 45, 12);
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
        _giveLa.layer.masksToBounds = YES;
        _giveLa.layer.cornerRadius = 4.0;
        _giveLa.layer.borderWidth = 0.5;
        _giveLa.layer.borderColor = redColor1.CGColor;
    }
    return _giveLa;
}

//法币
-(UILabel *)flatMoneyLa{
    if(!_flatMoneyLa){
        _flatMoneyLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        _flatMoneyLa.preferredMaxLayoutWidth = 100;
        [_flatMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _flatMoneyLa;
}

//价格
-(UILabel *)priceLa{
    if(!_priceLa){
        _priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        _priceLa.preferredMaxLayoutWidth = 100;
        [_priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _priceLa;
}
//购物车按钮
-(UIButton *)shopCarBt{
    if(!_shopCarBt){
        _shopCarBt = [[UIButton alloc]init];
        [_shopCarBt setBackgroundImage:[UIImage imageNamed:@"goodsCar"] forState:(UIControlStateNormal)];
        [_shopCarBt addTarget:self action:@selector(clickCar) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shopCarBt;
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

//销量
-(UILabel *)salesLa{
    if(!_salesLa){
        _salesLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _salesLa.preferredMaxLayoutWidth = 150;
        [_salesLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _salesLa;
}




-(void)setupUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    
    [self.contentView addSubview:self.goodsImage];
    [self.goodsImage addSubview:self.stockLa];
    [self.contentView addSubview:self.blurbLa];
    [self.contentView addSubview:self.goodsNameLa];
    [self.contentView addSubview:self.deliverView];
    [self.contentView addSubview:self.discountLa];
    [self.contentView addSubview:self.giveLa];
    [self.contentView addSubview:self.flatMoneyLa];
    [self.contentView addSubview:self.priceLa];
    [self.contentView addSubview:self.shopCarBt];
    [self.contentView addSubview:self.oldPriceLa];
    [self.contentView addSubview:self.salesLa];
    
    [self makeConstriant];
  
}

-(void)makeConstriant{
    KweakSelf(self);
//    [self.blurbLa mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(7);
//        make.top.mas_equalTo(CGRectGetMaxY(weakself.goodsImage.frame) + 12);
//        make.right.mas_equalTo(-7);
//        make.height.mas_equalTo(15);
//    }];
    
    self.blurbLa.frame = CGRectMake(7, CGRectGetMaxY(weakself.goodsImage.frame) + 12, self.width - 14, 15);
    

    
    [self.goodsNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(12);
        make.width.mas_equalTo(weakself.width - 14);
//        make.height.mas_equalTo(34);
    }];
    
    [self.deliverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(16);
    }];
    
    [self.discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.deliverView.mas_right).offset(6);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(16);
    }];
    
    [self.giveLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.deliverView.mas_right).offset(48);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    
    [self.flatMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(weakself.deliverView.mas_bottom).offset(17);
        make.height.mas_equalTo(10);
    }];
    
    [self.priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.flatMoneyLa.mas_right).offset(7);
        make.top.mas_equalTo(weakself.deliverView.mas_bottom).offset(13);
        make.height.mas_equalTo(14);
    }];
    
    [self.shopCarBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-33);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    
    [self.salesLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(11);
    }];
    
    [self.oldPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(10);
    }];
}

-(void)setModel:(MMHomeRecommendGoodsModel *)model{
    KweakSelf(self);
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.blurbLa.text = _model.ShortName;
    self.goodsNameLa.text = _model.Name;
    float discount = [_model.UKDiscount floatValue];
    self.discountLa.text = [NSString stringWithFormat:@"%.f折",discount];
    self.flatMoneyLa.text = _model.PriceSign;
    self.priceLa.text = _model.PriceValue;
    self.salesLa.text = [NSString stringWithFormat:@"销量%@",_model.Sales];
    self.oldPriceLa.text = _model.OldPriceShow;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_model.OldPriceShow attributes:attribtDic];
    self.oldPriceLa.attributedText = attribtStr;
    [self.contentView addSubview:self.oldPriceLa];
    
//    NSLog(@"%lu",(unsigned long)_model.ShortName.length);
    
    if(_model.ShortName.length > 0){
        self.blurbLa.hidden = NO;
        [self.goodsNameLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMaxY(weakself.blurbLa.frame) + 12);
        }];

    }else{
        self.blurbLa.hidden = YES;
        [self.goodsNameLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMaxY(weakself.goodsImage.frame) + 17);
        }];
    }
    
    CGSize size = [NSString sizeWithText:_model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(self.width - 14,32)];
    if(size.height < 18){
        self.goodsNameLa.numberOfLines = 1;
    }else{
        self.goodsNameLa.numberOfLines = 2;
    }
//
//    if(_model.ShortName.length <= 0){
//        [self.blurbLa mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//    }
    
    
    
   
}

-(void)setModel1:(MMHomeGoodsModel *)model1{
    KweakSelf(self);
    _model1 = model1;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model1.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.blurbLa.text = _model1.mark;
    self.goodsNameLa.text = _model1.name;
    float discount = [_model1.discount floatValue];
    self.discountLa.text = [NSString stringWithFormat:@"%.f折",discount];
    NSArray *temp = [_model1.priceshow componentsSeparatedByString:@" "];
    NSString *str = temp[0];
    NSString *str1 = temp[1];
    self.flatMoneyLa.text = str;
    
    self.priceLa.text = str1;
    self.salesLa.text = [NSString stringWithFormat:@"销量%@",@"999+"];
    self.oldPriceLa.text = _model1.oldpriceshow;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_model1.oldpriceshow attributes:attribtDic];
    self.oldPriceLa.attributedText = attribtStr;
    [self.contentView addSubview:self.oldPriceLa];
    
//    NSLog(@"%lu",(unsigned long)_model.ShortName.length);
    
    if(_model1.mark.length > 0){
        self.blurbLa.hidden = NO;
        [self.goodsNameLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMaxY(weakself.blurbLa.frame) + 12);
        }];

    }else{
        self.blurbLa.hidden = YES;
        [self.goodsNameLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMaxY(weakself.goodsImage.frame) + 17);
        }];
    }
    
    CGSize size = [NSString sizeWithText:_model1.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(self.width - 14,32)];
    if(size.height < 18){
        self.goodsNameLa.numberOfLines = 1;
    }else{
        self.goodsNameLa.numberOfLines = 2;
    }
}


-(void)clickCar{
    self.TapCarBlock(_model.ID);
}
@end
