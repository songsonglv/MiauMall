//
//  GKCycleScrollViewCell.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKCycleScrollViewCell.h"
@interface GKCycleScrollViewCell ()
@property (nonatomic, strong) UILabel       *lab;
@end

@implementation GKCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.coverView];
        [self.imageView addSubview:self.lab];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    !self.didCellClick ? : self.didCellClick(self.tag);
}

- (void)setupCellFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.imageView.frame, frame)) return;
    
    self.lab.hidden = YES;
    self.imageView.frame = frame;
    self.coverView.frame = frame;
    self.lab.frame = CGRectMake(0, frame.size.height - 20, frame.size.width, 20);
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

-(UILabel *)lab{
    if(!_lab){
        _lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        _lab.backgroundColor = TCUIColorFromRGB(0xf3f2f1);
    }
    return _lab;
}


-(void)setCellText:(NSString *)cellText{
    _cellText = cellText;
    self.lab.text = _cellText;
    self.lab.hidden = [_cellText isEmpty] ? YES : NO;
}
@end
