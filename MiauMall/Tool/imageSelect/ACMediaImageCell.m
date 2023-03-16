//
//  ACMediaImageCell.m
//
//  Created by caoyq on 16/12/2.
//  Copyright © 2016年 SnSoft. All rights reserved.
//

#import "ACMediaImageCell.h"
#import "ACMediaFrameConst.h"

@interface ACMediaImageCell ()

@end

@implementation ACMediaImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)_setupViews {
    _icon = [[UIImageView alloc] init];
    _icon.clipsToBounds = YES;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 4;
    [self.contentView addSubview:_icon];

    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundColor:TCUIColorFromRGB(0x000000)];
    _deleteButton.alpha = 0.5;
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = 7.5;
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"close_white_icon"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ACMediaFrame.bundle/ShowVideo"]];
    [self.contentView addSubview:_videoImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height);
    _deleteButton.frame = CGRectMake(self.bounds.size.width - 17.5, 2.5, ACMediaDeleteButtonWidth, ACMediaDeleteButtonWidth);
    _videoImageView.frame = CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2);
    CGFloat wid = (WIDTH - 64)/3;
//    _icon.frame = CGRectMake(0, 0, wid,wid);
    if([self.isComment isEqualToString:@"0"]){
        _icon.frame = CGRectMake(0, 0, 81,81);
    }else if ([self.isComment isEqualToString:@"3"]){
        _icon.frame = CGRectMake(0, 0, 92,92);
    }

}

-(void)setIsComment:(NSString *)isComment{
    _isComment = isComment;
}

- (void)clickDeleteButton {
    !_ACMediaClickDeleteButton ?  : _ACMediaClickDeleteButton();
}

@end
