//
//  MMRefundMoneyReasonPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/13.
//

#import <UIKit/UIKit.h>
#import "MMOrderAfterTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMRefundMoneyReasonPopView : UIView
@property (nonatomic, copy) void(^returnReasonStr)(NSString *reason,NSString *tips);
@property (nonatomic, copy) void(^returnReasonArrBlock)(MMOrderAfterTypeModel *model, NSArray *reasonArr);


-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDataArr:(NSArray *)dataArr andType:(NSString *)type;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
