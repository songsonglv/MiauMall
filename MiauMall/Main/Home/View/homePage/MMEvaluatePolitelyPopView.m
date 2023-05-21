//
//  MMEvaluatePolitelyPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/20.
//  好评有礼弹窗 appstore内评价

#import "MMEvaluatePolitelyPopView.h"

@interface MMEvaluatePolitelyPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) NSArray *arr;
@end

@implementation MMEvaluatePolitelyPopView

-(instancetype)initWithFrame:(CGRect)frame andTextArr:(nonnull NSArray *)arr{
    if(self = [super initWithFrame:frame]){
        self.arr = arr;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *textArr = [NSMutableArray array];
    //0 动动手指 1 下次再说 2 我要吐槽 3 评价App五星好评，可得500日币奖励 4 写好评 鼓励一下
    for (NSDictionary *dic in self.arr) {
        [textArr addObject:dic[@"Name"]];
    }
    
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
//    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 260)/2, HEIGHT +  (HEIGHT - 308)/2, 260, 308)];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.bgView];
    
    self.contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 260, 308)];
    self.contentView.image = [UIImage imageNamed:@"pj_bg"];
//    self.contentView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.contentView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(236, 12, 12, 13)];
    [closeBt setImage:[UIImage imageNamed:@"close_black"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UILabel *lab1 = [UILabel publicLab:textArr[0] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:17 numberOfLines:0];
    lab1.frame = CGRectMake(0, 158, 260, 16);
    [self.bgView addSubview:lab1];
    
    CGSize size = [NSString sizeWithText:textArr[3] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(260,MAXFLOAT)];
    UILabel *lab2 = [UILabel publicLab:textArr[3] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab2.frame = CGRectMake(0, CGRectGetMaxY(lab1.frame) + 15, 260, size.height);
    [self.bgView addSubview:lab2];
    
    
    CGSize size1 = [NSString sizeWithText:textArr[4] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((260 - size1.width - 40)/2, CGRectGetMaxY(lab2.frame) + 13, size1.width + 40, 34)];
    [btn setBackgroundColor:TCUIColorFromRGB(0x333333)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingfangSC-Regular" size:15];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 17;
    [btn setTitle:textArr[4] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + 13, 1, 12)];
    line.centerX = self.contentView.centerX;
    line.backgroundColor = TCUIColorFromRGB(0x333333);
    [self.bgView addSubview:line];
    
    CGSize size2 = [NSString sizeWithText:textArr[1] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *leftBt = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + 13, 130, 13)];
    [leftBt setTitle:textArr[1] forState:(UIControlStateNormal)];
    [leftBt setTitleColor:TCUIColorFromRGB(0x909090) forState:(UIControlStateNormal)];
    leftBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    leftBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:leftBt];
    
    CGSize size3 = [NSString sizeWithText:textArr[2] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame), CGRectGetMaxY(btn.frame) + 13, 130, 13)];
    [rightBt setTitle:textArr[2] forState:(UIControlStateNormal)];
    [rightBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    rightBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    rightBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBt addTarget:self action:@selector(clickTc) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:rightBt];
}

-(void)clickBtn{
    self.clickGoBlock(@"1");
    [self hideView];
}

-(void)clickTc{
    self.goTcBlock(@"1");
    [self hideView];
}


-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY = self.bgView.centerY + HEIGHT;
        
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
