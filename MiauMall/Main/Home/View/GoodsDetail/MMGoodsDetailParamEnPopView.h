//
//  MMGoodsDetailParamEnPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDetailParamEnPopView : UIView

-(instancetype)initWithFrame:(CGRect)frame andMoreInfo:(MMGoodsProInfoModel *)moreModel andHei:(float )hei;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
