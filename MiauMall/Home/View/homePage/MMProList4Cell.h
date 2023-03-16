//
//  MMProList4Cell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMProList4Cell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, copy) void(^TapPro4GoodsBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
