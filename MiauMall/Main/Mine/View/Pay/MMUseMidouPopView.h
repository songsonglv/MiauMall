//
//  MMUseMidouPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import <UIKit/UIKit.h>
#import "MMConfirmOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMUseMidouPopView : UIView
@property (nonatomic, strong) void(^tapRuleBlock)(NSString *index);
@property (nonatomic, strong) void(^tapSureBlock)(NSString *num);
@property (nonatomic, strong) MMConfirmOrderModel *model;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
