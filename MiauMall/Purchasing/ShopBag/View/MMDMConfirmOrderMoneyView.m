//
//  MMDMConfirmOrderMoneyView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMConfirmOrderMoneyView.h"

@interface MMDMConfirmOrderMoneyView ()
@property (nonatomic, strong) UILabel *allMoneyLa;
@property (nonatomic, strong) UILabel *feeLa;
@property (nonatomic, strong) UILabel *serviceLa;
@property (nonatomic, strong) UILabel *yunfeeLa;
@property (nonatomic, strong) UILabel *huilvLa;
@end

@implementation MMDMConfirmOrderMoneyView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *tiLa = [UILabel publicLab:@"清单明细" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    tiLa.frame = CGRectMake(17, 4, WIDTH - 34, 15);
    [self addSubview:tiLa];
    
    NSArray *arr = @[@"商品总价",@"手续费",@"服务费",@"日本国内运费",@"当前汇率"];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 42 * i + 24, WIDTH, 42)];
        [self addSubview:view];
        
        UILabel *lab1 = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH - 140;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.mas_equalTo(view);
            make.height.mas_equalTo(13);
        }];
        
        UILabel *lab2 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab2.preferredMaxLayoutWidth = WIDTH - 150;
        [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab2];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        if(i == 0){
            self.allMoneyLa = lab2;
        }else if (i == 1){
            self.feeLa = lab2;
        }else if (i == 2){
            self.serviceLa = lab2;
        }else if (i == 3){
            self.yunfeeLa = lab2;
        }else{
            self.huilvLa = lab2;
        }
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(11, 259.5, WIDTH - 22, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
    [self addSubview:line];
}

-(void)setModel:(MMDMConfirmOrderModel *)model{
    _model = model;
    self.allMoneyLa.text = _model.ProductMoneyShow;
    self.feeLa.text = _model.HandingMoneyShow;
    self.serviceLa.text = _model.SureMoneyShow;
    self.yunfeeLa.text = _model.JapanFreightMoneyShow;
    self.huilvLa.text = _model.HuiLvTips;
}

@end
