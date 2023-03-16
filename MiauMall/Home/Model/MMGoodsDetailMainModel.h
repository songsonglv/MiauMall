//
//  MMGoodsDetailMainModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//。商品详情主要信息外层字段

#import <Foundation/Foundation.h>
#import "MMGoodsDetailMainInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDetailMainModel : NSObject
@property (nonatomic, copy) NSString *GetIntegral;
@property (nonatomic, copy) NSString *UseIntegral;
@property (nonatomic, copy) NSString *UseMaxIntegral;
@property (nonatomic, strong) MMGoodsDetailMainInfoModel *proInfo;
@property (nonatomic, copy) NSString *tkyn;
@property (nonatomic, strong) NSArray *yunfei;
@end

NS_ASSUME_NONNULL_END
