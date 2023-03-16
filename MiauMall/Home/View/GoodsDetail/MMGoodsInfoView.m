//
//  MMGoodsInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//。商品信息

#import "MMGoodsInfoView.h"
#import "MMFeeInfoModel.h"
#import "MMRotationPicModel.h"

@interface MMGoodsInfoView ()
@property (nonatomic, strong) UILabel *oldPriceLa;//原价
@property (nonatomic, strong) UILabel *priceLa;//现日元价和人民币价格
@property (nonatomic, strong) UILabel *saleLa;//销量
@property (nonatomic, strong) UIView *deliverView;//48小时发货标签
@property (nonatomic, strong) UILabel *midouLa;//多少蜜豆
@property (nonatomic, strong) UILabel *discountLa;//打折标签
@property (nonatomic, strong) UILabel *reserveLa;//预定标签
@property (nonatomic, strong) UILabel *nameLabel;//商品名
@property (nonatomic, strong) UILabel *shortNameLa;//商品简介
@property (nonatomic, strong) UIButton *shareBt;//晒单按钮
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UILabel *limitLa;//限购label
@property (nonatomic, strong) UILabel *addressLa;//发货地址label
@property (nonatomic, strong) UILabel *stoceLa;//库存和发货时间的label
@property (nonatomic, strong) UILabel *tipsLa;//3-7个工作日的提示文本
@property (nonatomic, strong) UIScrollView *rotationScrollView;//滚动图片
@property (nonatomic, strong) NSMutableArray *rotationPicArr;




@end

@implementation MMGoodsInfoView

-(NSMutableArray *)rotationPicArr{
    if(!_rotationPicArr){
        _rotationPicArr = [NSMutableArray array];
    }
    return _rotationPicArr;
}

