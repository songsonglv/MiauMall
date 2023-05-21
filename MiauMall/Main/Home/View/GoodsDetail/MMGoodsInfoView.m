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
@property (nonatomic, strong) UILabel *priceCutLa;//直降标签
@property (nonatomic, strong) UILabel *optionlLa;//任选标签

@property (nonatomic, strong) UIView *ysView;//预售view模块
@property (nonatomic, strong) UILabel *lab1;//付定金
@property (nonatomic, strong) UILabel *lab2;//付尾款
@property (nonatomic, strong) UILabel *endTimeLa;//截止时间
@property (nonatomic, strong) UILabel *startTimeLa;//开始时间
@property (nonatomic, strong) UIView *line01;
@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, strong) UILabel *reserveLa;//预定标签
@property (nonatomic, strong) UILabel *nameLabel;//商品名
@property (nonatomic, strong) UILabel *shortNameLa;//商品简介
@property (nonatomic, strong) UIButton *shareBt;//晒单按钮
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UILabel *yhLa;
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

-(UIView *)ysView{
    if(!_ysView){
        _ysView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.discountLa.frame) + 12, WIDTH - 44, 54)];
        [self setView:_ysView andCorlors:@[TCUIColorFromRGB(0xff7633),TCUIColorFromRGB(0xe1391a)]];
        _ysView.layer.masksToBounds = YES;
        _ysView.layer.cornerRadius = 7.5;
        UILabel *lab01 = [UILabel publicLab:[NSString stringWithFormat:@"1.%@",[UserDefaultLocationDic valueForKey:@"payDeposit"]] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab01.preferredMaxLayoutWidth = 100;
        [lab01 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:lab01];
//        self.lab1 = lab01;

        [lab01 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(12);
                make.height.mas_equalTo(13);
        }];
//    //
        UIView *line01 = [[UIView alloc]init];
        line01.backgroundColor = TCUIColorFromRGB(0xffffff);
        [_ysView addSubview:line01];
//        self.line01 = line01;

        [line01 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lab01.mas_right).offset(12);
                make.top.mas_equalTo(16);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(0.5);
        }];
//    //
        UILabel *lab02 = [UILabel publicLab:[NSString stringWithFormat:@"2.%@",[UserDefaultLocationDic valueForKey:@"payBalance"]] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab02.preferredMaxLayoutWidth = 150;
        [lab02 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:lab02];

//        self.lab2 = lab02;

        [lab02 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(line01.mas_right).offset(12);
                make.top.mas_equalTo(12);
                make.height.mas_equalTo(13);
        }];
//    //
        UILabel *ksLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        ksLa.preferredMaxLayoutWidth = 150;
        [ksLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:ksLa];

        self.startTimeLa = ksLa;

        [ksLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lab02.mas_left);
                make.top.mas_equalTo(lab02.mas_bottom).offset(8);
                make.height.mas_equalTo(12);
        }];
    //
        UILabel *jsLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        jsLa.preferredMaxLayoutWidth = 150;
        [jsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:jsLa];

        self.endTimeLa = jsLa;

        [jsLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lab01.mas_left);
                make.top.mas_equalTo(lab01.mas_bottom).offset(8);
                make.height.mas_equalTo(12);
        }];
    }
    return _ysView;
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
        _midouLa.layer.borderWidth = 0.5;
        _midouLa.layer.borderColor = redColor1.CGColor;
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

