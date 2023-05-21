//
//  MMOrderRefundPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/15.
//

#import "MMOrderRefundPopView.h"

@interface MMOrderRefundPopView ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MMOrderRefundPopView

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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(38,  HEIGHT + (HEIGHT - 300)/2, WIDTH - 76, 300)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3f3f3f) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, WIDTH - 76, 16);
    [self.bgView addSubview:titleLa];
    self.titleLa = titleLa;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLa.frame) + 12, WIDTH - 100, 0.5)];
    line.backgroundColor = lineColor2;
    [self.bgView addSubview:line];
    
    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 66, WIDTH - 76, 180)];
    self.webView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
//    self.webView.scrollView.scrollEnabled = NO;
    [self.bgView addSubview:self.webView];
    
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake((self.bgView.width - 215)/2, 260, 100, 30)];
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"icancel"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = redColor2.CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancleBt.frame) + 15, 260, 100, 30)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"icontinue"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 15;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
}

-(void)setModel:(MMRefundTipsModel *)model{
    _model = model;
    self.titleLa.text = _model.Name;
    NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
   //*{font-size:10px}.tatle{font-size:15px}
    NSString *str = [NSString stringWithFormat:@"%@%@",_model.Conts,s];
    [self.webView loadHTMLString:str baseURL:nil];
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
