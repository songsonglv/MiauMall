//
//  NSAttributedString+Size.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/9.
//

#import "NSAttributedString+Size.h"

@implementation NSAttributedString (Size)

+ (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width{
    return  [self textViewHeightForAttributedString:string withWidth:width];
}

- (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width
{
    return [self rectForAttributedString:string withSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGSize)rectForAttributedString:(NSAttributedString *)string withSize:(CGSize)theSize
{
    if (!string || CGSizeEqualToSize(theSize, CGSizeZero)) {
        return CGSizeZero;
    }

    // setup TextKit stack
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:theSize];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    // query for size
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];

    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}


@end
