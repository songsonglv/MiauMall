//
//  MMAssessListTopView.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAssessListTopView : UIView
@property (nonatomic, strong) NSArray *tags;//标签数组
@property (nonatomic, strong) NSString *assesslevel5rate;//好评率
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic,copy) void (^btnTapBlock)(NSString *indexStr,NSString *num);//点击返回id
@end

NS_ASSUME_NONNULL_END
