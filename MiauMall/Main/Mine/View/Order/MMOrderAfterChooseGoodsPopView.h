//
//  MMOrderAfterChooseGoodsPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/17.
//

#import <UIKit/UIKit.h>
#import "MMOrderListGoodsItemModel.h"
#import "MMOrderAfterTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderAfterChooseGoodsPopView : UIView
@property (nonatomic, strong) MMOrderAfterTypeModel *typeModel;
@property (nonatomic, strong) NSString *isClear;


@property (nonatomic, copy) void(^returnGoodsBlock)(MMOrderListGoodsItemModel *model,NSString *isSelect);


-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDataArr:(NSArray *)dataArr andUniversalID:(NSString *)UniversalID andWarnMsg:(NSString *)WarnMsg;


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
