//
//  MMOrderRemindPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//

#import "MMOrderRemindPopView.h"
@interface MMOrderRemindPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MMOrderRemindPopView

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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 260, WIDTH, 260)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 58, 58)];
    image.centerX = self.bgView.centerX;
    image.image = [UIImage imageNamed:@"select_yes"];
    [self.bgView addSubview:image];
    
    UILabel *lab = [UILabel publicLab:@"已经提醒商家尽快发货" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    lab.frame = CGRectMake(0, CGRectGetMaxY(image.frame) + 30, WIDTH, 16);
    [self.bgView addSubview:lab];
    CGFloat scale = (WIDTH - 292)/2;
    UIButton *goonChatBt = [[UIButton alloc]initWithFrame:CGRectMake(scale, CGRectGetMaxY(lab.frame) + 30, 140, 40)];
    [goonChatBt setBackgroundColor:redColor2];
    [goonChatBt setTitle:@"继续联系商家" forState:(UIControlStateNormal)];
    [goonChatBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    goonChatBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    goonChatBt.layer.masksToBounds = YES;
    goonChatBt.layer.cornerRadius = 20;
    [goonChatBt addTarget:self action:@selector(goon) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:goonChatBt];
    
    UIButton *knowBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goonChatBt.frame) + 12, CGRectGetMaxY(lab.frame) + 30, 140, 40)];
    [knowBt setBackgroundColor:TCUIColorFromRGB(0x242424)];
    [knowBt setTitle:@"我知道了" forState:(UIControlStateNormal)];
    [knowBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    knowBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    knowBt.layer.masksToBounds = YES;
    knowBt.layer.cornerRadius = 20;
    [knowBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:knowBt];
}

-(void)goon{
    self.tapGoonBlock(@"1");
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
