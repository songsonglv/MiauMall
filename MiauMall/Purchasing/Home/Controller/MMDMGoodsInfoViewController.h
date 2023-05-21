//
//  MMDMGoodsInfoViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import "MMBaseViewController.h"
#import "MMDMLinlkAnalysisResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMGoodsInfoViewController : MMBaseViewController
@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, strong) MMDMLinlkAnalysisResultModel *model;

@end

NS_ASSUME_NONNULL_END
