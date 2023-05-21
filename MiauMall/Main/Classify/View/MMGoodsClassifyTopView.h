//
//  MMGoodsClassifyTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/8.
//

#import <UIKit/UIKit.h>
@class MMSortModel;
NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsClassifyTopView : UIView
@property (nonatomic, strong) NSArray *classifyArr;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) void(^tapSortBlock)(NSString *ID);
@end

NS_ASSUME_NONNULL_END
