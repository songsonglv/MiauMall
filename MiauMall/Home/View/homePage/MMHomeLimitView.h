//
//  MMHomeLimitView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/26.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MMHomeLimitView : UIView

@property (nonatomic, strong) NSString *type;//0 今天 1 明天


-(instancetype)initWithFrame:(CGRect)frame andTodayData:(NSArray *)todayArr andTomorrowData:(NSArray *)tomorrow andModel:(MMHomePageItemModel *)model;
@end

NS_ASSUME_NONNULL_END
