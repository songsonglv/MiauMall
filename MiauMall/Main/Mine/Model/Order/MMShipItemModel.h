//
//  MMShipItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//  物流信息item内容

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShipItemModel : NSObject
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *ftime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@end

NS_ASSUME_NONNULL_END
