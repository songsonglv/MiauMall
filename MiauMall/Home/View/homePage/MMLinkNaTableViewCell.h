//
//  MMLinkNaTableViewCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLinkNaTableViewCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic,copy) void (^LinkTapBlock)(NSString *indexStr); //点击icon
@end

NS_ASSUME_NONNULL_END
