//
//  MMDMChooseLogisticBottomView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/12.
//

#import "MMDMChooseLogisticBottomView.h"

@interface MMDMChooseLogisticBottomView ()
@property (nonatomic, strong) UILabel *moneyLa;
@end

@implementation MMDMChooseLogisticBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
       
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Semibold" size:18 numberOfLines:18];
    lab1.frame = CGRectMake(0, 15, WIDTH, 18);
    [self addSubview:lab1];
    self.moneyLa = lab1;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, 44, WIDTH - 24, 40)];
    [btn setBackgroundColor:redColor3];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"confirmSubmit"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
}

-(void)setModel:(MMDMChooseLogisticsModel *)model{
    _model = model;
    NSArray *temp = [_model.PayMoneyShow componentsSeparatedByString:@" "];
    [self.moneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([UserDefaultLocationDic valueForKey:@"itotal"]).textColor(TCUIColorFromRGB(0x464646)).font([UIFont systemFontOfSize:12]);
        confer.text(temp[0]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
        confer.text(temp[1]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:18]);
        confer.text([NSString stringWithFormat:@"(%@%@)",[UserDefaultLocationDic valueForKey:@"iabout"],_model.PaySignMoney]).textColor(TCUIColorFromRGB(0x464646)).font([UIFont systemFontOfSize:12]);
    }];
}

-(void)clickBt{
    self.returnSubBlock(@"1");
}

@end
