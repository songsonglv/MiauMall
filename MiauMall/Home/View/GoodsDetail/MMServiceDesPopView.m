//
//  MMServiceDesPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import "MMServiceDesPopView.h"

@interface MMServiceDesPopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MMServiceDesPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    NSArray *contentArr = @[@[@"日本直邮",@"MiauMall公司总部位于日本，您所购买的商品均由总部仓库直接发货，途中无中转仓库，包裹直接从日本仓库依附快递物流送达您的手中。"],@[@"100%正品",@"MiauMall所有销售商品均为100%日本本土版正品，无免税店版国际版商品售卖。"],@[@"假一赔十",@"MiauMall所有销售商品全链可查，承诺假一赔十。"],@[@"包税",@"MiauMall所有销售商品无需另付税费"],@[@"不支持无理由退换货",@"MiauMall所有销售商品均不支持无理由退换货"]];
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 460, WIDTH, 35)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 17.5;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 444, WIDTH, 445)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UILabel *titleLa = [UILabel publicLab:@"服务说明" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    [self.contentView addSubview:titleLa];
    
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(15);
    }];
    
    CGFloat hei = 24;
    for (int i = 0; i < contentArr.count; i++) {
        NSArray *arr1 = contentArr[i];
        UILabel *la = [UILabel publicLab:arr1[1] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        la.frame = CGRectMake(0, 0, WIDTH - 52, 36);
        CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + hei, WIDTH, size.height + 54)];
        [self.contentView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 1, 12, 12)];
        iconImage.image = [UIImage imageNamed:@"select_mainColor"];
        [view addSubview:iconImage];
        
        UILabel *lab1 = [UILabel publicLab:arr1[0] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(CGRectGetMaxX(iconImage.frame) + 6, 0, 160, 14);
        [view addSubview:lab1];
        
        la.preferredMaxLayoutWidth = WIDTH - 52;
        [la setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:la];
        
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(30);
                    make.top.mas_equalTo(24);
                    make.width.mas_equalTo(WIDTH - 52);
        }];
        
        hei += size.height + 54;
    }
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
