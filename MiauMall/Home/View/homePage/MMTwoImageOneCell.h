//
//  MMTwoImageOneCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTwoImageOneCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapImgBlock)(NSString *indexStr); //点击图回调

@end

NS_ASSUME_NONNULL_END
