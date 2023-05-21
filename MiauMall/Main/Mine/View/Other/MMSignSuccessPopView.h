//
//  MMSignSuccessPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSignSuccessPopView : UIView
@property (nonatomic, strong) NSString *pointNum;

-(instancetype)initWithFrame:(CGRect)frame;


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
