//
//  MMDMOrderDetailPhotoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <UIKit/UIKit.h>
#import "MMDMOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMOrderDetailPhotoView : UIView
@property (nonatomic, strong) MMDMOrderDetailModel *model;
@property (nonatomic, copy) void(^tapImageBlock)(NSArray *arr,NSInteger index);
@end

NS_ASSUME_NONNULL_END
