//
//  MMRankList2GoodsView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMRankList2GoodsView : UIView
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, copy) void(^tapRankList2Goodsblock)(NSString *router);
@property (nonatomic, copy) void(^tapRankList2GoodsCarBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
