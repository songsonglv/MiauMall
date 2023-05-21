//
//  MMConfirmGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import "MMConfirmGoodsCell.h"

@interface MMConfirmGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UILabel *weightLa;//重量
@property (nonatomic, strong) UILabel *productSignLa;//只有预售的显示标签
@end

@implementation MMConfirmGoodsCell

-(UILabel *)productSignLa{
    if(!_productSignLa){
        CGSize size = [NSString sizeWithText:self.model.ProductSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
        _productSignLa = [UILabel publicLab:self.model.ProductSign textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        _productSignLa.frame = CGRectMake(124, 34, size.width + 12, 15);
        _productSignLa.backgroundColor = redColor2;
        _productSignLa.layer.masksToBounds = YES;
        _productSignLa.layer.cornerRadius = 2.5;
    }
    return _productSignLa;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 22, 96, 96)];
    //goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xf3f4f4).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 148;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(124);
            make.top.mas_equalTo(34);
            make.width.mas_equalTo(WIDTH - 148);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:20 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = WIDTH - 148;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(124);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(34);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = 100;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *weightLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    weightLa.preferredMaxLayoutWidth = 100;
    [weightLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:weightLa];
    self.weightLa = weightLa;
    
    [weightLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(32);
            make.height.mas_equalTo(12);
    }];
}

-(void)setModel:(MMPackageGoodsModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.name;
//    CGSize size = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 148,MAXFLOAT)];
//    if(size.height < 18){
//        self.goodsNameLa.numberOfLines = 1;
//    }else{
//        self.goodsNameLa.numberOfLines = 2;
//    }
    
    if([_model.ColumnID isEqualToString:@"794"]){
        [self.contentView addSubview:self.productSignLa];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = self.productSignLa.width + 4;//首行缩进
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",model.name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
        self.goodsNameLa.attributedText = attrText;
        
        NSArray *temp=[_model.priceshow componentsSeparatedByString:@" "];
        [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"balanceMoney"],temp[0]]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:11]);
            confer.text(temp[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:20]);
        }];
    }else{
        CGSize size = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 148,MAXFLOAT)];
          if(size.height < 18){
              self.goodsNameLa.numberOfLines = 1;
          }else{
              self.goodsNameLa.numberOfLines = 2;
          }
        
        NSArray *temp=[_model.priceshow componentsSeparatedByString:@" "];
        [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(temp[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:11]);
            confer.text(temp[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:20]);
        }];
    }
    
//    NSArray *temp=[_model.priceshow componentsSeparatedByString:@" "];
//    [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//        confer.text([NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"balanceMoney"],temp[0]]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:11]);
//        confer.text(temp[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:20]);
//    }];
////
    self.numLa.text = [NSString stringWithFormat:@"x%@",_model.num];
    self.weightLa.text = [NSString stringWithFormat:@"%@.kg",_model.weight];
}

@end
