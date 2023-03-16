//
//  MMTitleContentPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//  统一样式的标题内容 取消确定按钮的弹窗

#import "MMTitleContentPopView.h"

@interface MMTitleContentPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *cancleStr;
@property (nonatomic, strong) NSString *sureStr;
@end

@implementation MMTitleContentPopView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(nonnull NSString *)title andContent:(nonnull NSString *)content andCancleText:(nonnull NSString *)cancleText andSureText:(nonnull NSString *)sureText{
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.content = content;
        self.cancleStr = cancleText;
        self.sureStr = sureText;
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(38,  HEIGHT + (HEIGHT - 180)/2, WIDTH - 76, 180)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:self.title textColor:TCUIColorFromRGB(0x3f3f3f) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, WIDTH - 76, 16);
    [self.bgView addSubview:titleLa];
    
    UILabel *contLa = [UILabel publicLab:self.content textColor:TCUIColorFromRGB(0x5d5d5d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    contLa.frame = CGRectMake(20, CGRectGetMaxY(titleLa.frame) + 20, self.bgView.width - 40, 30);
    [contLa sizeToFit];
    [self.bgView addSubview:contLa];
    
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake((self.bgView.width - 215)/2, CGRectGetMaxY(contLa.frame) + 20, 100, 30)];
    [cancleBt setTitle:self.cancleStr forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = redColor2.CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancleBt.frame) + 15, CGRectGetMaxY(contLa.frame) + 20, 100, 30)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:self.sureStr forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 15;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

-(void)clickCancle{
    self.tapCancleBlcok(@"1");
    [self hideView];
}

-(void)clickSure{
    self.tapGoonBlock(@"1");
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
