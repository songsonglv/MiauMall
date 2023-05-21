//
//  MMDMConfirmPurchasePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMConfirmPurchasePopView : UIView
@property (nonatomic, copy) void(^clickSureBlock)(NSString *str);
@property (nonatomic, strong) NSString *linkUrl;


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
