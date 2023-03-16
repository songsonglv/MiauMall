//
//  MMShopCarModel.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/27.
//

#import "MMShopCarModel.h"

@implementation MMShopCarModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
        @"Num1":@"_num",@"Total1":@"_total",@"Intetotal1":@"_intetotal",@"Packprice1":@"_packprice"
             };
}
@end
