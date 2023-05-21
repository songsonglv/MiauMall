//
//  MMGoodsNameEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import "MMGoodsNameEnView.h"

@interface MMGoodsNameEnView ()
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@end

@implementation MMGoodsNameEnView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)model{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *nameLa = [UILabel publicLab:self.model.proInfo.Name textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:23 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 30;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(WIDTH - 30);
    }];
    
    if(self.model.proInfo.ShortName.length > 0){
        UILabel *shortLa = [UILabel publicLab:self.model.proInfo.ShortName textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
        shortLa.preferredMaxLayoutWidth = WIDTH - 30;
        [shortLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [self addSubview:shortLa];
        
        [shortLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(nameLa.mas_bottom).offset(18);
                make.width.mas_equalTo(WIDTH - 30);
        }];
    }
    
    
}

@end
