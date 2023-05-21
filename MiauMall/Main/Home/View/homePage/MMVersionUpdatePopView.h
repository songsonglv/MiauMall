//
//  MMVersionUpdatePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/21.
//

#import <UIKit/UIKit.h>
#import "MMVersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMVersionUpdatePopView : UIView
@property (nonatomic, copy) void(^clickGoBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMVersionModel *)model;


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
