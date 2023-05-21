//
//  MMWishTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMWishTopView : UIView
@property (nonatomic, copy) void(^typeBlcok)(NSString *type);
@end

NS_ASSUME_NONNULL_END
