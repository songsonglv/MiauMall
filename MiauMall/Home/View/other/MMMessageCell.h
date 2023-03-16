//
//  MMMessageCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/7.
//

#import <UIKit/UIKit.h>
#import "MMMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMMessageCell : UITableViewCell
@property (nonatomic, strong) MMMessageModel *model;
@end

NS_ASSUME_NONNULL_END
