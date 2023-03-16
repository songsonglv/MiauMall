//
//  MMTitleView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import "MMTitleView.h"

@implementation MMTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        UILabel *lable = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];;
        self.titleLa = lable;
        [self addSubview:lable];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"icon_back_black"] forState:(UIControlStateNormal)];
        [btn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [self addSubview:btn];
        self.returnBt = btn;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [self addSubview:line];
        
        self.line = line;
        
    }
    return self;
}

//重写layoutSubviews方法 为子控件设置frame
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    [self.returnBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];
    
    [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(16);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(43.5);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(0.5);
    }];
}
@end
