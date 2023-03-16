//
//  MMUseMidouPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import "MMUseMidouPopView.h"
@interface MMUseMidouPopView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField*numField;
@property (nonatomic, strong) UILabel *midouBalanceLa;//积分余额

@property (nonatomic, strong) UILabel *allMoney;//所有抵扣
@property (nonatomic, strong) UILabel *customMoneyLa;//自定义抵扣 不可大于余额
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSString *num;
@property (nonatomic, strong) UILabel *tipsLa;
@end

@implementation MMUseMidouPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        self.type = @"0";
    }
    return self;
    
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 * HEIGHT - 402, WIDTH, 402)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UILabel *balanceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    [balanceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"蜜豆积分").textColor(TCUIColorFromRGB(0x373838)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]),
        confer.text(@"（剩余：865）").textColor(TCUIColorFromRGB(0x373838)).font([UIFont fontWithName:@"PingFangSC-Regular" size:13]);
    }];
    balanceLa.preferredMaxLayoutWidth = WIDTH - 110;
    [balanceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.bgView addSubview:balanceLa];
    self.midouBalanceLa = balanceLa;
    
    [balanceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(16);
    }];
    
    UIButton *closeBt = [[UIButton alloc]init];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    [closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(17);
    }];
    
    UIButton *ruleBt = [[UIButton alloc]init];
    [ruleBt setTitle:@"使用规则" forState:(UIControlStateNormal)];
    [ruleBt setTitleColor:TCUIColorFromRGB(0xa3a3a3) forState:(UIControlStateNormal)];
    ruleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [ruleBt addTarget:self action:@selector(clickRule) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:ruleBt];
    
    [ruleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBt.mas_left).offset(-10);
            make.top.mas_equalTo(23);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(12);
    }];
    
    NSArray *arr = @[@"暂不使用蜜豆积分",@"抵扣USD3.89最高可使用865蜜豆",@"自定义使用蜜豆数量"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 55 + 44 * i, WIDTH, 44)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.bgView addSubview:view];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        btn.tag = 100 + i;
        btn.selected = NO;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(20);
                    make.centerY.mas_equalTo(view);
                    make.height.width.mas_equalTo(15);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x373838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 60;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(45);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(14);
        }];
        
        if(i == 0){
            btn.selected = YES;
            self.selectBt = btn;
        }else if (i == 1){
            self.allMoney = lab;
            [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text(@"抵扣").textColor(TCUIColorFromRGB(0x373838));
                confer.text(@"USD3.89").textColor(redColor2);
                confer.text(@"最高可使用865蜜豆").textColor(TCUIColorFromRGB(0x373838));
            }];
        }
    }
    
    UILabel *lab1 = [UILabel publicLab:@"使用" textColor:TCUIColorFromRGB(0x373838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab1.frame = CGRectMake(46, 188, 28, 14);
    [self.bgView addSubview:lab1];
    
    UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(76, 185, 80, 20)];
    field1.delegate = self;
    field1.keyboardType = UIKeyboardTypeNumberPad;
    field1.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
    field1.textColor = TCUIColorFromRGB(0x373838);
    field1.clearButtonMode = UITextFieldViewModeWhileEditing;
    field1.borderStyle = UITextBorderStyleLine;
    field1.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:field1];
    self.numField = field1;
    
    UILabel *lab2 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    [lab2 rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"蜜豆").textColor(TCUIColorFromRGB(0x373838));
    }];
    lab2.preferredMaxLayoutWidth = WIDTH - 180;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.bgView addSubview:lab2];
    self.customMoneyLa = lab2;
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(188);
            make.left.mas_equalTo(160);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *tipLa = [UILabel publicLab:@"本单您最多可使用865个蜜豆哟" textColor:TCUIColorFromRGB(0x909090) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    tipLa.frame = CGRectMake(46, 218, 180, 12);
    [self.bgView addSubview:tipLa];
    self.tipsLa = tipLa;
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, self.bgView.height - 72, WIDTH - 36, 36)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

-(void)setModel:(MMConfirmOrderModel *)model{
    _model = model;
    KweakSelf(self);
    [self.midouBalanceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"蜜豆积分").textColor(TCUIColorFromRGB(0x373838)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        confer.text([NSString stringWithFormat:@"（剩余：%@）",weakself.model.MyIntegral]).textColor(TCUIColorFromRGB(0x373838)).font([UIFont fontWithName:@"PingFangSC-Regular" size:13]);
    }];
    
    
    [self.allMoney rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"抵扣").textColor(TCUIColorFromRGB(0x373838));
        confer.text(weakself.model.MaxUseIntegralShow).textColor(redColor2);
        confer.text([NSString stringWithFormat:@"最高可使用%@蜜豆",weakself.model.MyIntegral]).textColor(TCUIColorFromRGB(0x373838));
    }];
    
    self.numField.text = _model.MyIntegral;
    self.num = _model.MyIntegral;
    self.tipsLa.text = [NSString stringWithFormat:@"本单您最多可使用%@个蜜豆哟",_model.MyIntegral];
}

-(void)clickSure{
    [self hideView];
    self.tapSureBlock(self.num);
}

-(void)clickBt:(UIButton *)sender{
    if (![self.selectBt isEqual:sender]) {
        sender.selected = YES;
        self.selectBt.selected = NO;
        self.selectBt = sender;
    }
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",sender.tag - 100];
    self.type = indexStr;
    if([self.type isEqualToString: @"0"]){
        self.num = 0;
    }else if ([self.type isEqualToString:@"1"]){
        self.num = self.model.MaxUseIntegral;
    }else{
        
    }
}

#pragma mark -- uitextfielddelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.num = textField.text;
}

-(void)clickRule{
    self.tapRuleBlock(@"1");
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
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}
@end
