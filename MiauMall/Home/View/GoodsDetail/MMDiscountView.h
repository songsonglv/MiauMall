//
//  MMDiscountView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDiscountView : UIView
@property (nonatomic,copy) void (^jumpTapBlock)(NSString *indexStr);//点击进入积分规则
-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)model;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
