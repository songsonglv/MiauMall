//
//  MMPayTipsPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/21.
//

#import "MMPayTipsPopView.h"

@interface MMPayTipsPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textV;
@end

@implementation MMPayTipsPopView

-(instancetype)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]){
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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 256)/2, HEIGHT + (HEIGHT - 262)/2, 256, 262)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"itips"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 26, 256, 17);
    [self.bgView addSubview:titleLa];
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLa.frame) + 20, 236, 112)];
    textV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    textV.textColor = TCUIColorFromRGB(0x383838);
    textV.textAlignment = NSTextAlignmentLeft;
    textV.editable = NO;
    [self.bgView addSubview:textV];
    self.textV = textV;
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(73, CGRectGetMaxY(textV.frame) + 20, 110, 34)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 17;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

-(void)clickSure{
    [self hideView];
    self.returnTipBlcok(@"1");
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.textV.text = _content;
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
