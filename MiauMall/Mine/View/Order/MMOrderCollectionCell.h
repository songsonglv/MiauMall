//
//  MMOrderCollectionCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/13.
//

#import <UIKit/UIKit.h>
@class MMOrderListModel;
NS_ASSUME_NONNULL_BEGIN

@interface MMOrderCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@property (nonatomic, copy) void(^tapRightBlock)(NSString *btType, NSString *ID, MMOrderListModel *model);
@property (nonatomic, copy) void(^tapCenterBlock)(NSString *btType, NSString *ID, MMOrderListModel *model);
@property (nonatomic, copy) void(^tapLeftBlock)(NSString *btType, NSString *ID, MMOrderListModel *model);
@property (nonatomic, copy) void(^tapDidselectBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
