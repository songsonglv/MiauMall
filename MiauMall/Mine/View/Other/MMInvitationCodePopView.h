//
//  MMInvitationCodePopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import <UIKit/UIKit.h>
#import "MMMineMainDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMInvitationCodePopView : UIView
@property (nonatomic, copy) void(^clickShareBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMMineMainDataModel *)model;
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
