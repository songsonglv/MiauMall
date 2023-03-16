//
//  MMShipMentPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShipMentPopView : UIView

-(instancetype)initWithFrame:(CGRect)frame andContent:(NSString *)contStr;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
