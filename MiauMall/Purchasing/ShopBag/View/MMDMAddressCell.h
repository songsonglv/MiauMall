//
//  MMDMAddressCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "MMAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMDMAddressCell : UITableViewCell
@property (nonatomic, strong) MMAddressModel *model;
@property (nonatomic, copy) void(^editAddressBlock)(MMAddressModel *model);
@end

NS_ASSUME_NONNULL_END
