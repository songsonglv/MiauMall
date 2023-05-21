//
//  MMSpecificationView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/19.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSpecificationView : UIView
@property (nonatomic, strong) MMGoodsProInfoModel *proModel;
@property (nonatomic, strong) NSArray *specHArr;//每个规格参数的高度数组
@property (nonatomic, strong) NSString *isShow;//是否展开 1展开 0 收起
@end

NS_ASSUME_NONNULL_END
