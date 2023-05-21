//
//  MMShipMentPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/21.
//

#import "MMShipMentPopView.h"

@interface MMShipMentPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *content;
@end

@implementation MMShipMentPopView

-(instancetype)initWithFrame:(CGRect)frame andContent:(NSString *)contStr{
    if(self = [super initWithFrame:frame]){
        self.content = contStr;
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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, HEIGHT + (HEIGHT - 400)/2, WIDTH - 20, 400)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(20, 10, WIDTH - 40, 300)];
    self.content = [NSString stringWithFormat:@"%@<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>",self.content];
                   
    [webView loadHTMLString:self.content baseURL:nil];
    [self.bgView addSubview:webView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 64)/2, CGRectGetMaxY(webView.frame) + 18, 44, 24)];
    btn.backgroundColor = redColor2;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 12;
    [btn setTitle:@"关闭" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
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
        self.bgView.centerY =self.bgView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}
@end
