//
//  MMSetUpRatePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <UIKit/UIKit.h>
#import "MMMyTeamListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMSetUpRatePopView : UIView
@property (nonatomic, strong) MMMyTeamListModel *model;

@property (nonatomic,copy) void (^setUpRateBlcok)(NSString *rateStr);


-(instancetype)initWithFrame:(CGRect)frame andMaxRate:(NSString *)maxRate;
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
