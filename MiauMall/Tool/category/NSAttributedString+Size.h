//
//  NSAttributedString+Size.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Size)
+ (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
