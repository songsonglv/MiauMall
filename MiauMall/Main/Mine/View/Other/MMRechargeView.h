//
//  MMRechargeView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <UIKit/UIKit.h>
#import "MMRechargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRechargeView : UIView
@property (nonatomic, strong) NSString *isSelect; //选中字体变成白色 背景色渐变

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMRechargeModel *)model;
@end

NS_ASSUME_NONNULL_END
