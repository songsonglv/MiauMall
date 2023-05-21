//
//  MMPassWordPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import "MMPassWordPopView.h"

@interface MMPassWordPopView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *passField;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MMPassWordPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(24, HEIGHT + (HEIGHT - 220)/2, WIDTH - 48, 220)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UILabel *lab = [UILabel publicLab:@"请输入支付密码" textColor:TCUIColorFromRGB(0x2e2e2e) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    lab.frame = CGRectMake(0, 32, WIDTH - 48, 18);
    [self.bgView addSubview:lab];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 90, 32, 17, 17)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(lab.frame) + 40, WIDTH - 134, 20)];
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入您的支付密码" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x999999)}];
    field.delegate = self;
    field.secureTextEntry = YES;
    field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    field.textColor = TCUIColorFromRGB(0x333333);
    field.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:field];
    self.passField = field;
    
    UIButton *eyeBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(field.frame) + 12, CGRectGetMaxY(lab.frame) + 44, 18, 12)];
    [eyeBt setImage:[UIImage imageNamed:@"eye_no_black"] forState:(UIControlStateNormal)];
    [eyeBt setImage:[UIImage imageNamed:@"eye_yes_black"] forState:(UIControlStateSelected)];
    eyeBt.selected = NO;
    [eyeBt addTarget:self action:@selector(clickEye:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:eyeBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(field.frame) + 5, WIDTH - 104, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
    [self.bgView addSubview:line];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 172)/2, CGRectGetMaxY(line.frame) + 20, 124, 34)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 17;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

-(void)clickEye:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.passField.secureTextEntry = NO;
    }else{
        self.passField.secureTextEntry = YES;
    }
}

-(void)clickSure{
    self.returnPassBlock(self.passField.text);
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
