//
//  MMSecondPageBannerCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageBannerCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic,copy) void (^BannerTapBlock)(NSString *indexStr); //点击banner
@property (nonatomic,copy) void (^BannerDidScrollBlock)(NSString *indexStr); //滚动banner
@end

NS_ASSUME_NONNULL_END
