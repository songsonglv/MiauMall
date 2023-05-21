//
//  MMShareOrderPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import "MMShareOrderPopView.h"

@interface MMShareOrderPopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation MMShareOrderPopView

-(instancetype)initWithFrame:(CGRect)frame andUrl:(nonnull NSString *)url andHei:(CGFloat)hei{
    if (self = [super initWithFrame:frame]) {
        self.imageUrl = url;
        self.hei = hei;
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
    
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(24, HEIGHT + (HEIGHT - self.hei - 46)/2, WIDTH - 48, self.hei + 46)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"itips"] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 20, WIDTH - 48, 16);
    [self.bgView addSubview:titleLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLa.frame) + 8, WIDTH - 78, 0.5)];
    line.backgroundColor = lineColor;
    [self.bgView addSubview:line];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 10, WIDTH - 48, self.hei)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [self.bgView addSubview:image];
    
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
