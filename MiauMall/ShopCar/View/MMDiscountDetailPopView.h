//
//  MMDiscountDetailPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "MMShopCarModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMDiscountDetailPopView : UIView
@property (nonatomic, strong) MMShopCarModel *model;
@property (nonatomic, copy) void(^clickPayBlock)(NSString *str);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
