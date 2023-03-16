//
//  MMPassWordPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPassWordPopView : UIView
@property (nonatomic, copy) void(^returnPassBlock)(NSString *password);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
