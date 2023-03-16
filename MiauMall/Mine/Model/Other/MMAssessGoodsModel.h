//
//  MMAssessGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAssessGoodsModel : NSObject
@property (nonatomic, copy) NSString *Attribute;
@property (nonatomic, copy) NSString *IsAssess;//是否评价
@property (nonatomic, copy) NSString *ItemID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Processing;
@property (nonatomic, copy) NSString *ShortName;
@end

NS_ASSUME_NONNULL_END
