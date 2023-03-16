//
//  MMGetCouponsPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGetCouponsPopView : UIView
@property (nonatomic, strong) void(^returnCouponBlck)(NSString *codeStr);
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
