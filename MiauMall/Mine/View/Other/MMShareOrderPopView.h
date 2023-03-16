//
//  MMShareOrderPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMShareOrderPopView : UIView

-(instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)url andHei:(CGFloat)hei;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
