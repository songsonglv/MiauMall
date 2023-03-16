//
//  UIButton+TimeInterval.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TimeInterval)
/** 点击时间间隔: 单位（秒） */
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

NS_ASSUME_NONNULL_END
