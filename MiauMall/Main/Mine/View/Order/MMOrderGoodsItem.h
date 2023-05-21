//
//  MMOrderGoodsItem.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderGoodsItem : UIView
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
