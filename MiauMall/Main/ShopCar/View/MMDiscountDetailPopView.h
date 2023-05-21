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
@property (nonatomic, strong) MMShopCarModel *model1;
@property (nonatomic, copy) void(^clickPayBlock)(NSString *str);
@property (nonatomic, copy) void(^selectGoodsBlock)(MMShopCarGoodsModel *model,NSString *isBuy);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
