//
//  MMMyCollectionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import "MMMyCollectionCell.h"

@interface MMMyCollectionCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UIButton *carBt;

@property (nonatomic, strong) UIView *bgView;
@end

@implementation MMMyCollectionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    UIButton *selectBt = [[UIButton alloc]initWithFrame:CGRectMake(8.5, 46, 18, 18)];
    [selectBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [selectBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    selectBt.selected = NO;
    [selectBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:selectBt];
    self.selectBt = selectBt;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 110)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 110, 110)];
    goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 10;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xe5e5e5).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [self.bgView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 162;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.bgView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(132);
            make.top.mas_equalTo(3);
            make.width.mas_equalTo(WIDTH - 162);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = WIDTH - 184;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.bgView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(132);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(WIDTH - 184);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 52, 86, 20, 17)];
    [btn setImage:[UIImage imageNamed:@"goodsCar"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
  
}


-(void)setModel:(MMCollectionModel *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = [NSString stringWithFormat:@"%@",_model.Name];
    self.priceLa.text = _model.PriceShow;
    
}

-(void)setModel1:(MMFootOrCollectGoodsModel *)model1{
    _model1 = model1;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model1.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = [NSString stringWithFormat:@"%@",_model1.Name];
    self.priceLa.text = _model1.PriceShow;
}

-(void)setIsselect:(NSString *)isselect{
    _isselect = isselect;
    if([_isselect isEqualToString:@"1"]){
        self.bgView.x = self.bgView.x + 26;
    }else{
        self.contentView.x = 0;
    }
}

-(void)clickBt:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(self.model){
        if(sender.selected){
            self.addSelectBlock(self.model.ID);
        }else{
            self.deleteSelectBlock(self.model.ID);
        }
    }else{
        if(sender.selected){
            self.addSelectBlock(self.model1.RecID);
        }else{
            self.deleteSelectBlock(self.model1.RecID);
        }
    }
    
}

-(void)clickCar{
    if(self.model){
        self.tapCarBlock(self.model.ID);
    }else{
        self.tapCarBlock(self.model1.ID);
    }
    
}
@end