-(UIView *)deliverView{
    if(!_deliverView){
        _deliverView = [[UIView alloc]init];
        _deliverView.backgroundColor = TCUIColorFromRGB(0xfee6e3);
        _deliverView.layer.masksToBounds = YES;
        _deliverView.layer.cornerRadius = 4;
        
        UIImageView *ligntImage = [[UIImageView alloc]initWithFrame:CGRectMake(4.5, 4, 6, 12)];
        ligntImage.image = [UIImage imageNamed:@"lightning"];
        [_deliverView addSubview:ligntImage];
        
        UILabel *deliverLa = [UILabel publicLab:@"48h发货" textColor:redColor1 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        deliverLa.frame = CGRectMake(13.5, 4, 45, 12);
        [_deliverView addSubview:deliverLa];
    }
    return _deliverView;
}

-(UILabel *)midouLa{
    if(!_midouLa){
        _midouLa = [UILabel publicLab:@"80 蜜豆" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _midouLa.backgroundColor = TCUIColorFromRGB(0xfddbd7);
        _midouLa.layer.masksToBounds = YES;
        _midouLa.layer.cornerRadius = 4;
    }
    return _midouLa;
}

//折扣label
-(UILabel *)discountLa{
    if(!_discountLa){
        _discountLa = [UILabel publicLab:@"" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _discountLa.backgroundColor = TCUIColorFromRGB(0xfddbd7);
        _discountLa.layer.masksToBounds = YES;
        _discountLa.layer.cornerRadius = 4.0;
        _discountLa.layer.borderWidth = 0.5;
        _discountLa.layer.borderColor = redColor1.CGColor;
    }
    return _discountLa;
}

-(UILabel *)oldPriceLa{
    if(!_oldPriceLa){
        _oldPriceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x969696) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        _oldPriceLa.preferredMaxLayoutWidth = WIDTH - 124;
        [_oldPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _oldPriceLa;
}

-(UILabel *)priceLa{
    if(!_priceLa){
        _priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x969696) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        _priceLa.preferredMaxLayoutWidth = WIDTH - 124;
        [_priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _priceLa;
}

-(UILabel *)saleLa{
    if(!_saleLa){
        _saleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x5a5a5a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _saleLa.preferredMaxLayoutWidth = 100;
        [_saleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _saleLa;
}

//商品名
-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        _nameLabel.preferredMaxLayoutWidth = self.width - 24;
        [_nameLabel setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
       //[_nameLabel.setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _nameLabel;
}

//简介
-(UILabel *)shortNameLa{
    if(!_shortNameLa){
        _shortNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x969696) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        _nameLabel.preferredMaxLayoutWidth = self.width - 38;
        [_nameLabel setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _shortNameLa;
}

-(UIScrollView *)rotationScrollView{
    if(!_rotationScrollView){
        _rotationScrollView = [[UIScrollView alloc]init];
        _rotationScrollView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        _rotationScrollView.showsVerticalScrollIndicator = NO;
        _rotationScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _rotationScrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    KweakSelf(self);
//    self.deliverView.frame = CGRectMake(12, 14, 60, 23);
//    [self addSubview:self.deliverView];
    
    [self addSubview:self.oldPriceLa];
    [self.oldPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(10);
    }];
    
    [self addSubview:self.priceLa];
    [self.priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(weakself.oldPriceLa.mas_bottom).offset(6);
            make.height.mas_equalTo(12);
    }];
    
    [self addSubview:self.saleLa];
    [self.saleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(13);
    }];
    
    self.midouLa.frame = CGRectMake(12, 58, 60, 23);
    [self addSubview:self.midouLa];
    
    self.discountLa.frame = CGRectMake(CGRectGetMaxX(self.midouLa.frame) + 12, 58, 50, 23);
    [self addSubview:self.discountLa];
    
    UILabel *lab1 = [UILabel publicLab:@"优惠" textColor:redColor1 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab1.frame = CGRectMake(self.width - 55, 63, 30, 12);
    [self addSubview:lab1];
    
    UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 24, 63, 12, 12)];
    icon1.image = [UIImage imageNamed:@"right_icon_red"];
    [self addSubview:icon1];
    
    UIButton *discountBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 58, self.width, 23)];
    [discountBt setBackgroundColor:UIColor.clearColor];
    [discountBt addTarget:self action:@selector(clickDiscount) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:discountBt];
 
    UILabel *reserveLa = [UILabel publicLab:@"预定" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    reserveLa.backgroundColor = redColor2;
    reserveLa.layer.masksToBounds = YES;
    reserveLa.layer.cornerRadius = 2.5;
    reserveLa.frame = CGRectMake(12, CGRectGetMaxY(self.discountLa.frame) + 12, 32, 20);
    [self addSubview:reserveLa];
    self.reserveLa = reserveLa;
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(CGRectGetMaxY(weakself.discountLa.frame) + 12);
            make.width.mas_equalTo(weakself.width - 24);
//            make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.shortNameLa];
    [self.shortNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(weakself.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
    NSString *tips = @"为保证产品最新鲜的生产日期，此商品未做过多库存积压。在您下单此商品后，MiauMall会在第一时间与厂家下单订货，预计约3-7工作日到货，感谢理解!";
    UILabel *tipsLa = [UILabel publicLab:tips textColor:TCUIColorFromRGB(0xd7301b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    tipsLa.preferredMaxLayoutWidth = WIDTH - 44;
    [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
   [self addSubview:tipsLa];
    self.tipsLa = tipsLa;
    
    [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(10);
            make.width.mas_equalTo(WIDTH - 44);
    }];
    
//    UIImageView *icon2 = [[UIImageView alloc]init];
//    icon2.image = [UIImage imageNamed:@"down_black"];
//    [self addSubview:icon2];
//
//    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakself.shortNameLa.mas_right).offset(6);
//            make.top.mas_equalTo(weakself.nameLabel.mas_bottom).offset(15);
//            make.width.mas_equalTo(8);
//            make.height.mas_equalTo(4);
//    }];
    
    self.rotationScrollView.layer.masksToBounds = YES;
    self.rotationScrollView.layer.cornerRadius = 7.5;
    [self addSubview:self.rotationScrollView];
    
    [self.rotationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(tipsLa.mas_bottom).offset(10);
            make.width.mas_equalTo(weakself.width - 20);
            make.height.mas_equalTo(50);
    }];
//    [self addSubview:self.shareBt];
//    [self.shareBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(10);
//            make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(10);
//            make.width.mas_equalTo(weakself.width - 20);
//            make.height.mas_equalTo(30);
//    }];
    
    UILabel *lab2 = [UILabel publicLab:@"选择" textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    [self addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *specLa = [UILabel publicLab:@"x1件" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:13 numberOfLines:0];
    specLa.preferredMaxLayoutWidth = 280;
    [specLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:specLa];
    
    [specLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.height.mas_equalTo(13);
    }];
    self.specLa = specLa;
    
    UILabel *limitLa = [UILabel publicLab:@"每个ID限购1件" textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    limitLa.preferredMaxLayoutWidth = 200;
    [limitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:limitLa];
    self.limitLa = limitLa;
    
    [limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(specLa.mas_right).offset(8);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(24);
//            make.width.mas_equalTo(76);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *stockLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x272727) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    stockLa.preferredMaxLayoutWidth = WIDTH - 104;
    [stockLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:stockLa];
    self.stoceLa = stockLa;
    
    [stockLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(64);
            make.top.mas_equalTo(specLa.mas_bottom).offset(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(13);
    }];
    
    UIImageView *icon3 = [[UIImageView alloc]init];
    icon3.image = [UIImage imageNamed:@"right_icon_black"];
    [self addSubview:icon3];
    
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(28);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = TCUIColorFromRGB(0xeef0f1);
    [self addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(stockLa.mas_bottom).offset(12);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(0.5);
    }];
    
    UIButton *selectBt = [[UIButton alloc]init];
    [selectBt setBackgroundColor:UIColor.clearColor];
    [selectBt addTarget:self action:@selector(selectSpec) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:selectBt];

    [selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *lab3 = [UILabel publicLab:@"发货" textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    [self addSubview:lab3];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(line1.mas_bottom).offset(17);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *areaLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:13 numberOfLines:0];
    areaLa.preferredMaxLayoutWidth = self.width - 77;
    [areaLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:areaLa];
    
    [areaLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.top.mas_equalTo(line1.mas_bottom).offset(17);
            make.height.mas_equalTo(13);
    }];
    self.addressLa = areaLa;
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = TCUIColorFromRGB(0xeef0f1);
    [self addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(areaLa.mas_bottom).offset(15);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(0.5);
    }];
    
    NSArray *arr = @[@"日本直邮",@"100%正品",@"假一赔十",@"包税"];
    CGFloat wid = 0;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        CGSize size1 = [arr[i] sizeWithAttributes:attrs1];
        UIView *view = [[UIView alloc]init];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12 + 20 * i + wid);
                    make.top.mas_equalTo(line2.mas_bottom).offset(17);
                    make.width.mas_equalTo(size1.width + 14);
                    make.height.mas_equalTo(12);
        }];
        wid = wid + (14 + size1.width);
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"select_icon_black"];
        [view addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(1);
                    make.width.height.mas_equalTo(10);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(icon.mas_right).offset(4);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(size1.width);
                    make.height.mas_equalTo(12);
        }];
    }
    
    UIImageView *icon4 = [[UIImageView alloc]init];
    icon4.image = [UIImage imageNamed:@"right_icon_black"];
    [self addSubview:icon4];
    
    [icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(line2.mas_bottom).offset(20);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIImageView *icon5 = [[UIImageView alloc]init];
    icon5.image = [UIImage imageNamed:@"select_icon_black"];
    [self addSubview:icon5];
    
    [icon5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(line2.mas_bottom).offset(40);
            make.width.height.mas_equalTo(10);
    }];
    
    UILabel *lab4 = [UILabel publicLab:@"不支持无理由退换货" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    [self addSubview:lab4];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon5.mas_right).offset(4);
            make.top.mas_equalTo(line2.mas_bottom).offset(39);
            make.width.mas_equalTo(108);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *equityBt = [[UIButton alloc]init];
    [equityBt setBackgroundColor:UIColor.clearColor];
    [equityBt addTarget:self action:@selector(clickEquity) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:equityBt];
    
    [equityBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(line2.mas_bottom).offset(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
    }];
    
}


-(void)setProInfo:(MMGoodsDetailMainModel *)proInfo{
    KweakSelf(self);
    _proInfo = proInfo;
    self.nameLabel.text = _proInfo.proInfo.Name;
    float mido = [_proInfo.proInfo.Price floatValue]/100;
    NSInteger mido1 = [_proInfo.proInfo.Price integerValue]/100;
    float sub = mido - mido1;
    if(sub > 0){
        self.midouLa.text = [NSString stringWithFormat:@"%ld蜜豆",mido1 + 1];
    }else{
        self.midouLa.text = [NSString stringWithFormat:@"%.f蜜豆",mido];
    }
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_proInfo.proInfo.OldPriceShow]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.oldPriceLa.attributedText = newPrice;
    float rmb = [_proInfo.proInfo.PriceRMB floatValue];
    self.priceLa.text = [NSString stringWithFormat:@"JPY%@(约RMB%.2f)",_proInfo.proInfo.Price,rmb];
    self.saleLa.text = [NSString stringWithFormat:@"销量%@",_proInfo.proInfo.Sales];
   
    self.shortNameLa.text = _proInfo.proInfo.ShortName;
    
    if(!_proInfo.proInfo.DiscountName){
        self.discountLa.hidden = YES;
    }else{
        self.discountLa.text = _proInfo.proInfo.DiscountName;
    }
    
    NSInteger realnum = [_proInfo.proInfo.RealNumber integerValue];
    
    if(realnum > 0){
        self.stoceLa.text = [NSString stringWithFormat:@"库存%@件，预计48h内发货",_proInfo.proInfo.RealNumber];
        [self.stoceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"库存%@件，预计",self->_proInfo.proInfo.RealNumber]).textColor(TCUIColorFromRGB(0x272727));
            confer.text(@"48h").textColor(redColor2);
            confer.text(@"内发货").textColor(TCUIColorFromRGB(0x272727));
        }];
        self.tipsLa.hidden = YES;
        [self.rotationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(10);
        }];
        self.reserveLa.hidden = YES;
        self.nameLabel.text = _proInfo.proInfo.Name;
    }else{
        self.tipsLa.hidden = NO;
        
        self.nameLabel.text = [NSString stringWithFormat:@"     %@",_proInfo.proInfo.Name];
        self.stoceLa.text = [NSString stringWithFormat:@"库存不足，需向品牌方预定，约3-7工作日发货"];
        self.stoceLa.textColor = TCUIColorFromRGB(0xd7301b);
    }
   
    if(_proInfo.yunfei.count > 0){
        NSDictionary *dic = _proInfo.yunfei[0];
        MMFeeInfoModel *model = [MMFeeInfoModel mj_objectWithKeyValues:dic];
        self.addressLa.text = model.MoneyAll;
    }
   
}

