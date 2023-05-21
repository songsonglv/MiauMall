//
//  MMShopCartChangeAttidPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "MMGoodsSpecModel.h"
#import "MMGoodsAttdataModel.h"
#import "MMShopCarGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopCartChangeAttidPopView : UIView

@property (nonatomic, copy) void(^SkuAndNumBlock)(MMGoodsAttdataModel *model,NSString *numStr);

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsSpecModel *)specModel andGoodsModel:(MMShopCarGoodsModel *)goodsModel;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
