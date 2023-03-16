//
//  MMHistorySearchView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHistorySearchView : UIView
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic, copy) void(^tapDeleteBlock)(NSString *str);

@property (nonatomic, copy) void(^tapSearchBlcok)(NSString *keyword);
@end

NS_ASSUME_NONNULL_END
