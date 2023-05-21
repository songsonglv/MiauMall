//
//  MMLimit8GoodsView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLimit8GoodsView : UIView
@property (nonatomic, strong) NSString *type;//0 今天 1 明天

@property (nonatomic, copy) void(^clickGoodsBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andTodayData:(NSArray *)todayArr andTomorrowData:(NSArray *)tomorrow andModel:(MMHomePageItemModel *)model;
@end

NS_ASSUME_NONNULL_END
