//
//  MMBrandInfoView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import <UIKit/UIKit.h>
@class MMBrandInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MMBrandInfoView : UIView
@property (nonatomic, copy) void(^returnViewHei)(CGFloat hei);
@property (nonatomic, copy) void(^tapReturnBlock)(NSString *str);
@property (nonatomic, copy) void(^tapSearchBlock)(NSString *str);
@property (nonatomic, copy) void(^tapShareBlock)(NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMBrandInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
