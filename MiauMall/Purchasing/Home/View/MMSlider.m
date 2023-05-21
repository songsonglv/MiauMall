//
//  MMSlider.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/26.
//

#import "MMSlider.h"

@implementation MMSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 13);
}
@end
