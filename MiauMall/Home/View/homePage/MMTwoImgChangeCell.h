//
//  MMTwoImgChangeCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTwoImgChangeCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^TapTwoImgChangeBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
