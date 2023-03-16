//
//  MMTitleContentPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTitleContentPopView : UIView

@property (nonatomic, copy) void(^tapCancleBlcok)(NSString *index);
@property (nonatomic, copy) void(^tapGoonBlock)(NSString *index);

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andContent:(NSString *)content andCancleText:(NSString *)cancleText andSureText:(NSString *)sureText;
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
