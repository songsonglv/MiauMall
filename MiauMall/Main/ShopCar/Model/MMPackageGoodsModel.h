//
//  MMPackageGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPackageGoodsModel : NSObject
@property (nonatomic, copy) NSString *ColumnID;
@property (nonatomic, copy) NSString *IsFreeShip;
@property (nonatomic, copy) NSString *IsTemporary;
@property (nonatomic, copy) NSString *LimtOrderBuy;
@property (nonatomic, copy) NSString *OptionalID;
@property (nonatomic, copy) NSString *OptionalName;
@property (nonatomic, copy) NSString *ProductSign;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *aname;
@property (nonatomic, copy) NSString *coupondmoney;
@property (nonatomic, copy) NSString *discountdmoney;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *integdmoney;
@property (nonatomic, copy) NSString *intsingle;//
@property (nonatomic, copy) NSString *inttotal;
@property (nonatomic, copy) NSString *isfullgift;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *moneyrmb;
@property (nonatomic, copy) NSString *moneyshow;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pricermb;
@property (nonatomic, copy) NSString *priceshow;
@property (nonatomic, copy) NSString *renxuandmoney;
@property (nonatomic, copy) NSString *renxuansalesmoney;
@property (nonatomic, copy) NSString *salesmoney;
@property (nonatomic, copy) NSString *salesmoneyshow;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSString *weight;

@end

NS_ASSUME_NONNULL_END
