//
//  UILabel+ZTLabel.h
//  zhuantou
//
//  Created by 吕松松 on 2019/4/24.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZTLabel)
+ (UILabel *)publicLab:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment fontWithName:(NSString *)fontWithName size:(CGFloat)size numberOfLines:(NSInteger)numberOfLines;
@end

NS_ASSUME_NONNULL_END
