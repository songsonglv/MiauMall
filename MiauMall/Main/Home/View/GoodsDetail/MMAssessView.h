//
//  MMAssessView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/18.
//

#import <UIKit/UIKit.h>
#import "MMGoodsProInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMAssessView : UIView
@property (nonatomic, strong) MMGoodsProInfoModel *proInfoModel;//次要信息
@property (nonatomic, strong) NSArray *tags;//标签数组
@property (nonatomic,copy) void (^assessTapBlock)(NSString *indexStr);//点击评价进入评价列表
@end

NS_ASSUME_NONNULL_END
