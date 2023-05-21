//
//  MMParamInfoEnView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMParamInfoEnView : UIView
@property (nonatomic, copy) void(^returnParamBlock)(NSString *str);
-(instancetype)initWithFrame:(CGRect)frame andMoreInfo:(MMGoodsProInfoModel *)moreModel;
@end

NS_ASSUME_NONNULL_END
