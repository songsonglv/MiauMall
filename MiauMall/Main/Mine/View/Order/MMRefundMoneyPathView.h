//
//  MMRefundMoneyPathView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMRefundMoneyPathView : UIView
@property (nonatomic, copy) void(^returnPathStr)(NSString *path);

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDataArr:(NSArray *)dataArr;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
