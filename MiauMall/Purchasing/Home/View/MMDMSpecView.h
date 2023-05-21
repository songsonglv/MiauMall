//
//  MMDMSpecView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/27.
//

#import <UIKit/UIKit.h>
#import "MMDMGoodsInfoModel.h"
#import "MMDMGoodsSKUModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMSpecView : UIView
@property (nonatomic, copy) void(^returnModelBlock)(MMDMGoodsSKUModel *model);


-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMGoodsInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
