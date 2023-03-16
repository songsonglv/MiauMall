//
//  MMTopBannerView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTopBannerView : UIView
@property (nonatomic, strong) NSArray *bannerArr;//图片数组
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@end

NS_ASSUME_NONNULL_END
