//
//  MMSelectCouponPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectCouponPopView : UIView

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) void(^tapSureBlock)(NSString *isSelect);
@property (nonatomic, copy) void(^selectCouponBlock)(NSString *couponID,NSString *isSelect);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
