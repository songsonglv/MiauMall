//
//  MMSpecView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//

#import <UIKit/UIKit.h>
#import "MMGoodsSpecItemModel.h"
#import "MMGoodsSpecModel.h"
#import "MMAttlistItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSpecView : UIView
@property (nonatomic, copy) void(^selectSpecBlock)(MMGoodsSpecItemModel *model2,NSString *title);
-(instancetype)initWithTitle:(NSString *)title andData:(MMAttlistItemModel *)model andFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
