//
//  MMDMSpecView1.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMSpecView1 : UIView
@property (nonatomic, copy) void(^returnSelealue)(NSString *name,NSString *str);

-(instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
