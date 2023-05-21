//
//  MMLimitEightCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLimitEightCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapLimitEightMoreBlock)(NSString *str); //点击商品回调
@end

NS_ASSUME_NONNULL_END
