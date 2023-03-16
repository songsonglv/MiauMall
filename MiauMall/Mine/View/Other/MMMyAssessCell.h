//
//  MMMyAssessCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import <UIKit/UIKit.h>
#import "MMMyAssessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMyAssessCell : UITableViewCell
@property (nonatomic, strong) MMMyAssessModel *model;
@property (nonatomic, copy) void(^tapPicArrBlock)(NSArray *arr,NSInteger index);
@end

NS_ASSUME_NONNULL_END
