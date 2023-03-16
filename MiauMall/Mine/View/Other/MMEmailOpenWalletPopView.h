//
//  MMEmailOpenWalletPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMEmailOpenWalletPopView : UIView

@property (nonatomic, copy) void(^clickSure)(NSString *pwd,NSString *agaPwd);
@property (nonatomic, copy) void(^clickHome)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
