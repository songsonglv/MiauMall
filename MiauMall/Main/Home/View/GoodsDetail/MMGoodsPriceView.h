//
//  MMGoodsPriceView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/5.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsPriceView : UIView
@property (nonatomic, strong) MMGoodsDetailMainModel *proInfo;


-(instancetype)initWithFrame:(CGRect)frame andInfo:(MMGoodsDetailMainModel *)proInfo;
@end

NS_ASSUME_NONNULL_END
