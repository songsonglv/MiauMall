//
//  UILabel+ZTLabel.m
//  zhuantou
//
//  Created by 吕松松 on 2019/4/24.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import "UILabel+ZTLabel.h"

@implementation UILabel (ZTLabel)
+ (UILabel *)publicLab:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment fontWithName:(NSString *)fontWithName size:(CGFloat)size numberOfLines:(NSInteger)numberOfLines{
    
    UILabel *publicLab = [UILabel new];
    //NSLog(@"---%@", text);
    publicLab.text = text;
    publicLab.font = [UIFont fontWithName:fontWithName size:size];
    publicLab.textAlignment = textAlignment;
    publicLab.textColor = textColor;
    publicLab.numberOfLines = numberOfLines;
    
    return publicLab;
}
@end
