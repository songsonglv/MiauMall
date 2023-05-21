//
//  MMOrderAfterSelectGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/17.
//

#import "MMOrderAfterSelectGoodsCell.h"

@interface MMOrderAfterSelectGoodsCell ()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *attLa;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *sfLa;

@end

@implementation MMOrderAfterSelectGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 2, 85, 85)];
//    [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xdfdfdf).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [self.contentView addSubview:goodsImage];
    self.iconImage = goodsImage;
    
    UILabel *goodsNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x434343) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    goodsNameLa.frame = CGRectMake(116, 2, WIDTH - 171, 13);
    [self.contentView addSubview:goodsNameLa];
    self.goodsNameLa = goodsNameLa;
    
    UILabel *AttributeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
    AttributeLa.frame = CGRectMake(114, 27, 100, 18);
    [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
    AttributeLa.layer.masksToBounds = YES;
    AttributeLa.layer.cornerRadius = 9;
    [self.contentView addSubview:AttributeLa];
    self.attLa = AttributeLa;
    
    UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@%@",@"1",[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    numLa.frame = CGRectMake(WIDTH - 105, 27, 60, 13);
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth =  WIDTH - 148;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.bottom.mas_equalTo(-23);
                make.height.mas_equalTo(11);
    }];
    
    UILabel *acturaPriceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@ %@",[UserDefaultLocationDic valueForKey:@"actualPayment"],@"0"] textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    acturaPriceLa.preferredMaxLayoutWidth = WIDTH - 148;
    [acturaPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    acturaPriceLa.hidden = NO;
    [self.contentView addSubview:acturaPriceLa];
    self.sfLa = acturaPriceLa;
    
    [acturaPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(13);
    }];
    
//    [acturaPriceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//                confer.text([UserDefaultLocationDic valueForKey:@"actualPayment"]).textColor(TCUIColorFromRGB(0x0b0b0b)).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
//                confer.text(model.SalesMoneyShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
//    }];
}

-(void)setModel:(MMOrderListGoodsItemModel *)model{
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.Name;
    if([_model.Attribute isEqualToString:@""]){
        self.attLa.hidden = YES;
    }else{
       self.attLa.text = _model.Attribute;
       CGSize size = [self.attLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
        self.attLa.width = size.width + 20;
    }
    
    self.numLa.text = [NSString stringWithFormat:@"x%@%@",_model.Number,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    
    self.priceLa.text = _model.MoneysShow;
    self.sfLa.text = [NSString stringWithFormat:@"%@ %@",[UserDefaultLocationDic valueForKey:@"actualPayment"],_model.SalesMoneyShow];
    
    [self.sfLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text([UserDefaultLocationDic valueForKey:@"actualPayment"]).textColor(TCUIColorFromRGB(0x0b0b0b)).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
                confer.text(model.SalesMoneyShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
    }];
}

@end
