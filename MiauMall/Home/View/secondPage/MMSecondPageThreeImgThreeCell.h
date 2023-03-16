//
//  MMSecondPageThreeImgThreeCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageThreeImgThreeCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic, strong)  void (^TapThreeImgThreeBlock)(NSString *indexStr); //点击三图组合3回调
@end

NS_ASSUME_NONNULL_END
