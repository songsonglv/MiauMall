//
//  MMShopListEnglistTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import <UIKit/UIKit.h>
@class MMSortModel;
NS_ASSUME_NONNULL_BEGIN

@interface MMShopListEnglistTopView : UIView
@property (nonatomic, copy) void(^tapSortBlock)(NSString *ID);


-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dataArr andIndex:(NSInteger )seleIndex andHei:(float )hei;
@end

NS_ASSUME_NONNULL_END
