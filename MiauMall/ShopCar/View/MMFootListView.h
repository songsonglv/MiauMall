//
//  MMFootListView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMFootListView : UIView
@property (nonatomic, strong) NSArray *footArr;
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);
@end

NS_ASSUME_NONNULL_END
