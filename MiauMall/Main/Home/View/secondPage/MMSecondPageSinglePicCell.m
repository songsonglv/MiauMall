//
//  MMSecondPageSinglePicCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import "MMSecondPageSinglePicCell.h"
@interface MMSecondPageSinglePicCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation MMSecondPageSinglePicCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    bgImage.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImage];
    
    self.bgImage = bgImage;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_model.cont.image]];
}

-(void)clickBtn{
    self.TapIadvBlock(self.model.cont.link2);
}

@end
