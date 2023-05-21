//
//  MMPriceScreenView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPriceScreenView : UIView
@property (nonatomic, copy) void(^surePriceBlock)(NSString *min,NSString *max);

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)priceArr andHei:(CGFloat )hei;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
