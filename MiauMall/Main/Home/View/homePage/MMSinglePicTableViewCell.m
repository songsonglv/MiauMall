//
//  MMSinglePicTableViewCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//  装修模块下单图cell iadvimg

#import "MMSinglePicTableViewCell.h"

@implementation MMSinglePicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
