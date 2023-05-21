//
//  MMDMPhotoPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import <UIKit/UIKit.h>
#import "MMDMPhotoTipsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMPhotoPopView : UIView
@property (nonatomic, copy) void(^returnSureBlock)(NSInteger num);

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMPhotoTipsModel *)tipsModel andHeight:(CGFloat )hei;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
