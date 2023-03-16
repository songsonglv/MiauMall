//
//  MMDiscountDetailPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import "MMDiscountDetailPopView.h"
@interface MMDiscountDetailPopView ()
@property (nonatomic, strong) UILabel *goodsMoneyLa;
@property (nonatomic, strong) UILabel *discountLa;
@property (nonatomic, strong) UILabel *coupunLa;
@property (nonatomic, strong) UILabel *integralLa;
@property (nonatomic, strong) UILabel *allDiscountLa;
@property (nonatomic, strong) UILabel *allMoneyLa;
@property (nonatomic, strong) UILabel *allDsi2La;
@property (nonatomic, strong) UIButton *payBt;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MMDiscountDetailPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 358, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 340, WIDTH, 340)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
 
    UILabel *titleLa = [UILabel publicLab:@"优惠明细" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 15, WIDTH, 15);
    [self.contentView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 22, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    NSArray *arr = @[@"商品总额",@"商品折扣",@"优惠券",@"蜜豆积分"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 12 + 27 * i, WIDTH, 27)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.contentView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 150;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *monLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 150;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:monLa];
        
        [monLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(12);
        }];
        
        if(i == 0){
            self.goodsMoneyLa = monLa;
        }else if (i == 1){
            self.discountLa = monLa;
        }else if (i == 2){
            self.coupunLa = monLa;
        }else{
            self.integralLa = monLa;
        }
    }
    
    UILabel *lab1 = [UILabel publicLab:@"优惠合计" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 180;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(230);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *allDisLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    allDisLa.preferredMaxLayoutWidth = 150;
    [allDisLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:allDisLa];
    self.allDiscountLa = allDisLa;
    
    [allDisLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(231);
            make.height.mas_equalTo(12);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 246, WIDTH, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xf3f2f1);
    [self.contentView addSubview:line];
    
    UILabel *allMoneyLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    allMoneyLa.preferredMaxLayoutWidth = 200;
    [allMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:allMoneyLa];
    self.allMoneyLa = allMoneyLa;
    
    [allMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(CGRectGetMaxY(line.frame) + 15);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *discountLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    discountLa.preferredMaxLayoutWidth = 200;
    [discountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:discountLa];
    self.allDsi2La = discountLa;
    
    [discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
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
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(discountLa.mas_right).offset(8);
            make.top.mas_equalTo(allMoneyLa.mas_bottom).offset(10);
            make.width.mas_equalTo(size1.width + 18);
            make.height.mas_equalTo(12);
    }];
//    self.detailBt = btn;
    
    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 105, CGRectGetMaxY(line.frame) + 15, 100, 36)];
    [payBt setBackgroundColor:redColor2];
    [payBt setTitle:@"结算" forState:(UIControlStateNormal)];
    [payBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
    payBt.layer.masksToBounds = YES;
    payBt.layer.cornerRadius = 18;
    [payBt addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:payBt];
    self.payBt = payBt;
}

-(void)setModel:(MMShopCarModel *)model{
    _model = model;
    self.goodsMoneyLa.text = _model._totalshow;
    self.discountLa.text = [NSString stringWithFormat:@"-%@",_model._discounttotalsalesshow];
    self.coupunLa.text = @"-0";
    self.integralLa.text = @"-0";
    self.allDiscountLa.text = [NSString stringWithFormat:@"-%@",_model._discounttotalsalesshow];
    NSArray *temp=[_model._totalactivepriceshow componentsSeparatedByString:@" "];
    NSString *str = temp[0];
    NSString *str1 = temp[1];
    [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"合计：%@",str]).textColor(redColor2).font([UIFont systemFontOfSize:12]);
        confer.text(str1).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
    }];
    
    self.allDsi2La.text = [NSString stringWithFormat:@"共优惠%@",_model._totalsalesshow];
    [self.payBt setTitle:[NSString stringWithFormat:@"结算(%@)",_model.Num1] forState:(UIControlStateNormal)];
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

-(void)clickPay{
    self.clickPayBlock(@"1");
}
@end
