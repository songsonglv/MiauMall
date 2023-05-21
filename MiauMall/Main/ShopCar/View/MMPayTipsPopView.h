//
//  MMPayTipsPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPayTipsPopView : UIView
@property (nonatomic, strong) NSString *content;
@property (nonatomic, copy) void(^returnTipBlcok)(NSString *str);


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
