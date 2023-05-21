//
//  MMSecondPageNavCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageNavCell : UICollectionViewCell
@property (nonatomic, strong) MMHomePageItemModel *model;
@property (nonatomic,copy) void (^LinkTapBlock)(NSString *indexStr); //点击icon
@end

NS_ASSUME_NONNULL_END
