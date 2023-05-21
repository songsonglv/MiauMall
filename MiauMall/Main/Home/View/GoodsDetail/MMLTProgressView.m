//
//  MMLTProgressView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/13.
//  乐天直购流程view

#import "MMLTProgressView.h"

@interface MMLTProgressView ()
@property (nonatomic, strong) UIImageView *proImage;
@end

@implementation MMLTProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}


-(void)setUI{
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"dmBrandLine"] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    lab.frame = CGRectMake(20, 20, WIDTH - 60, 15);
    [self addSubview:lab];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), WIDTH - 20, 90)];
    [self addSubview:bgImage];
    self.proImage = bgImage;
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
}

@end
