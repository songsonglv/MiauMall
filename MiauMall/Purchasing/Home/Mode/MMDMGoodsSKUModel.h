//
//  MMDMGoodsSKUModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMGoodsSKUModel : NSObject
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSMutableArray *info;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *quantity;//数量 为0时无法提交 负数无法获取到具体数量

@end

NS_ASSUME_NONNULL_END
