//
//  MMPartnerAccountCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import <UIKit/UIKit.h>
#import "MMPartnerAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerAccountCell : UITableViewCell
@property (nonatomic, strong) MMPartnerAccountModel *model;
@property (nonatomic,copy) void (^clickEdit)(NSString *ID);
@property (nonatomic,copy) void (^clickDelete)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
