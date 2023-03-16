//
//  MMCretPosterView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/26.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCretPosterView : UIView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)mode andGoodsInfo:(MMGoodsProInfoModel *)proInfo;

@property (nonatomic, copy) void(^tapNumBlock)(NSInteger index);//传出点击了第几个按钮

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
