//
//  MMDMServiceView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/26.
//

#import <UIKit/UIKit.h>
#import "MMDMSeriverModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMDMServiceView : UIView
@property (nonatomic, copy) void(^returnModelBlock)(MMDMSeriverModel *model);
-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
