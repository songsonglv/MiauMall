//
//  MMTeamVipCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/30.
//

#import <UIKit/UIKit.h>
#import "MMMyTeamListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMTeamVipCell : UITableViewCell
@property (nonatomic, strong) MMMyTeamListModel *model;
@property (nonatomic,copy) void (^clickUpBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
