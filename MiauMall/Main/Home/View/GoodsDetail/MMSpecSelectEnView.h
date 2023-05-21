//
//  MMSpecSelectEnView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/21.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSpecSelectEnView : UIView
@property (nonatomic, strong) NSString *showStr;//展示选择的规格名称和数量
@property (nonatomic, strong) NSString *stockStr;
@property (nonatomic, copy) void(^returnSelectBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMGoodsDetailMainModel *)model andGoodsSpecArr:(NSArray *)goodsSpecArr;
@end

NS_ASSUME_NONNULL_END
