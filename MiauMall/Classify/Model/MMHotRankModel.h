//
//  MMHotRankModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/10.
//

#import <Foundation/Foundation.h>
#import "MMHotGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMHotRankModel : NSObject
@property (nonatomic, copy) NSString *BackColor;
@property (nonatomic, copy) NSString *BackPicture;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *SharePicture;
@property (nonatomic, copy) NSString *Shipping48;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) MMHotGoodsModel *num0;
@property (nonatomic, strong) MMHotGoodsModel *num1;
@property (nonatomic, strong) MMHotGoodsModel *num2;
@property (nonatomic, strong) MMHotGoodsModel *num3;
@property (nonatomic, strong) MMHotGoodsModel *num4;
@property (nonatomic, strong) MMHotGoodsModel *num5;
@property (nonatomic, strong) MMHotGoodsModel *num6;
@property (nonatomic, strong) MMHotGoodsModel *num7;
@property (nonatomic, strong) MMHotGoodsModel *num8;
@property (nonatomic, strong) MMHotGoodsModel *num9;
@property (nonatomic, strong) MMHotGoodsModel *num10;
@end

NS_ASSUME_NONNULL_END
