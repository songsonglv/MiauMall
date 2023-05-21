//
//  MMReadyPayOrderModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMReadyPayOrderModel : NSObject
@property (nonatomic, copy) NSString *GoPay;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Processing;
@property (nonatomic, copy) NSString *ReadyPay;
@property (nonatomic, copy) NSString *Tips;
@end

NS_ASSUME_NONNULL_END
