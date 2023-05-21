//
//  MMBrandPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBrandPopView : UIView
@property(nonatomic, strong) void(^sureSelectBlock)(NSArray *seleArr,NSString *nameStr);
@property(nonatomic, strong) void(^sureHideBlock)(NSString *str);
@property (nonatomic, strong) NSArray *dataArr;

-(instancetype)initWithFrame:(CGRect)frame andHei:(float )hei;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
