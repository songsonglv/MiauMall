//
//  MMThreeImgThreeCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMThreeImgThreeCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong) NSString *heiStr;
@property (nonatomic, copy) void(^TapThreeImgThreeBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
