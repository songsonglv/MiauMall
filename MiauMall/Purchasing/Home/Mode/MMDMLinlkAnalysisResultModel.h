//
//  MMDMLinlkAnalysisResultModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import <Foundation/Foundation.h>
#import "MMDMGoodsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMLinlkAnalysisResultModel : NSObject
@property (nonatomic, strong) MMDMGoodsInfoModel *ItemList;
@property (nonatomic, copy) NSString *AttentionName;
@property (nonatomic, copy) NSString *AttentionConts;//富文本 网页
@property (nonatomic, copy) NSString *Site;
@property (nonatomic, copy) NSString *SiteName;
@property (nonatomic, copy) NSString *SitePicture;
@property (nonatomic, copy) NSString *SiteDetail;//简介
@property (nonatomic, copy) NSString *CommissionStr;
@property (nonatomic, copy) NSString *HeadRedWarn;
@property (nonatomic, strong) NSMutableArray *DistributionGuaranteeList;
@end

NS_ASSUME_NONNULL_END
