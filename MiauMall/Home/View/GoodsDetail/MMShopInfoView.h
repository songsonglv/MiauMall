//
//  MMShopInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/18.
//

#import <UIKit/UIKit.h>
#import "MMBrandInfoModel.h"
#import "MMBrandListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMShopInfoView : UIView
@property (nonatomic, strong) MMBrandInfoModel *brandInfoModel;//店铺信息
@property (nonatomic, strong) MMBrandListModel *listModel;//推荐商品列表
@property (nonatomic,copy) void (^brandTapBlock)(NSString *indexStr);//点击进入品牌详情
@property (nonatomic,copy) void (^goodsTapBlock)(NSString *indexStr);//点击进入商品详情
@end

NS_ASSUME_NONNULL_END
