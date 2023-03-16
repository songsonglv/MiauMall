//
//  MMSelectCountryCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//

#import <UIKit/UIKit.h>
#import "MMCountryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectCountryCell : UITableViewCell
@property (nonatomic, strong) MMCountryInfoModel *model;
@property (nonatomic, strong) UIImageView *selectImage;

@end

NS_ASSUME_NONNULL_END
