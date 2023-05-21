//
//  MMOrderRefundPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/15.
//

#import <UIKit/UIKit.h>
#import "MMRefundTipsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderRefundPopView : UIView
@property (nonatomic, copy) void(^tapGoonBlock)(NSString *str);
@property (nonatomic, strong) MMRefundTipsModel *model;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
