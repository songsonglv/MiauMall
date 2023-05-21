//
//  MMDMOrderGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderGoodsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Attribute;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *PriceShow;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *SureID;
@property (nonatomic, copy) NSString *SureName;

@end

NS_ASSUME_NONNULL_END
