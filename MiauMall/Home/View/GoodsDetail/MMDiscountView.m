//
//  MMDiscountView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//  优惠弹窗

#import "MMDiscountView.h"

@interface MMDiscountView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@end

@implementation MMDiscountView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
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
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 460, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 445, WIDTH, 445)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UILabel *titleLa = [UILabel publicLab:@"优惠" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(100, 15, WIDTH - 200, 15);
    [self.contentView addSubview:titleLa];
    
    NSArray *arr = @[@"蜜豆",@"折扣"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 24 + 40 * i, WIDTH, 40)];
        [self.contentView addSubview:view];
        
        UILabel *lab1 = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x977447) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        lab1.backgroundColor = TCUIColorFromRGB(0xf2eae1);
        lab1.layer.masksToBounds = YES;
        lab1.layer.cornerRadius = 2.5;
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(32);
                    make.height.mas_equalTo(15);
        }];
        
        UILabel *lab2 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab2.preferredMaxLayoutWidth = WIDTH - 66;
        [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab2];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab1.mas_right).offset(12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 39.5, WIDTH - 24, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [view addSubview:line];
        
        if(i == 0){
            lab2.text = self.model.proInfo.inte;
            
            UIImageView *rightIcon = [[UIImageView alloc]init];
            rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
            [view addSubview:rightIcon];
            
            [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(-18);
                            make.centerY.mas_equalTo(view);
                            make.width.mas_equalTo(4);
                            make.height.mas_equalTo(8);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundColor:UIColor.clearColor];
            [btn addTarget:self action:@selector(clickJump) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.right.bottom.mas_equalTo(0);
            }];
        }else{
            lab2.text = self.model.proInfo.DiscountTips;
        }
    }
    
    UILabel *lab = [UILabel publicLab:@"优惠券" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    lab.frame = CGRectMake(18, CGRectGetMaxY(titleLa.frame) + 124, 100, 12);
    [self.contentView addSubview:lab];
}

-(void)clickJump{
    self.jumpTapBlock(@"1");
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
