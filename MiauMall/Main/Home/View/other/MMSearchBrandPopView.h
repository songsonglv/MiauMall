//
//  MMSearchBrandPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSearchBrandPopView : UIView
@property (nonatomic, strong) NSString *type;//0 分类 1品牌

@property(nonatomic, strong) void(^sureSelectBlock)(NSArray *seleArr,NSString *nameStr);

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArr andData1:(NSArray *)dataArr1;


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
