//
//  MMPartnerHotSaleGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerHotSaleGoodsModel : NSObject
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *ColumnID;
@property (nonatomic, copy)NSString *IsOnline;
@property (nonatomic, copy)NSString *LimitType;
@property (nonatomic, copy)NSString *ItemID;
@property (nonatomic, copy)NSString *Name;
@property (nonatomic, copy)NSString *Price;
@property (nonatomic, copy)NSString *Picture;
@property (nonatomic, copy)NSString *OrderCount;
@end

NS_ASSUME_NONNULL_END
