//
//  MMZhongCaoInfoItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/3.
//  种草详情itemmodel

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMZhongCaoInfoItemModel : NSObject
@property (nonatomic, strong) NSArray *ProductList;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *ContsStr;
@property (nonatomic, copy) NSString *ItemID;
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
