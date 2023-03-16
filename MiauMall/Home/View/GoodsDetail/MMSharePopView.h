//
//  MMSharePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSharePopView : UIView
@property (nonatomic, copy) void(^tapNumBlock)(NSInteger index);//传出点击了第几个按钮

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
