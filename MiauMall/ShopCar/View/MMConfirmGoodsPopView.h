//
//  MMConfirmGoodsPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "MMConfirmOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMConfirmGoodsPopView : UIView
@property (nonatomic, strong) MMConfirmOrderModel *model;

@property (nonatomic, copy) void(^jumpRouterBlock)(NSString *router);

-(instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger )index;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
