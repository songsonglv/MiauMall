//
//  MMSharePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/26.
//

#import "MMSharePopView.h"
@interface MMSharePopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MMSharePopView

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
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 300, WIDTH, 35)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 17.5;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 285, WIDTH, 285)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UILabel *tiLa = [UILabel publicLab:@"分享到" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Mdeium" size:15 numberOfLines:0];
    [self.contentView addSubview:tiLa];
    
    [tiLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-100);
            make.height.mas_equalTo(15);
    }];
    
    NSArray *arr = @[@"微信好友",@"朋友圈",@"新浪微博",@"生成海报",@"投诉",@"我的足迹"];
    NSArray *imgArr = @[@"wx_share_icon",@"wx_friend_icon",@"sina_icon",@"poster_icon",@"complaint_icon",@"footprint_icon"];
    CGFloat wid = WIDTH/3;
    for (int i = 0; i < arr.count; i++) {
        NSInteger j = i/3;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * (i % 3), 96 * j + 60, wid, 74)];
        [self.contentView addSubview:view];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(view);
                    make.top.mas_equalTo(0);
                    make.width.height.mas_equalTo(50);
        }];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(60);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(14);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundColor:UIColor.clearColor];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        btn.frame = CGRectMake(0, 0, wid, 74);
        [view addSubview:btn];
    }
    
}

-(void)clickBtn:(UIButton *)sender{
    [self hideView];
    self.tapNumBlock(sender.tag - 100);
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
