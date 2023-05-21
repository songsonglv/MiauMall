//
//  MMHeaderView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import <UIKit/UIKit.h>
#import "MMQuestionFirstModel.h"
@class MMHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol MMHeaderViewDelegate <NSObject>

-(void)selectWidth:(MMHeaderView *)view;

@end
@interface MMHeaderView : UIView
@property (nonatomic, weak) id<MMHeaderViewDelegate> delegate;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) UIButton *backBt;
@property (nonatomic, strong) MMQuestionFirstModel *model;
@end

NS_ASSUME_NONNULL_END
