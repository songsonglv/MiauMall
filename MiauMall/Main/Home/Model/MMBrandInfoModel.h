//
//  MMBrandInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
// 品牌信息 主要是店铺内用到

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBrandInfoModel : NSObject
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Keyword;
@property (nonatomic, copy) NSString *SharePicture;
@property (nonatomic, copy) NSString *LogoPicture;
@property (nonatomic, copy) NSString *Name3;
@property (nonatomic, copy) NSString *Name2;
@property (nonatomic, copy) NSString *BrandNum;//在售商品数量
@property (nonatomic, copy) NSString *ShortName;//店铺内品牌介绍
@property (nonatomic, copy) NSString *BackPicture;//头部背景图
@property (nonatomic, copy) NSString *Name;//店铺名
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
