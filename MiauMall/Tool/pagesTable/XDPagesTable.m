//
//  XDPagesTable.m
//  XDPagesView
//
//  Created by 谢兴达 on 2020/2/13.
//  Copyright © 2020 xie. All rights reserved.
//

#import "XDPagesTable.h"

@interface XDPagesTable ()
@property (nonatomic,assign) CGFloat lastOffset;
@end

@implementation XDPagesTable

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(void)setCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
    self.lastOffset = self.contentOffset.y;
}

//-(void)setGesturePublic:(BOOL)gesturePublic{
//    _gesturePublic = gesturePublic;
//}
//
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return _gesturePublic;
}

- (void)initSubViews{
    
}

- (void)masonryLayout{
    
}
@end