//直降
-(UILabel *)priceCutLa{
    if(!_priceCutLa){
        _priceCutLa = [UILabel publicLab:@"" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _priceCutLa.backgroundColor = TCUIColorFromRGB(0xfddbd7);
        _priceCutLa.layer.masksToBounds = YES;
        _priceCutLa.layer.cornerRadius = 4.0;
        _priceCutLa.layer.borderWidth = 0.5;
        _priceCutLa.layer.borderColor = redColor1.CGColor;
    }
    return _priceCutLa;
}

//任选
-(UILabel *)optionlLa{
    if(!_optionlLa){
        _optionlLa = [UILabel publicLab:@"" textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        _optionlLa.backgroundColor = TCUIColorFromRGB(0xfddbd7);
        _optionlLa.layer.masksToBounds = YES;
        _optionlLa.layer.cornerRadius = 4.0;
        _optionlLa.layer.borderWidth = 0.5;
        _optionlLa.layer.borderColor = redColor1.CGColor;
    }
    return _optionlLa;
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
//        _nameLabel.preferredMaxLayoutWidth = WIDTH - 44;
//        [_nameLabel setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
       //[_nameLabel.setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _nameLabel;
}

//简介
-(UILabel *)shortNameLa{
    if(!_shortNameLa){
        _shortNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x969696) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        _nameLabel.preferredMaxLayoutWidth = WIDTH - 38;
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
    
    self.discountLa.frame = CGRectMake(CGRectGetMaxX(self.midouLa.frame) + 12, 58, 0, 23);
    [self addSubview:self.discountLa];
    
    self.priceCutLa.frame = CGRectMake(CGRectGetMaxX(self.discountLa.frame) + 12, 58, 0, 23);
    [self addSubview:self.priceCutLa];
    
    self.optionlLa.frame = CGRectMake(CGRectGetMaxX(self.priceCutLa.frame) + 12, 58, 0, 23);
    [self addSubview:self.optionlLa];
    
    CGSize size0 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"idiscount1"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"idiscount1"] textColor:redColor1 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab1.frame = CGRectMake(self.width - size0.width - 27, 63, size0.width, 12);
    [self addSubview:lab1];
    self.yhLa = lab1;
    
    UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 24, 63, 12, 12)];
    icon1.image = [UIImage imageNamed:@"right_icon_red"];
    [self addSubview:icon1];
    
    UIButton *discountBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 58, self.width, 23)];
    [discountBt setBackgroundColor:UIColor.clearColor];
    [discountBt addTarget:self action:@selector(clickDiscount) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:discountBt];
    
    
    
    
    UIView *bottomV = [[UIView alloc]init];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self addSubview:bottomV];
    self.bottomV = bottomV;
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(CGRectGetMaxY(self.discountLa.frame));
            make.width.mas_equalTo(WIDTH - 20);
            make.bottom.mas_equalTo(0);
    }];
 
    UILabel *reserveLa = [UILabel publicLab:@"预定" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    reserveLa.backgroundColor = redColor2;
    reserveLa.layer.masksToBounds = YES;
    reserveLa.layer.cornerRadius = 2.5;
    reserveLa.frame = CGRectMake(12, 12, 32, 20);
    [bottomV addSubview:reserveLa];
    self.reserveLa = reserveLa;
    
    [bottomV addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(WIDTH - 44);
            make.height.mas_equalTo(20);
    }];
    
    [bottomV addSubview:self.shortNameLa];
    [self.shortNameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(weakself.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
//    NSString *tips = @"为保证产品最新鲜的生产日期，此商品未做过多库存积压。在您下单此商品后，MiauMall会在第一时间与厂家下单订货，预计约3-7工作日到货，感谢理解!";
    UILabel *tipsLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xd7301b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
//    tipsLa.preferredMaxLayoutWidth = WIDTH - 44;
//    [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
   [bottomV addSubview:tipsLa];
    self.tipsLa = tipsLa;
    
    [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(10);
        make.width.mas_equalTo(WIDTH - 44);
        make.height.mas_equalTo(13);
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
    [bottomV addSubview:self.rotationScrollView];
    
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
    
    UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iselect"] textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = 65;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:lab2];
//    self.lab2 = lab2;
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *specLa = [UILabel publicLab:[NSString stringWithFormat:@"x1%@",[UserDefaultLocationDic valueForKey:@"ipieces"]] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:13 numberOfLines:0];
    specLa.preferredMaxLayoutWidth = 280;
    [specLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:specLa];
    
    [specLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.height.mas_equalTo(13);
    }];
    self.specLa = specLa;
    
    UILabel *limitLa = [UILabel publicLab:@"每个ID限购1件" textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    limitLa.preferredMaxLayoutWidth = 200;
    [limitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:limitLa];
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
    [bottomV addSubview:stockLa];
    self.stoceLa = stockLa;
    
    [stockLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(64);
            make.top.mas_equalTo(specLa.mas_bottom).offset(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(13);
    }];
    
    UIImageView *icon3 = [[UIImageView alloc]init];
    icon3.image = [UIImage imageNamed:@"right_icon_black"];
    [bottomV addSubview:icon3];
    
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(28);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = TCUIColorFromRGB(0xeef0f1);
    [bottomV addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(stockLa.mas_bottom).offset(12);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(0.5);
    }];
    
    UIButton *selectBt = [[UIButton alloc]init];
    [selectBt setBackgroundColor:UIColor.clearColor];
    [selectBt addTarget:self action:@selector(selectSpec) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:selectBt];
   

    [selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(weakself.rotationScrollView.mas_bottom).offset(25);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"shippingin2"] textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab3.preferredMaxLayoutWidth = 65;
    [lab3 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:lab3];
    
//    self.lab1 = lab3;
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(line1.mas_bottom).offset(17);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *areaLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:13 numberOfLines:0];
    areaLa.preferredMaxLayoutWidth = self.width - 77;
    [areaLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bottomV addSubview:areaLa];
    
    [areaLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.top.mas_equalTo(line1.mas_bottom).offset(17);
            make.height.mas_equalTo(13);
    }];
    self.addressLa = areaLa;
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = TCUIColorFromRGB(0xeef0f1);
    [bottomV addSubview:line2];
    
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(areaLa.mas_bottom).offset(15);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(0.5);
    }];
    
