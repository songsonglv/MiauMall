//
//  MMDMOrderTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderTopView : UIView
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) void(^selectIndexBlock)(NSInteger index,UIButton *btn);
@end

NS_ASSUME_NONNULL_END
