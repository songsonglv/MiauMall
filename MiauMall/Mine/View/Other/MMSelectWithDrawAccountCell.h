//
//  MMSelectWithDrawAccountCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <UIKit/UIKit.h>
#import "MMPartnerAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectWithDrawAccountCell : UITableViewCell
@property (nonatomic, strong) MMPartnerAccountModel *model;
@property (nonatomic, strong) UIImageView *selectImage;
@end

NS_ASSUME_NONNULL_END
