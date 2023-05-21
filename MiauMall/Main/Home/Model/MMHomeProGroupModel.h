//
//  MMHomeProGroupModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeProGroupModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *child;//商品组
@end

NS_ASSUME_NONNULL_END
