//
//  MMCardPayTipPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/21.
//

#import "MMCardPayTipPopView.h"

@interface MMCardPayTipPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *jpLa;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) UILabel *tipsLa;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) NSString *seleStr;
@end

@implementation MMCardPayTipPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.seleStr = @"0";
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 386, WIDTH, 386)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    [self.view addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    
    UILabel *titleLa = [UILabel publicLab:@"信用卡支付" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 44, WIDTH, 16);
    [self.bgView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 34, 16, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 20 + 50 * i, WIDTH, 50)];
        [self.bgView addSubview:view];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(24, 17, 16, 16)];
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [btn setEnlargeEdgeWithTop:17 right:300 bottom:17 left:24];
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 8, 18, 200, 14);
        [view addSubview:lab];
        
        if(i == 0){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(24, 49.5, WIDTH - 48, 0.5)];
            line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
            [view addSubview:line];
            
            self.jpLa = lab;
            btn.selected = YES;
            self.selectBt = btn;
        }else{
            self.moneyLa = lab;
        }
    }
    
    UILabel *tipLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x757575) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    tipLa.preferredMaxLayoutWidth = WIDTH - 100;
    [tipLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.bgView addSubview:tipLa];
    self.tipsLa = tipLa;
    
    [tipLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(46);
            make.top.mas_equalTo(CGRectGetMaxY(titleLa.frame) + 120);
            make.width.mas_equalTo(WIDTH - 100);
    }];
    
    
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(16, 300, WIDTH - 32, 46)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:@"确定支付" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 23;
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
}

-(void)clickBt:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    if([self.selectBt isEqual:sender]){
        
    }else{
        sender.selected = !sender.selected;
        self.selectBt.selected = NO;
        self.selectBt = sender;
        self.seleStr = [NSString stringWithFormat:@"%ld",(long)tag];
    }
}

-(void)clickSure{
    [self hideView];
    self.returnSelectBlock(self.seleStr);
}

-(void)setModel:(MMCardPayInfoModel *)model{
    KweakSelf(self);
    _model = model;
    self.jpLa.text = _model.PayMoneyJPY;
    self.moneyLa.text = _model.PayMoneyShow;
    self.tipsLa.text = _model.StripeMoneyTips;
    NSArray *temp = [_model.StripeMoneyTips componentsSeparatedByString:_model.StripeMoneyPercent];
    [self.tipsLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp[0]).textColor(TCUIColorFromRGB(0x757575));
        confer.text(weakself.model.StripeMoneyPercent).textColor(redColor2);
        confer.text(temp[1]).textColor(TCUIColorFromRGB(0x757575));
    }];
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.bgView.centerY =self.bgView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
