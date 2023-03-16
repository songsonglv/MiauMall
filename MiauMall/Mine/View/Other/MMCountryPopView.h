//
//  MMCountryPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMCountryPopView : UIView
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArr;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//单选，当前选中的
@property (nonatomic,copy) void (^clickJump)(NSString *indexStr,NSString *cry,NSString *img);
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
