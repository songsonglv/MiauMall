//
//  MMThreeImgCell.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMThreeImgCell : UITableViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapLeftImgBlock)(NSString *indexStr); //点击左图回调
@property (nonatomic, strong)  void (^TapTopImgBlock)(NSString *indexStr); //点击上图回调
@property (nonatomic, strong)  void (^TapBottomImgBlock)(NSString *indexStr); //点击下图回调
@end

NS_ASSUME_NONNULL_END
