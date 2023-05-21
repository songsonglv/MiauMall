//
//  MMEvaluatePolitelyPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMEvaluatePolitelyPopView : UIView
@property (nonatomic, copy) void(^clickGoBlock)(NSString *str);
@property (nonatomic, copy) void(^goTcBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andTextArr:(NSArray *)arr;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
