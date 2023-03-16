//
//  MMNotificationSetupView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//

#import <UIKit/UIKit.h>
#import "MMMineMainDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMNotificationSetupView : UIView
@property (nonatomic, copy) void(^saveNotificationBlock)(NSString *str1,NSString *str2,NSString *str3,NSString *str4);

-(instancetype)initWithFrame:(CGRect)frame andData:(MMMineMainDataModel *)model;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
