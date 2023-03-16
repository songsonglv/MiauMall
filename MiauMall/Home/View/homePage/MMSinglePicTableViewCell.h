//
//  MMSinglePicTableViewCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSinglePicTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic,copy) void (^TapIadvBlock)(NSString *indexStr); //点击单图
@end

NS_ASSUME_NONNULL_END
