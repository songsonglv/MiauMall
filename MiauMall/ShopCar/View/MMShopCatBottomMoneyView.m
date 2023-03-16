//
//  MMShopCatBottomMoneyView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import "MMShopCatBottomMoneyView.h"

@interface MMShopCatBottomMoneyView ()
@property (nonatomic, strong) UIButton *seleBt;
@property (nonatomic, strong) UILabel *allSeleLa;
@property (nonatomic, strong) UILabel *allMoneyLa;
@property (nonatomic, strong) UILabel *discountLa;
@property (nonatomic, strong) UIButton *payBt;
@property (nonatomic, strong) UIButton *detailBt;
@end

@implementation MMShopCatBottomMoneyView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUI];
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return self;
}


-(void)setUI{
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 14, 16, 16)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clickSele:) forControlEvents:(UIControlEventTouchUpInside)];
    seleBt.selected = NO;
    [self addSubview:seleBt];
    self.seleBt = seleBt;
    
    UILabel *allSeleLa = [UILabel publicLab:@"全选" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    CGSize size = [NSString sizeWithText:allSeleLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(WIDTH - 24,MAXFLOAT)];
    allSeleLa.frame = CGRectMake(31, 16, size.width + 4, 14);
    [self addSubview:allSeleLa];
    self.allSeleLa = allSeleLa;
    
    UILabel *allMoneyLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    allMoneyLa.preferredMaxLayoutWidth = 200;
    [allMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:allMoneyLa];
    self.allMoneyLa = allMoneyLa;
    
    [allMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CGRectGetMaxX(allSeleLa.frame) + 12);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *discountLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    discountLa.preferredMaxLayoutWidth = 200;
    [discountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:discountLa];
    self.discountLa = discountLa;
    
    [discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(72);
            make.top.mas_equalTo(allMoneyLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size1 = [NSString sizeWithText:@"优惠明细" font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(72, 40, size1.width + 18, 12)];
    [btn setTitle:@"优惠明细" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"down_black"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    [btn addTarget:self action:@selector(clickDetail) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    self.detailBt = btn;
    
    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 105, 15, 100, 36)];
    [payBt setBackgroundColor:redColor2];
    [payBt setTitle:@"结算" forState:(UIControlStateNormal)];
    [payBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
    payBt.layer.masksToBounds = YES;
    payBt.layer.cornerRadius = 18;
    [payBt addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:payBt];
    self.payBt = payBt;
}

-(void)setModel:(MMShopCarModel *)model{
    _model = model;
    KweakSelf(self);
    if([_model.num isEqual:_model.Num1]){
        self.seleBt.selected = YES;
    }else{
        self.seleBt.selected = NO;
    }
//    self.allMoneyLa.text = [NSString stringWithFormat:@"合计：%@",_model._totalshow];
    float activePrice = [_model._totalactiveprice floatValue];
    NSArray *temp = [[NSArray alloc]init];
    if(activePrice > 0){
        temp = [_model._totalactivepriceshow componentsSeparatedByString:@" "];
    }else{
        temp=[_model._totalshow componentsSeparatedByString:@" "];
    }
    
    NSString *str = temp[0];
    NSString *str1 = temp[1];
    [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"合计：%@",str]).textColor(redColor2).font([UIFont systemFontOfSize:12]);
        confer.text(str1).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
    }];
    
    self.discountLa.text = [NSString stringWithFormat:@"共优惠%@",_model._discounttotalsalesshow];
    CGSize size = [NSString sizeWithText:self.discountLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    CGSize size1 = [NSString sizeWithText:@"优惠明细" font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    [self.detailBt setTitle:@"优惠明细" forState:(UIControlStateNormal)];
    [self.detailBt setImage:[UIImage imageNamed:@"down_black"] forState:(UIControlStateNormal)];
    [self.detailBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    if(72 + size.width + size1.width + 136 > WIDTH){
        [self.allMoneyLa mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(CGRectGetMaxX(weakself.allSeleLa.frame) + 12);
                make.top.mas_equalTo(7);
                make.height.mas_equalTo(14);
        }];
        [self.discountLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(72);
                    make.top.mas_equalTo(weakself.allMoneyLa.mas_bottom).offset(6);
                    make.height.mas_equalTo(12);
        }];
        
        self.detailBt.frame = CGRectMake(72, 45, size1.width + 18, 12);
        
    }else{
        self.detailBt.frame = CGRectMake(72 + size.width + 12, 40, size1.width + 18, 12);
    }
    
    [self.payBt setTitle:[NSString stringWithFormat:@"结算(%@)",_model.Num1] forState:(UIControlStateNormal)];

}

-(void)clickSele:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.tapAllBlock(@"1");
    }else{
        self.tapAllBlock(@"0");
    }
}

-(void)clickPay{
    self.tapPayBlock(@"1");
}

-(void)clickDetail{
    self.tapDetailBlock(@"1");
}
@end