//    [self layoutIfNeeded];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"directMail"],[UserDefaultLocationDic valueForKey:@"guarante"],[UserDefaultLocationDic valueForKey:@"falsePays"],[UserDefaultLocationDic valueForKey:@"taxInclusive"],[UserDefaultLocationDic valueForKey:@"bzcwlythh"]];
    CGFloat wid = 12;
    NSInteger z = 0;
    NSInteger j = 0;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        CGSize size1 = [arr[i] sizeWithAttributes:attrs1];
        UIView *view = [[UIView alloc]init];
        [bottomV addSubview:view];
        
        if((wid + size1.width + 14) > (WIDTH - 45)){
            z += 1;
            wid = 12;
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(wid);
                    make.top.mas_equalTo(line2.mas_bottom).offset(12 + z * 20);
                    make.width.mas_equalTo(size1.width + 14);
                    make.height.mas_equalTo(12);
        }];
        
        
        
        
        wid = wid + (14 + size1.width) + 12;
       
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"select_icon_black"];
        [view addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(1);
                    make.width.height.mas_equalTo(10);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
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
    [bottomV addSubview:icon4];
    
    [icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(line2.mas_bottom).offset(20);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIButton *equityBt = [[UIButton alloc]init];
    [equityBt setBackgroundColor:UIColor.clearColor];
    [equityBt addTarget:self action:@selector(clickEquity) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:equityBt];
    
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
    
    float mido = [_proInfo.proInfo.Price floatValue]/100;
    NSInteger mido1 = [_proInfo.proInfo.Price integerValue]/100;
    float sub = mido - mido1;
    
    if(sub > 0){
        self.midouLa.text = [NSString stringWithFormat:@"%ld%@",mido1 + 1,[UserDefaultLocationDic valueForKey:@"midou"]];
    }else{
        self.midouLa.text = [NSString stringWithFormat:@"%.f%@",mido,[UserDefaultLocationDic valueForKey:@"midou"]];
    }
    
    UIColor *col = [_proInfo.proInfo.cid isEqualToString:@"828"] ? TCUIColorFromRGB(0x333333) : redColor2;
    self.reserveLa.text = _proInfo.proInfo.ProductSign;
    self.reserveLa.backgroundColor = col;
    
    CGSize size0 = [NSString sizeWithText:self.midouLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,13)];
    self.midouLa.width = size0.width + 16;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_proInfo.proInfo.OldPriceShow]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.oldPriceLa.attributedText = newPrice;
    float rmb = [_proInfo.proInfo.PriceRMB floatValue];
    float price = [_proInfo.proInfo.Price floatValue];
    self.priceLa.text = [NSString stringWithFormat:@"JPY%.2f(%@RMB%.2f)",price,[UserDefaultLocationDic valueForKey:@"iabout"],rmb];
    self.saleLa.text = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"salesVolume"],_proInfo.proInfo.Sales];
    
    if(_proInfo.proInfo.DiscountName == nil){
        self.discountLa.hidden = YES;
        self.discountLa.width = 0;
        self.priceCutLa.x = CGRectGetMaxX(self.midouLa.frame) + 12;
    }else{
        CGSize size00 = [NSString sizeWithText:_proInfo.proInfo.DiscountName font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        self.discountLa.text = _proInfo.proInfo.DiscountName;
        self.discountLa.x = CGRectGetMaxX(self.midouLa.frame) + 12;
        self.discountLa.width = size00.width + 16;
    }
    
    if(_proInfo.proInfo.PriceCutName == nil || [_proInfo.proInfo.PriceCutName isEmpty] || [_proInfo.proInfo.PriceCutName isEqualToString:@""]){
        self.priceCutLa.width = 0;
        self.priceCutLa.hidden = YES;
        self.optionlLa.x = CGRectGetMaxX(self.discountLa.frame) + 12;
    }else{
        CGSize size00 = [NSString sizeWithText:_proInfo.proInfo.PriceCutName font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        self.priceCutLa.text = _proInfo.proInfo.PriceCutName;
        self.priceCutLa.width = size00.width + 16;
        self.priceCutLa.x = CGRectGetMaxX(self.discountLa.frame) + 12;
        
        if(_proInfo.proInfo.DiscountName == nil){
            self.priceCutLa.x = CGRectGetMaxX(self.midouLa.frame) + 12;
        }
    }
    

    
    if([_proInfo.proInfo.cid isEqualToString:@"794"]){
        [self addSubview:self.ysView];

        [self.bottomV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(CGRectGetMaxY(weakself.ysView.frame));
        }];
        
        NSString *str1 = [self setString:_proInfo.proInfo.DepositEndTime andFormat:@"MM-dd HH:mm"];
        
        self.endTimeLa.text = [NSString stringWithFormat:@"%@%@",str1,[UserDefaultLocationDic valueForKey:@"iEnd"]];
        self.startTimeLa.text = [NSString stringWithFormat:@"%@%@",[self setString:_proInfo.proInfo.DepositStartTime andFormat:@"MM-dd HH:mm"],[UserDefaultLocationDic valueForKey:@"iStart"]];

    }
    
    if(_proInfo.proInfo.ProductSign){
        self.reserveLa.hidden = NO;
    }else{
        self.reserveLa.hidden = YES;
    }
    CGSize size1 = [NSString sizeWithText:self.reserveLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    self.reserveLa.width = size1.width + 8;
    
//    self.nameLabel.text = _proInfo.proInfo.Name;
    
    

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size1.width + 8;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_proInfo.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
    self.nameLabel.attributedText = attrText;
    
    
    CGFloat hei = [self textViewHeightForAttributedString:attrText withWidth:WIDTH - 44];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(WIDTH - 44);
            make.height.mas_equalTo(hei);
    }];
    
    if(_proInfo.proInfo.ShortName.length > 6){
        self.shortNameLa.text = _proInfo.proInfo.ShortName;
    }else{
        [self.tipsLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakself.nameLabel.mas_bottom).offset(10);
        }];
    }
  
    NSInteger realnum = [_proInfo.proInfo.RealNumber integerValue];
    
    if(realnum > 0){
        if(realnum >= 10){
            self.stoceLa.text = [NSString stringWithFormat:@"%@,%@",[UserDefaultLocationDic valueForKey:@"inStock"],_proInfo.proInfo.ProductSignTimeStr];
        }else{
            self.stoceLa.text = [NSString stringWithFormat:@"%@%@%@,%@",[UserDefaultLocationDic valueForKey:@"istock"],_proInfo.proInfo.RealNumber,[UserDefaultLocationDic valueForKey:@"ipiece"],_proInfo.proInfo.ProductSignTimeStr];
        }
        
    }else{
        self.stoceLa.text = [NSString stringWithFormat:@"%@",_proInfo.proInfo.ProductSignTimeStr];
    }
    
    
    if([_proInfo.proInfo.cid isEqualToString:@"828"]){
        [self.tipsLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [self.rotationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(0);
        }];
    }else{
        if([_proInfo.proInfo.IsCanReturn isEqualToString:@"0"] == YES && _proInfo.proInfo.Precautions.length > 6){
            NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
            NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_proInfo.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
            self.tipsLa.attributedText = attrText1;
            CGFloat hei1 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
           
            [self.tipsLa mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(hei1);
            }];
            
            [self.rotationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakself.tipsLa.mas_bottom).offset(10);
            }];
        }else{
            [self.tipsLa mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            
            [self.rotationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakself.shortNameLa.mas_bottom).offset(10);
            }];
        }
    }
    
    if(_proInfo.yunfei.count > 0){
        NSDictionary *dic = _proInfo.yunfei[0];
        MMFeeInfoModel *model = [MMFeeInfoModel mj_objectWithKeyValues:dic];
        self.addressLa.text = [NSString stringWithFormat:@"%@ (%@)",[UserDefaultLocationDic valueForKey:@"ijapan"],model.MoneyAll];
    }
   
}

