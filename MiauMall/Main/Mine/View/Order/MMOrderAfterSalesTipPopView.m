//
//  MMOrderAfterSalesTipPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//

#import "MMOrderAfterSalesTipPopView.h"
@interface MMOrderAfterSalesTipPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *cancleStr;
@property (nonatomic, strong) NSString *goonStr;
@end

@implementation MMOrderAfterSalesTipPopView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(nonnull NSString *)titleStr andConten:(nonnull NSString *)contentStr andCancle:(nonnull NSString *)cancleStr andGoon:(nonnull NSString *)goonStr{
    if(self = [super initWithFrame:frame]){
        self.titleStr = titleStr;
        self.contentStr = contentStr;
        self.cancleStr = cancleStr;
        self.goonStr = goonStr;
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(38,  HEIGHT + (HEIGHT - 250)/2, WIDTH - 76, 250)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *titleLa = [UILabel publicLab:self.titleStr textColor:TCUIColorFromRGB(0x3f3f3f) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, WIDTH - 76, 16);
    [self.bgView addSubview:titleLa];
    
    UILabel *contLa = [UILabel publicLab:self.contentStr textColor:TCUIColorFromRGB(0x5d5d5d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    contLa.frame = CGRectMake(20, CGRectGetMaxY(titleLa.frame) + 20, self.bgView.width - 40, 30);
    [contLa sizeToFit];
    [self.bgView addSubview:contLa];
    
    [contLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(self.contentStr).textColor(TCUIColorFromRGB(0x5d5d5d)).font([UIFont fontWithName:@"PingFangSC-Regular" size:13]);
        confer.text(@">>").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Regular" size:13]).tapActionByLable(@"1");
    }];
    [contLa rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        weakself.tapQuesttBlock(@"1");
        [weakself hideView];
    }];
    
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake((self.bgView.width - 215)/2, CGRectGetMaxY(contLa.frame) + 40, 100, 30)];
    [cancleBt setTitle:self.cancleStr forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = redColor2.CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancleBt.frame) + 15, CGRectGetMaxY(contLa.frame) + 40, 100, 30)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:self.goonStr forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 15;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

-(void)clickCancle{
    [self hideView];
}

-(void)clickSure{
    self.tapGoonBlock(@"1");
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


@end
