//
//  NSString+Dictionary.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Dictionary)
+ (NSDictionary *)getUrlParameterWithUrl:(NSURL *)url;

+ (id)getJsonDataJsonname;

@end

NS_ASSUME_NONNULL_END
