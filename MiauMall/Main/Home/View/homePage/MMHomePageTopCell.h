//
//  MMHomePageTopCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import <UIKit/UIKit.h>
#import "MMHomePageModel.h"
#import "MMSecondPageHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMHomePageTopCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageModel *model;//装修数组
@property (nonatomic, strong) MMSecondPageHomeModel *model1;//装修数组
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic, assign) CGFloat bannerHei;
@property (nonatomic, strong) NSArray *singleHArr;//单图高度数组
@property (nonatomic, strong) NSArray *twoimg1HArr;//双图组合1高度数组
@property (nonatomic, strong) NSArray *twoimg2HArr;//双图组合2高度数组
@property (nonatomic, strong) NSArray *threeimg3HArr;//三图组合3高度数组
@property (nonatomic, strong) NSArray *nineImgHArr;//九图轮播高度数组
@property (nonatomic, strong) NSArray *imageTwoTurnHArr;//两图切换高度数组
@property (nonatomic, strong) NSArray *threeImg4HArr;//三图组合4高度数组
@property (nonatomic, strong) NSArray *stackBannerHArr;//堆叠轮播高度数组


@property (nonatomic,copy) void (^BannerTapBlock)(NSString *indexStr);//点击banner回调
@property (nonatomic,copy) void (^LinkTapBlock)(NSString *indexStr);//点击链接导航回调
@property (nonatomic,copy) void (^SingleTapBlock)(NSString *indexStr);//点击单图回调
@property (nonatomic,copy) void (^TwoTapImgBlock)(NSString *indexStr);//点击双图1回调
@property (nonatomic,copy) void (^TwoTapImgTBlock)(NSString *indexStr);//点击双图2回调
@property (nonatomic,copy) void (^ThreeTapLeftImgBlock)(NSString *indexStr);//点击三图左图
@property (nonatomic,copy) void (^ThreeTapTopImgBlock)(NSString *indexStr);//点击三图上图
@property (nonatomic,copy) void (^ThreeTapBottomImgBlock)(NSString *indexStr);//点击三图下图
@property (nonatomic,copy) void (^ThreeTapImgThreeBlock)(NSString *indexStr);//点击三图组合3
@property (nonatomic,copy) void (^NineTapImageBlock)(NSString *indexStr);//点击三图组合3
@property (nonatomic,copy) void (^limitTapMoreBlock)(NSString *str);//点击限时抢购更多
@property (nonatomic,copy) void (^limit8TapMoreBlock)(NSString *str);//点击限时抢购8更多
@property (nonatomic,copy) void (^carGoodsTapBlock)(NSString *str);//点击限时抢购更多

@property (nonatomic, copy) void (^tapTwoImageChangeBlock)(NSString *str);//点击两图切换

@property (nonatomic, copy) void(^tapRecEightGoodsBlock)(NSString *str);//点击推荐商品8商品
@property (nonatomic, copy) void(^tapRecEightGoodsCarBlock)(NSString *str);//点击推荐商品8购物车

@property (nonatomic, copy) void(^tapProList2GoodsBlock)(NSString *str);//点击商品列表2商品
@property (nonatomic, copy) void(^tapProList2GoodsCarBlock)(NSString *str);//点击商品列表2购物车

/*
@property (nonatomic, copy) void(^tapZYGoodsBlock)(NSString *str);//点击左右滑动商品
@property (nonatomic, copy) void(^tapZYGoodsCarBlock)(NSString *str);//点击左右滑动购物车
 不知道为什么这两个没法用
 */
@end


NS_ASSUME_NONNULL_END
