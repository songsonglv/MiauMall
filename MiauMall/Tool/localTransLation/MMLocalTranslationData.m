//
//  MMLocalTranslationData.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/31.
//

#import "MMLocalTranslationData.h"

@interface MMLocalTranslationData ()
{
    NSDictionary *dic;
}
@end

@implementation MMLocalTranslationData
+(NSDictionary *)initLanguage:(NSString *)language{
    if ([language isEqualToString:@"0"]){
        language = @"zh_CN";
    }else if ([language isEqualToString:@"1"]){
        language = @"en";
    }else if ([language isEqualToString:@"2"]){
        language = @"ja_JP";
    }else if ([language isEqualToString:@"3"]){
        language = @"zh_TW";
    }else{
        language = @"zh_CN";
    }
    //==Json文件路径
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:language ofType:@"json"];

    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    //==JsonObject
    NSError *error;
    id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
   
    if ([JsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = [(NSDictionary *)JsonObject copy];
        return dic;
    }else {
        NSAssert(0, @"language Json Error!");
    }
    return nil;
    
    
}
@end
