//
//  MMClassifyLeftTableViewCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import <UIKit/UIKit.h>
#import "MMSortRankListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMClassifyLeftTableViewCell : UITableViewCell
@property (nonatomic, strong) MMSortRankListItemModel *model;
@property (nonatomic, strong) NSString *isSelect;
@end

NS_ASSUME_NONNULL_END
