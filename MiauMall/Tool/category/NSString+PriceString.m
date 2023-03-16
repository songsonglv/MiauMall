//
//  NSString+PriceString.m
//  MYShoppingAllowance
//
//  Created by 吕松松 on 2020/8/29.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "NSString+PriceString.h"

//#import <AppKit/AppKit.h>


@implementation NSString (PriceString)

+(NSString *)priceString:(NSString *)string{
    double conversionValue = (double)[string floatValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf",conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
