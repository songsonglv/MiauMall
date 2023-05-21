//
//  MMZhongCaoWebItemView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMZhongCaoWebItemView : UIView
@property (nonatomic, strong) MMZhongCaoInfoItemModel *model;
@property (nonatomic, strong) NSArray *heiArr;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
