//
//  MMOrderAfterSalesTipPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderAfterSalesTipPopView : UIView
@property (nonatomic, strong) void(^tapGoonBlock)(NSString *str);
@property (nonatomic, strong) void(^tapQuesttBlock)(NSString *str);


-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)titleStr andConten:(NSString *)contentStr andCancle:(NSString *)cancleStr andGoon:(NSString *)goonStr;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
