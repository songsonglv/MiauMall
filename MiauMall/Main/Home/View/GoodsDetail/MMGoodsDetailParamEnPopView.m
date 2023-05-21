//
//  MMGoodsDetailParamEnPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import "MMGoodsDetailParamEnPopView.h"

@interface MMGoodsDetailParamEnPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MMGoodsProInfoModel *moreModel;
@property (nonatomic, assign) float hei;
@end

@implementation MMGoodsDetailParamEnPopView


-(instancetype)initWithFrame:(CGRect)frame andMoreInfo:(nonnull MMGoodsProInfoModel *)moreModel andHei:(float)hei{
    if (self = [super initWithFrame:frame]) {
        self.hei = hei;
        self.moreModel = moreModel;
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
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - self.hei, WIDTH,self.hei)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self setCircular:self.contentView andCir1:(UIRectCornerTopLeft) andCir2:(UIRectCornerTopRight)];
    [self.view addSubview:self.contentView];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
    
    UILabel *tiLa = [UILabel publicLab:@"Product Information" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    tiLa.frame = CGRectMake(0, 34, WIDTH, 16);
    [self.contentView addSubview:tiLa];
    
    float hei = 65;
    
    NSArray *arr = [self.moreModel.GuideParam componentsSeparatedByString:@"\r\n"];
    for (int i = 0; i < arr.count; i++) {
        NSString *str1 = arr[i];
        
        str1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSRange range = [str1 rangeOfString:@"|"];
        NSArray *array;
        if(range.location != NSNotFound){
            NSString *str2 = [str1 substringToIndex:range.location];
            NSString *str3 = [str1 substringFromIndex:range.location + 1];
            array = @[str2,str3];
        }
        
        
        CGSize size = [NSString sizeWithText:array[0] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(120,MAXFLOAT)];
        CGSize size1 = [NSString sizeWithText:array[1] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(WIDTH - 185,MAXFLOAT)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 60)];
        if(size.height < size1.height){
            view.height = size1.height + 44;
        }else{
            view.height = size.height + 44;
        }
        [self.contentView addSubview:view];
        
        UILabel *lab1 = [UILabel publicLab:array[0] textColor:TCUIColorFromRGB(0x525252) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab1.frame = CGRectMake(22, 22, 120, size.height);
        [view addSubview:lab1];
        
        UILabel *lab2 = [UILabel publicLab:array[1] textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab2.frame = CGRectMake(160, 22, WIDTH - 185, size1.height);
        [view addSubview:lab2];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, view.height - 0.5, WIDTH - 28, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe4e4e4);
        [view addSubview:line];
        
        hei += view.height;
    }
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:TCUIColorFromRGB(0x1d1d1d)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 7.5;
    [btn setTitle:@"Close" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.bottom.mas_equalTo(-24);
            make.width.mas_equalTo(WIDTH - 36);
            make.height.mas_equalTo(48);
    }];
    
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
//        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
//        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

///设置圆角[左上、右上角]
- (void)setCircular:(UIView *)view andCir1:(UIRectCorner)cir1 andCir2:(UIRectCorner)cir2{

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cir1 | cir2 cornerRadii:CGSizeMake(17.5,17.5)];

//创建 layer
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = view.bounds;
//赋值
maskLayer.path = maskPath.CGPath;
view.layer.mask = maskLayer;
}

@end
