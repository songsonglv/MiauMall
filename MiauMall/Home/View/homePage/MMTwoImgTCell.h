//
//  MMTwoImgTCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTwoImgTCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapImgTBlock)(NSString *indexStr); //点击图回调
@end

NS_ASSUME_NONNULL_END
