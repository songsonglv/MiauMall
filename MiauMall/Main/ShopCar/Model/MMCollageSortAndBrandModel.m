//
//  MMCollageSortAndBrandModel.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/23.
//

#import "MMCollageSortAndBrandModel.h"

@implementation MMCollageSortAndBrandModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id"
             };
}
@end
