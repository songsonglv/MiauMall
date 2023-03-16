//
//  MonthModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (copy, nonatomic) NSString *isSelectedDay;
@end

NS_ASSUME_NONNULL_END
