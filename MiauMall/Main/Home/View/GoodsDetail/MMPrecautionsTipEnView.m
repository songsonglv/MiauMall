//
//  MMPrecautionsTipEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/21.
//

#import "MMPrecautionsTipEnView.h"

@interface MMPrecautionsTipEnView ()
@property (nonatomic, strong) MMGoodsDetailMainModel *model;

@end

@implementation MMPrecautionsTipEnView

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMGoodsDetailMainModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    CGSize size = [NSString sizeWithText:self.model.proInfo.Precautions font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 36,MAXFLOAT)];
    UILabel *lab = [UILabel publicLab:self.model.proInfo.Precautions textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab.frame = CGRectMake(18, 20, WIDTH - 36, size.height);
    [self addSubview:lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(lab.frame) + 19.5, WIDTH - 28, 0.5)];
    line.backgroundColor = lineColor2;
    [self addSubview:line];
}
@end
