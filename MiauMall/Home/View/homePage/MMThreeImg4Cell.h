//
//  MMThreeImg4Cell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMThreeImg4Cell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong) NSString *heiStr;
@property (nonatomic, copy) void(^TapThreeImg4Block)(NSString *router);
@end

NS_ASSUME_NONNULL_END
