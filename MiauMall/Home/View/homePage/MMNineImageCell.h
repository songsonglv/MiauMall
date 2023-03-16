//
//  MMNineImageCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMNineImageCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^TapNineImageBlock)(NSString *router);
@property (nonatomic, copy) void(^tapNineImageCarBlock)(NSString *router);

@end

NS_ASSUME_NONNULL_END
