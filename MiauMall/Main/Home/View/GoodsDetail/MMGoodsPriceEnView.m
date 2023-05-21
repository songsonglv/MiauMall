//
//  MMGoodsPriceEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import "MMGoodsPriceEnView.h"

@interface MMGoodsPriceEnView ()
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@end

@implementation MMGoodsPriceEnView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *tiLa = [UILabel publicLab:@"Sale price" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    tiLa.frame = CGRectMake(16, 0, WIDTH - 32, 16);
    [self addSubview:tiLa];
    
    NSString *str;
    float price = [self.model.proInfo.ActivePrice floatValue];
    
    str = price > 0 ? self.model.proInfo.ActivePriceShow : self.model.proInfo.PriceShow;
    
    UILabel *priceLa = [UILabel publicLab:str textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:30 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = WIDTH - 100;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:priceLa];
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(28);
            make.height.mas_equalTo(30);
    }];
    
    UILabel *oldLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x969696) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    oldLa.preferredMaxLayoutWidth = WIDTH - 200;
    [oldLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
           
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.model.proInfo.OldPriceShow attributes:attribtDic];
    oldLa.attributedText = attribtStr;
    [self addSubview:oldLa];
    
    [oldLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceLa.mas_right).offset(15);
            make.top.mas_equalTo(38);
            make.height.mas_equalTo(16);
    }];
}

@end
