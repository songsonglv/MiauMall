//
//  MMOrderDetailGoodsView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import <UIKit/UIKit.h>
@class MMOrderDetailInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderDetailGoodsView : UIView
@property (nonatomic, strong) MMOrderDetailInfoModel *model;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapApplyBlock)(NSString *ID);
@property (nonatomic, copy) void(^tapAddCarBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
