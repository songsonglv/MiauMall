//
//  MMDMLogisticChooseView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMLogisticChooseView : UIView
@property (nonatomic, copy) void(^returnModelBlock)(NSString *ID);

-(instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)expressArr;
@end

NS_ASSUME_NONNULL_END
