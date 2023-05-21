//
//  MMGoodsDiscountEnView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDiscountEnView : UIView

-(instancetype)initWithFrame:(CGRect)frame andBaseInfo:(MMGoodsDetailMainModel *)model andMoreInfo:(MMGoodsProInfoModel *)moreModel;

@end

NS_ASSUME_NONNULL_END
