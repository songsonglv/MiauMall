//
//  MMOrderRemindPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderRemindPopView : UIView
@property (nonatomic, copy) void(^tapGoonBlock)(NSString *str);
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
