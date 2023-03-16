//
//  MMDetailImgView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/19.
//  商品详情图片view

#import "MMDetailImgView.h"

@interface MMDetailImgView ()
@property (nonatomic, strong) NSMutableArray *imageHArr;//图片高度数组
@end

@implementation MMDetailImgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
}

-(void)setImageArr:(NSArray *)imageArr{
    KweakSelf(self);
    _imageArr = imageArr;
   
    
}

-(void)setImaHarr:(NSArray *)imaHarr{
    _imaHarr = imaHarr;
    
    CGFloat hei = 0;
    for (int i = 0; i < self.imageArr.count; i++) {
        NSString *url = self.imageArr[i];
        NSString *heiStr = _imaHarr[i];
        CGFloat h1 = [heiStr floatValue];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, hei, self.width, h1)];
        [image sd_setImageWithURL:[NSURL URLWithString:url]];
        [self addSubview:image];
        hei += h1;
    }
}

@end
