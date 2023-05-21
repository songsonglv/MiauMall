//
//  MMShipmentInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//  具体的物流内容

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShipmentInfoModel : NSObject
@property (nonatomic, copy) NSString *com;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *ischeck;
@property (nonatomic, copy) NSString *nu;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *status;
@end

NS_ASSUME_NONNULL_END
