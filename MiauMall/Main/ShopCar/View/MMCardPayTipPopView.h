//
//  MMCardPayTipPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/21.
//

#import <UIKit/UIKit.h>
#import "MMCardPayInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCardPayTipPopView : UIView

@property (nonatomic, strong) MMCardPayInfoModel *model;
@property (nonatomic, copy) void(^returnSelectBlock)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
