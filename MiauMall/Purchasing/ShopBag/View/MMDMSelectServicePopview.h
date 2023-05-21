//
//  MMDMSelectServicePopview.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "MMDMSeriverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMSelectServicePopview : UIView

@property (nonatomic, strong) NSArray *tipsArr;
@property (nonatomic, copy) void(^selectServiceBlock)(MMDMSeriverModel *model);

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
