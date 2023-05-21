//
//  MMVersionUpdatePopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/21.
//

#import "MMVersionUpdatePopView.h"

@interface MMVersionUpdatePopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MMVersionModel *model;
@end

@implementation MMVersionUpdatePopView

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMVersionModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 260)/2, HEIGHT +  (HEIGHT - 308)/2, 260, 258)];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.bgView];
    
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake((self.bgView.width - 75)/2, 20, 75, 75)];
    imageIcon.image = [UIImage imageNamed:@"x_logo"];
    imageIcon.layer.masksToBounds = YES;
    imageIcon.layer.cornerRadius = 12;
    [self.bgView addSubview:imageIcon];
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"bbgx"] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingfangSC-SemiBold" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(0, CGRectGetMaxY(imageIcon.frame) + 16, 260, 16);
    [self.bgView addSubview:lab1];
    
    CGSize size = [NSString sizeWithText:self.model.VersionContent font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(240,MAXFLOAT)];
    
    UILabel *lab2 = [UILabel publicLab:self.model.VersionContent textColor:TCUIColorFromRGB(0x292929) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab2.frame = CGRectMake(10, CGRectGetMaxY(lab1.frame) + 16, 240, size.height);
    [self.bgView addSubview:lab2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(lab2.frame) + 16, 244, 0.5)];
    line.backgroundColor = lineColor;
    [self.bgView addSubview:line];
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 16, 130, 20)];
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"sgzs"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:redColor2 forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [cancleBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    UIButton *goUploadBt = [[UIButton alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(line.frame) + 16, 130, 20)];
    [goUploadBt setTitle:[UserDefaultLocationDic valueForKey:@"ljgx"] forState:(UIControlStateNormal)];
    [goUploadBt setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
    goUploadBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [goUploadBt addTarget:self action:@selector(goUpload) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:goUploadBt];
    
    if([self.model.IsUpdateForce isEqualToString:@"1"]){
        cancleBt.hidden = YES;
        goUploadBt.x = 0;
        goUploadBt.width = 260;
    }
    
}


-(void)goUpload{
    self.clickGoBlock(@"1");
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY = self.bgView.centerY + HEIGHT;
        
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
