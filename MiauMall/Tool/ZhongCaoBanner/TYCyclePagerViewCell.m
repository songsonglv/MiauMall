//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addLabel];
    }
    return self;
}


- (void)addLabel {
    
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 4;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageV];
    self.imageView = imageV;
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = TCUIColorFromRGB(0xf3f2f1);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    [self addSubview:label];
    _label = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
//    _label.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
}

-(void)setModel:(MMZhongCaoBeforModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
    self.label.text = _model.Name;
    
    
}

@end
