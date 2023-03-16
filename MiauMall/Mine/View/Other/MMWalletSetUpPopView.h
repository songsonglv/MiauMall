//
//  MMWalletSetUpPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMWalletSetUpPopView : UIView
@property (nonatomic, copy) void(^clickDetailBlcok)(NSString *str);
@property (nonatomic, copy) void(^clickEditBlock)(NSString *str);
@property (nonatomic, copy) void(^clickForwardBlock)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
