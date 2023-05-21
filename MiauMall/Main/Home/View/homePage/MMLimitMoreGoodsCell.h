//
//  MMLimitMoreGoodsCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/27.
//

#import <UIKit/UIKit.h>
#import "MMHomeLimitGoodsModel.h"
#import "MMHomePageItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMLimitMoreGoodsCell : UITableViewCell
@property (nonatomic, strong) MMHomeLimitGoodsModel *model;
@property (nonatomic, strong) MMHomePageItemModel *model1;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
