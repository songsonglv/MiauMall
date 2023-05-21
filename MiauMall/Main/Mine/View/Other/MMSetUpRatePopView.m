//
//  MMSetUpRatePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import "MMSetUpRatePopView.h"

@interface MMSetUpRatePopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *rateLa;
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, assign) NSInteger maxRate;
@end

@implementation MMSetUpRatePopView

-(instancetype)initWithFrame:(CGRect)frame andMaxRate:(nonnull NSString *)maxRate{
    if (self = [super initWithFrame:frame]) {
        self.maxRate = [maxRate integerValue];
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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 275)/2, HEIGHT + (HEIGHT - 208)/2, 275, 208)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    
//    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(260, 20, 14, 14)];
//    [closeBt setBackgroundImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
//    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.bgView addSubview:closeBt];
//
    UILabel *titleLa = [UILabel publicLab:@"设置佣金比例" textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 21, 275, 18);
    [self.bgView addSubview:titleLa];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TCUIColorFromRGB(0xd9d9d9);
    [self.bgView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42);
            make.top.mas_equalTo(54);
            make.right.mas_equalTo(-52);
            make.height.mas_equalTo(0.5);
    }];
    
    UIButton *subBtn = [[UIButton alloc]init];
    [subBtn setImage:[UIImage imageNamed:@"sub_icon_black"] forState:(UIControlStateNormal)];
    [subBtn addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:subBtn];
    
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(75);
            make.top.mas_equalTo(80);
            make.width.height.mas_equalTo(19);
    }];
    
    UILabel *rateLa = [UILabel publicLab:@"0%" textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:28 numberOfLines:0];
    rateLa.preferredMaxLayoutWidth = 100;
    [rateLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.bgView addSubview:rateLa];
    self.rateLa = rateLa;
    
    [rateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.top.mas_equalTo(78);
            make.height.mas_equalTo(24);
    }];
    
    UILabel *textLa = [UILabel publicLab:[NSString stringWithFormat:@"最大分配佣金为%ld%%",self.maxRate] textColor:TCUIColorFromRGB(0xc6c6c6) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    [self.bgView addSubview:textLa];
    
    [textLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(116);
            make.width.mas_equalTo(275);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *addBt = [[UIButton alloc]init];
    [addBt setImage:[UIImage imageNamed:@"add_icon_black"] forState:(UIControlStateNormal)];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:addBt];
    
    [addBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-75);
            make.top.mas_equalTo(80);
            make.width.height.mas_equalTo(19);
    }];
    
    UIButton *sureBt = [[UIButton alloc]init];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"withdraw_bg"] forState:(UIControlStateNormal)];
    [sureBt setTitle:@"确认" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
    [sureBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(52);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(24);
    }];
    
    UIButton *cancleBt = [[UIButton alloc]init];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xeaeaea)];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 12;
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"icancel"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:textBlackColor2 forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-52);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(24);
    }];
    
}

-(void)setModel:(MMMyTeamListModel *)model{
    _model = model;
    self.rateLa.text = [NSString stringWithFormat:@"%@%%",_model.YongRate];
    NSInteger rate = [_model.YongRate integerValue];
    self.rate = rate;
}

-(void)clickSub{
    if(self.rate > 0){
        self.rate--;
        self.rateLa.text = [NSString stringWithFormat:@"%ld%%",self.rate];
    }
}

-(void)clickAdd{
    if(self.rate < self.maxRate){
        self.rate++;
        self.rateLa.text = [NSString stringWithFormat:@"%ld%%",self.rate];
    }else{
        [ZTProgressHUD showMessage:@"佣金比例不可超过最大分配比例"];
    }
}

-(void)clickCancle{
    [self hideView];
}

-(void)clickSure{
    self.setUpRateBlcok([NSString stringWithFormat:@"%ld",self.rate]);
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
