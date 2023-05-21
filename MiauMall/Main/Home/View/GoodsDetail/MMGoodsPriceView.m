//
//  MMGoodsPriceView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/5.
//

#import "MMGoodsPriceView.h"

@interface MMGoodsPriceView ()


@end

@implementation MMGoodsPriceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
       
    }
    return self;
}

-(void)setUI{
    UILabel *showSignLa = [UILabel publicLab:self.proInfo.proInfo.PriceShowSign textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    showSignLa.frame = CGRectMake(12, 30, 30, 12);
    [showSignLa sizeToFit];
    [self addSubview:showSignLa];
    
    UILabel *showPriceLa = [UILabel publicLab:self.proInfo.proInfo.PriceShowPrice textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:26 numberOfLines:0];
    showPriceLa.frame = CGRectMake(CGRectGetMaxX(showSignLa.frame) + 5, 18, 80, 23);
    [showPriceLa sizeToFit];
    [self addSubview:showPriceLa];
    NSString *sign = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"discountPrice"],self.proInfo.proInfo.ActivePriceShowSign];
    CGSize size1 = [NSString sizeWithText:sign font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] maxSize:CGSizeMake(MAXFLOAT, 10)];
    CGSize size2 = [NSString sizeWithText:self.proInfo.proInfo.ActivePriceShowPrice font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(MAXFLOAT, 13)];
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(showPriceLa.frame) + 6, 24, size1.width + size2.width + 18, 22)];
    redView.backgroundColor = redColor2;
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = 11;
    [self addSubview:redView];
    
    UILabel *activeSignLa = [UILabel publicLab:sign textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    activeSignLa.frame = CGRectMake(6, 6, size1.width, 10);
    [redView addSubview:activeSignLa];
    
    UILabel *activePriceLa = [UILabel publicLab:self.proInfo.proInfo.ActivePriceShowPrice textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    activePriceLa.frame = CGRectMake(CGRectGetMaxX(activeSignLa.frame) + 3, 4, size2.width, 13);
    [redView addSubview:activePriceLa];
    
    if([self.proInfo.proInfo.DiscountName isEqual:nil] || !self.proInfo.proInfo.DiscountName){
        redView.hidden = YES;
    }
    
}

-(void)setProInfo:(MMGoodsDetailMainModel *)proInfo{
    _proInfo = proInfo;
    [self setUI];
}

@end
