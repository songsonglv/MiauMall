//
//  MMAnonymousPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//  解释匿名的弹窗

#import "MMAnonymousPopView.h"
@interface MMAnonymousPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MMAnonymousPopView

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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0,  2 * HEIGHT - 406, WIDTH, 406)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:@"详细说明" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 28, WIDTH, 16);
    [self.bgView addSubview:titleLa];
    
    UILabel *lab1 = [UILabel publicLab:@"选择评价匿名" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab1.frame = CGRectMake(16, 75, WIDTH - 32, 14);
    [self.bgView addSubview:lab1];
    
    UILabel *contLa1 = [UILabel publicLab:@"评价在”宝贝评价”区展示时，你的用户昵称和头像将不会对外展示。" textColor:TCUIColorFromRGB(0x545454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    CGSize size = [NSString sizeWithText:contLa1.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(WIDTH - 32,MAXFLOAT)];
    contLa1.frame = CGRectMake(16, CGRectGetMaxY(lab1.frame) + 13, WIDTH - 32, size.height);
    [self.bgView addSubview:contLa1];
    
    UILabel *lab2 = [UILabel publicLab:@"选择评价公开" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab2.frame = CGRectMake(16, CGRectGetMaxY(contLa1.frame) + 20, WIDTH - 32, 14);
    [self.bgView addSubview:lab2];
    
    UILabel *contLa2 = [UILabel publicLab:@"1.评价在“宝贝评价”区展示时，将公开你的用户昵称和头像。\n2.评价中的买家秀有更大机会被蜜柚精选" textColor:TCUIColorFromRGB(0x545454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    CGSize size1 = [NSString sizeWithText:contLa2.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(WIDTH - 32,MAXFLOAT)];
    contLa2.frame = CGRectMake(16, CGRectGetMaxY(lab2.frame) + 13, WIDTH - 32, size1.height);
    [self.bgView addSubview:contLa2];
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
