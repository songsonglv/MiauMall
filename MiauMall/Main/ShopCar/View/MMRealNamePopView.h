//
//  MMRealNamePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/28.
//

#import <UIKit/UIKit.h>
#import "MMRealNameModel.h"
#import "MMConfirmOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRealNamePopView : UIView
@property (nonatomic,strong) MMRealNameModel *realNameModel;

-(instancetype)initWithFrame:(CGRect)frame andData:(MMConfirmOrderModel *)model;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
