//
//  MMLimitMoreGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/27.
//

#import "MMLimitMoreGoodsCell.h"
@interface MMLimitMoreGoodsCell ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *speedLa;//48小时发货标签
@property (nonatomic, strong) UILabel *activePriceLa;
@property (nonatomic, strong) UILabel *oldPriceLa;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *proLa;//占比lab
@property (nonatomic, strong) UILabel *goLa;
@property (nonatomic, strong) UIProgressView *progress;//进度条
@end

@implementation MMLimitMoreGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xdddddd);
    UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 138)];
    conV.backgroundColor = TCUIColorFromRGB(0xffffff);
    conV.layer.masksToBounds = YES;
    conV.layer.cornerRadius = 7.5;
    [self.contentView addSubview:conV];
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 126, 126)];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 5;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xd2d2d2).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [conV addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UIImageView *discountIcon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 5, 37, 40)];
    discountIcon.image = [UIImage imageNamed:@"discount_bg_icon"];
    discountIcon.hidden = YES;
    [conV addSubview:discountIcon];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 172;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [conV addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(136);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(WIDTH - 172);
    }];
    
    UILabel *speedLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"ship48h"] textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    speedLa.layer.masksToBounds = YES;
    speedLa.layer.cornerRadius = 3;
    speedLa.layer.borderColor = redColor2.CGColor;
    speedLa.layer.borderWidth = 0.5;
    [conV addSubview:speedLa];
    self.speedLa = speedLa;
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"ship48h"] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
    
    [speedLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(136);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
            make.width.mas_equalTo(size.width + 8);
            make.height.mas_equalTo(15);
    }];
    
    UILabel *activeLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    activeLa.preferredMaxLayoutWidth = 120;
    [activeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:activeLa];
    self.activePriceLa = activeLa;
    
    [activeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(136);
            make.bottom.mas_equalTo(-35);
            make.height.mas_equalTo(18);
    }];
    
    UILabel *oldLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x606060) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    oldLa.preferredMaxLayoutWidth = 120;
    [oldLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:oldLa];
    self.oldPriceLa = oldLa;
    
    [oldLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(136);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(11);
    }];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 110, 84, 78, 38)];
    [rightView setBackgroundColor:redColor2];
    rightView.layer.masksToBounds = YES;
    rightView.layer.cornerRadius = 4;
    [conV addSubview:rightView];
    self.rightView = rightView;
    
    UILabel *goLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iClaimed"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    goLa.frame = CGRectMake(0, 6, 78, 13);
    [rightView addSubview:goLa];
    self.goLa = goLa;
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(7, 26, 38, 5)];
//    float value = YiQiang/100.0;
//    progressView.progress = value;
    progressView.trackTintColor = TCUIColorFromRGB(0xfec749);
    progressView.progressTintColor = TCUIColorFromRGB(0xffffff);
    [rightView addSubview:progressView];
    self.progress = progressView;
    
    UILabel *proLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    proLa.frame = CGRectMake(CGRectGetMaxX(progressView.frame) + 5, 24, 24, 10);
    [rightView addSubview:proLa];
    self.proLa = proLa;
}

-(void)setModel:(MMHomeLimitGoodsModel *)model{
    _model = model;
    KweakSelf(self);
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.name;
    CGSize size = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(self.width - 172,14)];
    if(size.height < 18){
        self.nameLa.numberOfLines = 1;
    }else{
        self.nameLa.numberOfLines = 2;
    }
    
    if([_model.tips48 isEmpty]){
        self.speedLa.hidden = YES;
    }
    
    self.activePriceLa.text = _model.priceshow;
    [self.activePriceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(weakself.model.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
        confer.text(weakself.model.pricevalue).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:21]);
    }];
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.oldpriceshow]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.oldPriceLa.attributedText = newPrice;
    

    
    
    if([_model.YiQiang isEqualToString:@"100"]){
        self.rightView.backgroundColor = TCUIColorFromRGB(0xeae9e8);
        self.goLa.text = [UserDefaultLocationDic valueForKey:@"sellOut"];
        self.goLa.textColor = TCUIColorFromRGB(0x4b4b4b);
        self.goLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.goLa.y = 12;
        self.progress.hidden = YES;
        self.proLa.hidden = YES;
    }else{
        float YiQiang = [model.YiQiang floatValue];
        self.progress.progress = YiQiang/100.00;
        self.proLa.text = [NSString stringWithFormat:@"%@%%",_model.YiQiang];
    }
}

-(void)setModel1:(MMHomePageItemModel *)model1{
    _model1 = model1;
    if([_model1.type isEqualToString:@"limit1more"]){
        
    }else if([_model1.type isEqualToString:@"limit8more"]){
       
        self.goLa.y = 12;
        self.progress.hidden = YES;
        self.proLa.hidden = YES;
        
        if([self.type isEqualToString:@"0"]){
            self.goLa.text = [UserDefaultLocationDic valueForKey:@"iClaimed"];
        }else{
            self.goLa.text = [UserDefaultLocationDic valueForKey:@"tobegin"];
            CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"tobegin"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
            self.rightView.frame = CGRectMake(WIDTH - 60 - size.width , 84, size.width + 28, 38);
            self.goLa.frame = CGRectMake(0, 12, size.width + 28, 13);
        }
    }
}

-(void)setType:(NSString *)type{
    _type = type;
    if([_type isEqualToString:@"0"]){
        float YiQiang = [self.model.YiQiang floatValue];
        self.progress.progress = YiQiang/100.00;
        self.proLa.text = [NSString stringWithFormat:@"%@%%",_model.YiQiang];
    }else{
        self.goLa.text = [UserDefaultLocationDic valueForKey:@"tobegin"];
        self.goLa.text = [UserDefaultLocationDic valueForKey:@"tobegin"];
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"tobegin"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        self.rightView.frame = CGRectMake(WIDTH - 60 - size.width , 84, size.width + 28, 38);
        self.goLa.frame = CGRectMake(0, 12, size.width + 28, 13);
        self.progress.hidden = YES;
        self.proLa.hidden = YES;
    }
}

@end