-(void)setRotationArr:(NSArray *)rotationArr{
    _rotationArr = rotationArr;
    NSArray *rotationPicArr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:_rotationArr];
    self.rotationPicArr = [NSMutableArray arrayWithArray:rotationPicArr];
    self.rotationScrollView.contentSize = CGSizeMake(WIDTH *_rotationArr.count, 50);
    for (int i = 0; i <rotationPicArr.count; i++) {
        MMRotationPicModel *model = rotationArr[i];
        UIButton *shareBt = [[UIButton alloc]initWithFrame:CGRectMake(self.width * i, 0, self.width, 50)];
        shareBt.backgroundColor = TCUIColorFromRGB(0x707070);
        shareBt.tag = 100+ i;
        [shareBt sd_setImageWithURL:[NSURL URLWithString:model.Picture] forState:(UIControlStateNormal)];
        [shareBt addTarget:self action:@selector(clickShare:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.rotationScrollView addSubview:shareBt];
    }
}

-(void)setShowStr:(NSString *)showStr{
    _showStr = showStr;
    self.specLa.text = _showStr;
}
-(void)setLimitNum:(NSString *)limitNum{
    _limitNum = limitNum;
    if([_limitNum isEqualToString:@"0"]){
        self.limitLa.hidden = YES;
    }else{
        self.limitLa.text = [NSString stringWithFormat:@"每个ID限购%@件",_limitNum];
    }
   
}


#pragma mark -- 点击按钮回调
-(void)clickDiscount{
    self.discountTapBlock(@"1");
}

-(void)clickShare:(UIButton *)sender{
    MMRotationPicModel *model = self.rotationPicArr[sender.tag - 100];
    self.shareTapBlock(model.LinkUrl);
}

-(void)selectSpec{
    self.selectTapBlock(@"1");
}

-(void)clickEquity{
    self.equityTapBlock(@"1");
}

@end
