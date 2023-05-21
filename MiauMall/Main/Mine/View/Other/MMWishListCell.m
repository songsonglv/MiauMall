//
//  MMWishListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import "MMWishListCell.h"
@interface MMWishListCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *desLa;//描述
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UIButton *goShopBt;
@property (nonatomic, strong) UIButton *addWishBt;
@end

@implementation MMWishListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 112, 112)];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 7.5;
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 172;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(22);
            make.width.mas_equalTo(WIDTH - 202);
    }];
    
    UILabel *desLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8c8c8c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    desLa.preferredMaxLayoutWidth = WIDTH - 172;
    [desLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:desLa];
    self.desLa = desLa;
    
    [desLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(140);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(12);
            make.width.mas_equalTo(WIDTH - 182);
    }];
    
    UIButton *wishBt = [[UIButton alloc]init];
    [wishBt setImage:[UIImage imageNamed:@"wish_no_icon"] forState:(UIControlStateNormal)];
    [wishBt setImage:[UIImage imageNamed:@"wish_yes_icon"] forState:(UIControlStateSelected)];
    [wishBt addTarget:self action:@selector(clickWish:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:wishBt];
    self.addWishBt = wishBt;
    
    [wishBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(21);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xeb5937) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = 150;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(wishBt.mas_left).offset(-8);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"lxkfgm"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    
    UIButton *goShopBt = [[UIButton alloc]init];
    goShopBt.backgroundColor = TCUIColorFromRGB(0xeb5937);
    [goShopBt setTitle:[UserDefaultLocationDic valueForKey:@"lxkfgm"] forState:(UIControlStateNormal)];
    [goShopBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    goShopBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    goShopBt.layer.masksToBounds = YES;
    goShopBt.layer.cornerRadius = 10;
    [goShopBt addTarget:self action:@selector(clickGo) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:goShopBt];
    self.goShopBt = goShopBt;
    
    [goShopBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-7);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(size.width + 8);
            make.height.mas_equalTo(20);
    }];
}

-(void)setModel:(MMWishListModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.Name;
    self.desLa.text = _model.Conts;
    self.numLa.text = [NSString stringWithFormat:@"%@%@",_model.InCount,[UserDefaultLocationDic valueForKey:@"jrxyd"]];
    if([_model.Status isEqualToString:@"1"]){
        self.numLa.hidden = YES;
        self.addWishBt.hidden = YES;
        self.goShopBt.hidden = NO;
    }else{
        self.numLa.hidden = NO;
        self.addWishBt.hidden = NO;
        self.goShopBt.hidden = YES;
        if([_model.IsIn isEqualToString:@"1"]){
            self.addWishBt.selected = YES;
        }else{
            self.addWishBt.selected = NO;
        }
    }
}

-(void)clickGo{
    self.goShopBlock(self.model.ID);
}

-(void)clickWish:(UIButton *)sender{
    if(sender.selected){
        
    }else{
        self.addWishBlock(self.model.ID);
    }
}
@end
