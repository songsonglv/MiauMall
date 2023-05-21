//
//  MMPriceFilterPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPriceFilterPopView : UIView

@property (nonatomic, copy) void(^surePriceBlock)(NSString *min,NSString *max);
@property (nonatomic, copy) void(^sureHideBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andTopHeight:(float)hei andPriceArr:(NSArray *)priceArr andSign:(NSString *)sign;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
