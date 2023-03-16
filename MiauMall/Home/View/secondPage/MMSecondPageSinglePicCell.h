//
//  MMSecondPageSinglePicCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageSinglePicCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic,copy) void (^TapIadvBlock)(NSString *indexStr); //点击单图
@end

NS_ASSUME_NONNULL_END
