//
//  MMStrollGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/30.
//

#import "MMStrollGoodsCell.h"
@interface MMStrollGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *stockLa;//库存不足显示
@property (nonatomic, strong) UILabel *blurbLa;//商品简介
@property (nonatomic, strong) UILabel *goodsNameLa;//商品名称
@property (nonatomic, strong) UILabel *tagLa;//日版小标签
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

@implementation MMStrollGoodsCell

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
        _goodsImage.image = [UIImage imageNamed:@"zhanweif"];
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
        _stockLa.hidden = YES;
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
//标签
-(UILabel *)tagLa{
    if(!_tagLa){
        _tagLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _tagLa.layer.masksToBounds = YES;
        _tagLa.layer.cornerRadius = 2.5;
    }
    return _tagLa;
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

//deliverLa
-(UILabel *)deliverLa{
    if(!_deliverLa){
        _deliverLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _deliverLa.layer.masksToBounds = YES;
        _deliverLa.layer.cornerRadius = 2;
        _deliverLa.layer.borderColor = redColor2.CGColor;
        _deliverLa.layer.borderWidth = 0.5;
//        _deliverLa.preferredMaxLayoutWidth = 180;
//        [_deliverLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _deliverLa;
}

//48h发货
//-(UIView *)deliverView{
//    if(!_deliverView){
//        _deliverView = [[UIView alloc]init];
//        _deliverView.backgroundColor = TCUIColorFromRGB(0xfddbd7);
//        _deliverView.alpha = 0.7;
//        _deliverView.layer.masksToBounds = YES;
//        _deliverView.layer.cornerRadius = 4;
//
//        UIImageView *ligntImage = [[UIImageView alloc]initWithFrame:CGRectMake(4.5, 2, 6, 12)];
//        ligntImage.image = [UIImage imageNamed:@"lightning"];
//        [_deliverView addSubview:ligntImage];
//
//        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
//        UILabel *deliverLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"ship48h"] textColor:redColor1 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
//        deliverLa.frame = CGRectMake(13.5, 2, size.width, 12);
//        [_deliverView addSubview:deliverLa];
//    }
//    return _deliverView;
//}

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
        _giveLa.hidden = YES;
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
    [self.contentView addSubview:self.tagLa];
    
    [self.contentView addSubview:self.goodsNameLa];
//    [self.contentView addSubview:self.deliverView];
    [self.contentView addSubview:self.deliverLa];
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
    

    [self.tagLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(12);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(50);
    }];
    
    [self.goodsNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(weakself.blurbLa.mas_bottom).offset(12);
        make.width.mas_equalTo(weakself.width - 14);
//        make.height.mas_equalTo(34);
    }];
    
//    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
    
    [self.deliverLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(2);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(16);
    }];
    
    [self.discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.deliverLa.mas_right).offset(6);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(2);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(16);
    }];
    
    [self.giveLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.deliverLa.mas_right).offset(48);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    
    [self.flatMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(10);
    }];
    
    [self.priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.flatMoneyLa.mas_right).offset(7);
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(14);
    }];
    
    [self.shopCarBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-30);
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
    
    UIColor *col = [_model.ColumnID isEqualToString:@"828"] ? TCUIColorFromRGB(0x333333) : redColor2;
    self.tagLa.text = _model.ProductSign;
    self.tagLa.backgroundColor = col;
    
    if(_model.ProductSign){
        self.tagLa.hidden = NO;
    }else{
        self.tagLa.hidden = YES;
    }
    
    CGSize size1 = [NSString sizeWithText:self.tagLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    [self.tagLa mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(weakself.goodsNameLa.mas_top).offset(2);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(size1.width + 8);
    }];
    
    CGSize size3 = [NSString sizeWithText:_model.DiscountShow font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size1.width + 12;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.Name] attributes:@{NSParagraphStyleAttributeName: style}];
    if([_model.ColumnID isEqualToString:@"828"]){
        style.firstLineHeadIndent = size1.width + 12;//首行缩进
        attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.Name] attributes:@{NSParagraphStyleAttributeName: style}];
    }

    self.goodsNameLa.attributedText = attrText;
    
    NSInteger realnum = [_model.RealNumber integerValue];
    CGSize size01;
    if(_model.ProductSignTimeStr.length == 0){
        self.deliverLa.hidden = YES;
        [self.discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(16);
        }];
    }else{
        self.deliverLa.text = _model.ProductSignTimeStr;
        size01 = [NSString sizeWithText:_model.ProductSignTimeStr font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        [self.deliverLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size01.width + 8);
        }];
    }
    if(realnum > 0){
//        self.deliverView.hidden = NO;
        self.deliverLa.textColor = redColor2;
        self.deliverLa.layer.borderColor = redColor2.CGColor;
        
    }else{
//        self.deliverView.hidden = YES;
        self.deliverLa.textColor = TCUIColorFromRGB(0x5dbf03);
        self.deliverLa.layer.borderColor = TCUIColorFromRGB(0x5dbf03).CGColor;
    }
    float discount = [_model.DiscountShow floatValue];
    if(discount == 0){
        self.discountLa.hidden = YES;
    }else{
        self.discountLa.text = [NSString stringWithFormat:@"%@",_model.DiscountShow];
        
        [self.discountLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size3.width + 8);
        }];
    }
    self.flatMoneyLa.text = _model.PriceSign;
    self.priceLa.text = _model.PriceValue;
    self.salesLa.text = [NSString stringWithFormat:@"%@:%@",[UserDefaultLocationDic valueForKey:@"salesVol"],_model.Sales];
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
}

-(void)clickCar{
    self.TapCarBlock(_model.ID);
}
@end



