//
//  MMFootCollectionCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMFootCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void(^tapMoreBlock)(NSString *router);
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
