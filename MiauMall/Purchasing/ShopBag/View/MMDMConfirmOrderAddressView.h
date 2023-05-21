//
//  MMDMConfirmOrderAddressView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MMDMConfirmOrderAddressView : UIView
@property (nonatomic, strong) MMAddressModel *model;
@property (nonatomic, copy) void(^seleAddressBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
