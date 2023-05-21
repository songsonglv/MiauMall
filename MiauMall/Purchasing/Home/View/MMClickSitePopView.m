//
//  MMClickSitePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/17.
//

#import "MMClickSitePopView.h"

@interface MMClickSitePopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MMClickSitePopView


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
    
       
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    NSString *str = @"即将通过手机浏览器打开对应网站，您可以将想要代购的商品链接复制后，提交到页面搜索栏中。";
    
    CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(252,MAXFLOAT)];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 286)/2,  HEIGHT + (HEIGHT - size.height - 124)/2, 286, size.height + 124)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    
    
    UILabel *contLa = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x3a3a3a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    contLa.frame = CGRectMake(17, 30, 252, size.height);
    [self.bgView addSubview:contLa];
    
    UIButton *noneBt = [[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(contLa.frame) + 32, 120, 36)];
    noneBt.layer.masksToBounds = YES;
    noneBt.layer.cornerRadius = 18;
    [noneBt setBackgroundColor:TCUIColorFromRGB(0xe3e3e3)];
    [noneBt setTitle:@"取消" forState:(UIControlStateNormal)];
    [noneBt setTitleColor:TCUIColorFromRGB(0x353535) forState:(UIControlStateNormal)];
    [noneBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    noneBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.bgView addSubview:noneBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noneBt.frame) + 10,  CGRectGetMaxY(contLa.frame) + 32, 120, 36)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [self setView:sureBt andCorlors:@[TCUIColorFromRGB(0xf78e92),TCUIColorFromRGB(0xe62d57)]];
    [sureBt setTitle:@"立即前往" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.bgView addSubview:sureBt];
    
   
    
    
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
