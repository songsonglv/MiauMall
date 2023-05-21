//
//  MMDMConfirmPurchasePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import "MMDMConfirmPurchasePopView.h"

@interface MMDMConfirmPurchasePopView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation MMDMConfirmPurchasePopView

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
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.view];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
//    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 286)/2,  HEIGHT + (HEIGHT - 288)/2, 286, 288)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    
    UILabel *titleLa = [UILabel publicLab:@"是否要代购如下链接商品" textColor:TCUIColorFromRGB(0x353535) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, 286, 16);
    [self.bgView addSubview:titleLa];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLa.frame) + 25, 256, 160)];
    textView.backgroundColor = UIColor.clearColor;
    textView.delegate = self;
    textView.textColor = TCUIColorFromRGB(0x353535);
    textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
//    textView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
//    textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
    [self.bgView addSubview:textView];
    
    self.textView = textView;
    
    
    UIButton *noneBt = [[UIButton alloc]initWithFrame:CGRectMake(18, 232, 120, 36)];
    noneBt.layer.masksToBounds = YES;
    noneBt.layer.cornerRadius = 18;
    [noneBt setBackgroundColor:TCUIColorFromRGB(0xe3e3e3)];
    [noneBt setTitle:@"不需要" forState:(UIControlStateNormal)];
    [noneBt setTitleColor:TCUIColorFromRGB(0x353535) forState:(UIControlStateNormal)];
    [noneBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    noneBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.bgView addSubview:noneBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noneBt.frame) + 10, 232, 120, 36)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [self setView:sureBt andCorlors:@[TCUIColorFromRGB(0xf78e92),TCUIColorFromRGB(0xe62d57)]];
    [sureBt setTitle:@"确定购买" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.bgView addSubview:sureBt];
    
}

-(void)setLinkUrl:(NSString *)linkUrl{
    _linkUrl = linkUrl;
    self.textView.text = _linkUrl;
}

-(void)clickSure{
    self.clickSureBlock(@"1");
    [self hideView];
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
