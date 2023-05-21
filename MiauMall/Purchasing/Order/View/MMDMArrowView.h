//
//  MMDMArrowView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "MMDMOrderTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMArrowView : UIView
@property (nonatomic, strong) NSString *isShow;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void(^returnTypeBlock)(MMDMOrderTypeModel *model);
@end

NS_ASSUME_NONNULL_END
