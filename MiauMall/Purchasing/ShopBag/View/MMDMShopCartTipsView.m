//
//  MMDMShopCartTipsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import "MMDMShopCartTipsView.h"

@interface MMDMShopCartTipsView ()
@property (nonatomic, strong) UILabel *contentLa;
@end

@implementation MMDMShopCartTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    self.backgroundColor = TCUIColorFromRGB(0xe9ebec);
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH - 24;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:lab];
    self.contentLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(WIDTH - 24);
    }];
}


-(void)setTips:(NSString *)tips{
    _tips = tips;
    self.contentLa.text = _tips;
}

@end
