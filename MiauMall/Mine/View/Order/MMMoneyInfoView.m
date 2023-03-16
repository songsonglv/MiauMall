//
//  MMMoneyInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMMoneyInfoView.h"
@interface MMMoneyInfoView ()
@property (nonatomic, strong) UILabel *allMoneyLa;//商品总额
@property (nonatomic, strong) UILabel *discountLa;//商品折扣
@property (nonatomic, strong) UILabel *couponLa;//优惠券
@property (nonatomic, strong) UILabel *integrationLa;//蜜豆积分
@property (nonatomic, strong) UILabel *freightLa;//商品总额
@property (nonatomic, strong) UILabel *actualMoneyLa;//实际支付
@property (nonatomic, strong) UILabel *jMoneyLa;//约多少钱
@end

@implementation MMMoneyInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self setUI];
    }
    return self;
}


-(void)setUI{
    NSArray *arr = @[@"商品总额",@"商品折扣",@"优惠券",@"蜜豆积分",@"运费"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 14 + 40 * i, WIDTH - 20, 40)];
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(15, 14, 65, 13);
        [view addSubview:lab];
        
        UILabel *moneyLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        moneyLa.preferredMaxLayoutWidth = WIDTH - 120;
        [moneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:moneyLa];
        
        [moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        if(i == 0){
            self.allMoneyLa = moneyLa;
        }else if (i == 1){
            self.discountLa = moneyLa;
        }else if (i == 2){
            self.couponLa = moneyLa;
        }else if (i == 3){
            self.integrationLa = moneyLa;
        }else{
            self.freightLa = moneyLa;
        }
    }
    
    UILabel *actualLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    actualLa.preferredMaxLayoutWidth = WIDTH - 40;
    [actualLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:actualLa];
    self.actualMoneyLa = actualLa;
    
    [actualLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(230);
            make.height.mas_equalTo(16);
    }];
    
    UILabel *jmoneyLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    jmoneyLa.preferredMaxLayoutWidth = WIDTH - 40;
    [jmoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:jmoneyLa];
    self.jMoneyLa = jmoneyLa;
    
    [jmoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(actualLa.mas_bottom).offset(15);
            make.height.mas_equalTo(12);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, self.height - 0.5, WIDTH - 44, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    [self addSubview:line];
}

-(void)setModel:(MMOrderDetailInfoModel *)model{
    _model = model;
    self.allMoneyLa.text = [NSString stringWithFormat:@"-%@",_model.ItemMoneyShow];
    self.discountLa.text = [NSString stringWithFormat:@"-%@",_model.DiscountMoneysShow];
    self.couponLa.text = [NSString stringWithFormat:@"-%@",_model.DiscountShow];
    self.integrationLa.text = [NSString stringWithFormat:@"-%@",_model.IntegrationShow];
    self.freightLa.text = _model.FreightShow;
    
    [self.actualMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"实付款").textColor(TCUIColorFromRGB(0x242424)).font([UIFont fontWithName:@"PingfangSC-Medium" size:14]);
        confer.text(self->_model.PayMoneyShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:19]);
    }];
    
    self.jMoneyLa.text = _model.OtherPayShow;
}
@end
