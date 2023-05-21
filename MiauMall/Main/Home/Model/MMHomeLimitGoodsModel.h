//
//  MMHomeLimitGoodsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import "MMHomeGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeLimitGoodsModel : MMHomeGoodsModel
@property (nonatomic, copy) NSString *ShengYu;
@property (nonatomic, copy) NSString *YiQiang;
@property (nonatomic, copy) NSString *PromotionStart;
@property (nonatomic, copy) NSString *PromotionEnd;
@property (nonatomic, copy) NSString *Timestamp;
@property (nonatomic, copy) NSString *ShowTime;
@property (nonatomic, copy) NSString *StartStamp;
@property (nonatomic, copy) NSString *EndStamp;

@end

NS_ASSUME_NONNULL_END
