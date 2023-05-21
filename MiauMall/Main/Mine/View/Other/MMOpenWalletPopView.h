//
//  MMOpenWalletPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOpenWalletPopView : UIView
@property (nonatomic, copy) void(^clickSure)(NSString *email,NSString *codeStr,NSString *pwd,NSString *againStr);
@property (nonatomic, copy) void(^clickHome)(NSString *str);
@property (nonatomic, copy) void(^clickGetCode)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
