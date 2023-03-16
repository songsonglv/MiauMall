//
//  MMChangeListView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMChangeListView : UIView
@property (nonatomic, copy) void(^changeListBlcok)(NSString *str);

@end

NS_ASSUME_NONNULL_END
