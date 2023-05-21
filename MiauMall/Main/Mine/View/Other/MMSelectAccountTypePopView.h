//
//  MMSelectAccountTypePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectAccountTypePopView : UIView
@property (nonatomic,copy) void (^selectTypeBlcok)(NSString *typeStr,NSString *str);



-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
