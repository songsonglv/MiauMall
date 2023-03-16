//
//  MMLimitTypeCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLimitTypeCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapLimitGoodsBlock)(NSString *indexStr); //点击商品回调
@property (nonatomic, strong)  void (^TapLimitMoreBlock)(NSString *str); //点击商品回调
@end

NS_ASSUME_NONNULL_END
