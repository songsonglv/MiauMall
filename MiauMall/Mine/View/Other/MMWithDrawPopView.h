//
//  MMWithDrawPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <UIKit/UIKit.h>
#import "MMPartnerAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMWithDrawPopView : UIView
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArr;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//单选，当前选中的
@property (nonatomic,copy) void (^clickJump)(MMPartnerAccountModel *model,NSIndexPath *indexPath);
@property (nonatomic, copy) void (^addCountBlock)(NSString *str);
-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
