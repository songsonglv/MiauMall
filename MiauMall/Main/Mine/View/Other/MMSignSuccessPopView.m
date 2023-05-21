//
//  MMSignSuccessPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/27.
//

#import "MMSignSuccessPopView.h"

@interface MMSignSuccessPopView ()
@property (nonatomic, strong) UILabel *pointLa;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation MMSignSuccessPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
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
    
    self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 290)/2, HEIGHT + (HEIGHT - 276)/2, 290,276)];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.image = [UIImage imageNamed:@"sign_bg"];
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x222222) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab.frame = CGRectMake(45, 180, 190, 16);
    [self.bgView addSubview:lab];
    self.pointLa = lab;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(lab.frame) + 28, 200, 38)];
//    [btn setImage:[UIImage imageNamed:@"sign_btbg"] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:@"sign_btbg"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"lianXuQiaDao"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
}

-(void)setPointNum:(NSString *)pointNum{
    _pointNum = pointNum;
    self.pointLa.text = [NSString stringWithFormat:@"+%@ %@",_pointNum,[UserDefaultLocationDic valueForKey:@"midou"]];
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
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
