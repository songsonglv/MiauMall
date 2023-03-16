//
//  MYNumLabel.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/9/30.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "MYNumLabel.h"

@implementation MYNumLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)setCount:(NSString *)count{
    _count = count;
    [self setUI];
}

-(void)setUI{
    
    self.text = self.count;
     self.textColor = TCUIColorFromRGB(0xffffff);
    
     self.layer.borderWidth = 1;
     self.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
     self.textAlignment = 1;
     self.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
     if (self.count.length >= 3) {
         self.width = 26;
         self.text = @"99+";
     }
     if (self.count.length == 2) {
         self.width = 20;
     }
     
     if (self.count.length == 1) {
         self.width = 14;
     }
     
     self.layer.cornerRadius = 7;
     self.layer.masksToBounds = YES;
}


@end
