//
//  MMDMOrderCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import <UIKit/UIKit.h>
#import "MMDMOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderCell : UITableViewCell
@property (nonatomic, strong) MMDMOrderListModel *model;
@property (nonatomic, copy) void(^clickLastBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickPayBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickKeFuBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickPhotoBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickCancleBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickResultBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickRefundBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickReceiptBlock)(MMDMOrderListModel *model);
@property (nonatomic, copy) void(^clickExpresstBlock)(MMDMOrderListModel *model);

@end

NS_ASSUME_NONNULL_END
