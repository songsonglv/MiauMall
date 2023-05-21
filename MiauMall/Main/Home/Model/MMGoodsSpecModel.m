//
//  MMGoodsSpecModel.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//

#import "MMGoodsSpecModel.h"

@implementation MMGoodsSpecModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id"
             };
}
@end
