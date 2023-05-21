//
//  MMLocalTransLation.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/31.
//

#import "MMLocalTransLation.h"



@implementation MMLocalTransLation
{
    NSDictionary *tempLan;
}
static MMLocalTransLation *_instance = nil;

+(MMLocalTransLation *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}


-(NSString *)ttObjectForKey:(NSString *)string
{
    NSString *str = (NSString *)[tempLan objectForKey:string];
    return str;
}


-(instancetype)init
{
    self =[super init];
    if (self) {
        NSArray *languageArray  =  [NSLocale preferredLanguages];
        NSString *language      =  [languageArray firstObject];
        NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
        if(!lang){
            if ([language hasPrefix:@"zh"]){
                language = @"zh_CN";
            }else{
                language = @"en";
            }
        }else if ([lang isEqualToString:@"0"]){
            language = @"zh_CN";
        }else if ([lang isEqualToString:@"1"]){
            language = @"en";
        }else if ([lang isEqualToString:@"2"]){
            language = @"ja_JP";
        }else if ([lang isEqualToString:@"3"]){
            language = @"zh_TW";
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
            tempLan = [(NSDictionary *)JsonObject copy];
            [[NSUserDefaults standardUserDefaults] setValue:tempLan forKey:@"LocalTranslation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            NSAssert(0, @"language Json Error!");
        }
    }
    return self;
}
@end

