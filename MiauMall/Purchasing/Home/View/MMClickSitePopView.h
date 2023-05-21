//
//  MMClickSitePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMClickSitePopView : UIView

@property (nonatomic, copy) void(^clickSureBlock)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
