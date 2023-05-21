//
//  MMAddressListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import <UIKit/UIKit.h>
#import "MMAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMAddressListCell : UITableViewCell
@property (nonatomic, strong) MMAddressModel *model;
@property (nonatomic, strong) void(^clickDeleteBlock)(MMAddressModel *model);
@end

NS_ASSUME_NONNULL_END
