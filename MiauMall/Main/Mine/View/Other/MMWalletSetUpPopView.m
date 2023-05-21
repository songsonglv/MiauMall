//
//  MMWalletSetUpPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import "MMWalletSetUpPopView.h"
@interface MMWalletSetUpPopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MMWalletSetUpPopView

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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 310, WIDTH, 310)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -15, WIDTH, 30)];
    topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = 15;
    [self.bgView addSubview:topView];
    
    
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"balanceDetail"],[UserDefaultLocationDic valueForKey:@"changePwd"],[UserDefaultLocationDic valueForKey:@"zhPwd"]];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 62 * i, WIDTH, 62)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.bgView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:17 numberOfLines:0];
        lab.frame = CGRectMake(0, 22, WIDTH, 17);
        [view addSubview:lab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 61.5, WIDTH - 30, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdedede);
        [view addSubview:line];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 250, WIDTH, 60)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingfangSC-Regular" size:17];
    [btn setBackgroundColor:TCUIColorFromRGB(0xe13916)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"icancel"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
    
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 100){
        self.clickDetailBlcok(@"1");
    }else if (sender.tag == 101){
        self.clickEditBlock(@"1");
    }else{
        self.clickForwardBlock(@"1");
    }
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

///设置圆角[左上、右上角]

//- (void)setCircular{
//
//UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15,15)];
//
////创建 layer
//
//CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//
//maskLayer.frame = self.bounds;
//
////赋值
//
//maskLayer.path = maskPath.CGPath;
//
//self.layer.mask = maskLayer;
//}


@end
