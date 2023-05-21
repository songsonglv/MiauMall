//
//  MMGoodsDatailTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDatailTopView : UIView
@property (nonatomic, strong) NSString *scrollIndex;//滚动所对应的显示  0商品 1 评级 2 详情 3 推荐
@property (nonatomic,copy) void (^scrollOnBlock)(NSString *indexStr);//点击传出滚动的锚点
@property (nonatomic,copy) void (^searchBlock)(NSString *indexStr);//点击传出滚动的锚点
@end

NS_ASSUME_NONNULL_END
