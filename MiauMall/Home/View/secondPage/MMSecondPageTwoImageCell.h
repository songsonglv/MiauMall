//
//  MMSecondPageTwoImageCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageTwoImageCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapImgBlock)(NSString *indexStr); //点击图回调
@end

NS_ASSUME_NONNULL_END
