//
//  MMSelectAccountTypePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMSelectAccountTypePopView.h"

@interface MMSelectAccountTypePopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *selectBt;

@end

@implementation MMSelectAccountTypePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 294)/2, HEIGHT + (HEIGHT - 202)/2, 294, 202)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    [self addSubview:self.bgView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(260, 20, 14, 14)];
    [closeBt setBackgroundImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    NSArray *arr = @[@"支付宝",@"微信",@"银行卡"];
    NSArray *imageArr = @[@"ali_pay_icon",@"wx_pay_icon",@"paypal_pay_icon"];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 53 + 44 * i, 294, 22)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.bgView addSubview:view];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imageArr[i]];
        [view addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(30);
                    make.top.mas_equalTo(0);
                    make.width.height.mas_equalTo(22);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 150;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(66);
                    make.top.mas_equalTo(3);
                    make.height.mas_equalTo(16);
        }];
        
        UIButton *seleBt = [[UIButton alloc]init];
        seleBt.selected = NO;
        seleBt.tag = 100 + i;
        [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [seleBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [seleBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:seleBt];
        
        [seleBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-36);
                    make.top.mas_equalTo(3);
                    make.width.height.mas_equalTo(16);
        }];
    }
    
}

-(void)clickBt:(UIButton *)sender{
    if (![self.selectBt isEqual:sender]) {
        self.selectBt.selected = NO;
    }
    
    sender.selected = YES;
    self.selectBt = sender;
    NSString *typeStr = [NSString stringWithFormat:@"%ld",sender.tag - 100];
    NSString *type;
    if(sender.tag == 100){
        type = @"支付宝";
    }else if (sender.tag == 101){
        type = @"微信";
    }else{
        type = @"银行卡";
    }
    self.selectTypeBlcok(typeStr,type);
    [self hideView];
    
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
