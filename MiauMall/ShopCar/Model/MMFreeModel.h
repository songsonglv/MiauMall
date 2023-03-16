//
//  MMFreeModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMFreeModel : NSObject
@property (nonatomic, copy) NSString *FreeFreight;
@property (nonatomic, copy) NSString *FreeFreightShow;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *priceshow;
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, strong) NSArray *item;
@end

NS_ASSUME_NONNULL_END