-(void)setMoreModel:(MMGoodsProInfoModel *)moreModel{
    _moreModel = moreModel;
        if(_moreModel.OptionalName == nil){
            self.optionlLa.width = 0;
            self.optionlLa.hidden = YES;
        }else{
            CGSize size00 = [NSString sizeWithText:_moreModel.OptionalName font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
            self.optionlLa.text = _moreModel.OptionalName;
            self.optionlLa.width = size00.width + 16;
            self.optionlLa.x = CGRectGetMaxX(self.priceCutLa.frame) + 12;
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

-(void)setStockStr:(NSString *)stockStr{
    _stockStr = stockStr;
    self.stoceLa.text = _stockStr;
}
-(void)setLimitNum:(NSString *)limitNum{
    _limitNum = limitNum;
    if([_limitNum isEqualToString:@"0"]){
        self.limitLa.hidden = YES;
    }else{
        self.limitLa.text = [NSString stringWithFormat:@"每个ID限购%@%@",_limitNum,[UserDefaultLocationDic valueForKey:@"ipiece"]];
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

- (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width
{
    return [self rectForAttributedString:string withSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGSize)rectForAttributedString:(NSAttributedString *)string withSize:(CGSize)theSize
{
    if (!string || CGSizeEqualToSize(theSize, CGSizeZero)) {
        return CGSizeZero;
    }

    // setup TextKit stack
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:theSize];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    // query for size
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];

    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,0);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}

//时间格式转换
-(NSString *)setString:(NSString *)timeStr andFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *dateTime = [formatter dateFromString:timeStr];
    
    NSString *timeStr1 = [self dateAsString:dateTime];
    
    
  return timeStr1;
}

-(NSString*)dateAsString:(NSDate*)date {
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString * timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
