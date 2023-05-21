//
//  MMCycleTableViewCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import <UIKit/UIKit.h>
#import "MMHomePageItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMCycleTableViewCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;//
@property (nonatomic,copy) void (^BannerTapBlock)(NSString *indexStr); //点击banner
@property (nonatomic,copy) void (^BannerDidScrollBlock)(NSString *indexStr); //滚动banner
@end

NS_ASSUME_NONNULL_END
