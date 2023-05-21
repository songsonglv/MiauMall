//
//  MMInvitationCodePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//  我的邀请码弹窗

#import "MMInvitationCodePopView.h"

@interface MMInvitationCodePopView ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MMMineMainDataModel *model;

@end

@implementation MMInvitationCodePopView

-(instancetype)initWithFrame:(CGRect)frame andModel:(nonnull MMMineMainDataModel *)model{
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
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 250, WIDTH, 250)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    
    UIButton *closeBt = [[UIButton alloc]init];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    [closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(13);
            make.width.height.mas_equalTo(18);
    }];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"yqCode"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 30, WIDTH, 15);
    [self.bgView addSubview:titleLa];
    
    UILabel *codeLa = [UILabel publicLab:[NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"myCode"],self.model.memberInfo.RegCode] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    codeLa.frame = CGRectMake(0, 100, WIDTH, 15);
    [self.bgView addSubview:codeLa];
    
    UIButton *shareBt = [[UIButton alloc]initWithFrame:CGRectMake(18, 182, WIDTH - 36, 36)];
    shareBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    shareBt.layer.masksToBounds = YES;
    shareBt.layer.cornerRadius = 18;
    [shareBt setTitle:[UserDefaultLocationDic valueForKey:@"shareMyCode"] forState:(UIControlStateNormal)];
    [shareBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    shareBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [shareBt addTarget:self action:@selector(clickShare) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:shareBt];
}

-(void)clickShare{
    self.clickShareBlock(self.model.memberInfo.RegCode);
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
