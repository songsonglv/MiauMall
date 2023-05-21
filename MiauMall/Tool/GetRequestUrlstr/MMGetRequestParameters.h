//
//  MMGetRequestParameters.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGetRequestParameters : NSObject


+(NSString *)getURLForInterfaceStringDefine:(NSString *)url
                                     params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
