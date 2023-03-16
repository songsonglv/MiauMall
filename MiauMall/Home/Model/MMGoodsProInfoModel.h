//
//  MMGoodsProInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//  商品详情次要信息

#import <Foundation/Foundation.h>
#import "MMBrandInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsProInfoModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ParId;
@property (nonatomic, strong) MMBrandInfoModel *brandInfo;
@property (nonatomic, copy) NSString *IsFullGift;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *Percent;
@property (nonatomic, copy) NSString *assesscount;
@property (nonatomic, copy) NSString *assesslevel5count;
@property (nonatomic, copy) NSString *GuideParam;
@property (nonatomic, copy) NSString *assesslevel5rate;
@property (nonatomic, copy) NSString *ShareImg;
@property (nonatomic, copy) NSString *IsColl;
@property (nonatomic, copy) NSString *ShareTitle;
@property (nonatomic, copy) NSString *ParIds;
@property (nonatomic, copy) NSString *Other;
@property (nonatomic, copy) NSString *ShareDesc;
@property (nonatomic, strong) NSArray *assesslist; //需要展示在详情页面的评价信息列表
@property (nonatomic, copy) NSString *DetailsConts;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *PriceBgPic;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *scene;
@property (nonatomic, copy) NSString *showBrand;
@property (nonatomic, copy) NSString *WxCode;
@property (nonatomic, copy) NSString *IsScribe;

@property (nonatomic, strong) NSArray *detailImages;//详情图片数组
@property (nonatomic, strong) NSArray *detailStrs;//规格参数数组
@end

NS_ASSUME_NONNULL_END
