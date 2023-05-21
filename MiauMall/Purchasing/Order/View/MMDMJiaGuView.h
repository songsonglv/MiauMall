//
//  MMDMJiaGuView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <UIKit/UIKit.h>
#import "MMDMChooseLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMJiaGuView : UIView
@property (nonatomic, copy) void(^selectJiaguBlock)(NSString *str);
-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMChooseLogisticsModel *)model;
@end

NS_ASSUME_NONNULL_END
