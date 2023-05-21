//
//  MMMyAssessGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import "MMMyAssessGoodsCell.h"

@interface MMMyAssessGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UILabel *desLa;//描述
@end

@implementation MMMyAssessGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 27, 100, 100)];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xf0f0f0).CGColor;
    goodsImage.layer.borderWidth = 1;
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    [self.contentView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.top.mas_equalTo(34);
            make.width.mas_equalTo(WIDTH - 145);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = 150;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(15);
            make.height.mas_equalTo(13);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:redColor2];
    [btn setTitle:@"评价" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 12;
    [btn addTarget:self action:@selector(GoAssess) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.bottom.mas_equalTo(-24);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(24);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(WIDTH - 28);
            make.height.mas_equalTo(0.5);
    }];
    
    
}

-(void)setModel:(MMNoAssessGoodsModel *)model{
    KweakSelf(self);
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.Name;
    self.numLa.text = [NSString stringWithFormat:@"x%@%@",_model.Number,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    
    if([_model.Attribute isEqualToString:@""]){
        
    }else{
        UILabel *AttributeLa = [UILabel publicLab:_model.Attribute textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
//        AttributeLa.frame = CGRectMake(128, 59, size.width + 20, 18);
        [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
        AttributeLa.layer.masksToBounds = YES;
        AttributeLa.layer.cornerRadius = 9;
        [self.contentView addSubview:AttributeLa];
        
        [AttributeLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(128);
                    make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(12);
                    make.width.mas_equalTo(size.width + 20);
                    make.height.mas_equalTo(18);
        }];
    }
}


-(void)GoAssess{
    self.goAssessBlock(self.model.ID);
}
@end
