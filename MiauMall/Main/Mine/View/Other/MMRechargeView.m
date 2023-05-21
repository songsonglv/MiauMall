//
//  MMRechargeView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMRechargeView.h"

@interface MMRechargeView ()
@property (nonatomic, strong) UILabel *moneyLa;//充值金额
@property (nonatomic, strong) UILabel *signLa;//货币单位
@property (nonatomic, strong) UILabel *integralLa;//送积分
@property (nonatomic, strong) MMRechargeModel *model;

@end

@implementation MMRechargeView

-(instancetype)initWithFrame:(CGRect)frame andModel:(nonnull MMRechargeModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        self.model = model;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UILabel *moneyLa = [UILabel publicLab:self.model.full textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    moneyLa.preferredMaxLayoutWidth = 80;
    [moneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:moneyLa];
    self.moneyLa = moneyLa;
    
    [moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(17);
            make.height.mas_equalTo(15);
    }];
    
    UILabel *signLa = [UILabel publicLab:@"JPY" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:8 numberOfLines:0];
    [self addSubview:signLa];
    self.signLa = signLa;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(moneyLa.mas_right).offset(0);
            make.top.mas_equalTo(25);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(8);
    }];
    
    UILabel *integralLa = [UILabel publicLab:[NSString stringWithFormat:@"%@+%@JPY",[UserDefaultLocationDic valueForKey:@"igive"],self.model.less] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
    if([lang isEqualToString:@"2"]){
        integralLa.text = [NSString stringWithFormat:@"+%@JPY GET",self.model.less];
    }
    [self addSubview:integralLa];
    
    [integralLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
    }];
    self.integralLa = integralLa;
}

-(void)setIsSelect:(NSString *)isSelect{
    _isSelect = isSelect;
    if([_isSelect isEqualToString:@"1"]){
        [self setBackgroundColor:TCUIColorFromRGB(0xff5011)];
        self.moneyLa.textColor = TCUIColorFromRGB(0xffffff);
        self.signLa.textColor = TCUIColorFromRGB(0xffffff);
        self.integralLa.textColor = TCUIColorFromRGB(0xffffff);
    }else{
        self.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        self.moneyLa.textColor = TCUIColorFromRGB(0x000000);
        self.signLa.textColor = TCUIColorFromRGB(0x000000);
        self.integralLa.textColor = TCUIColorFromRGB(0x000000);
    }
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}
@end
