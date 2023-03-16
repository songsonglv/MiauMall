//
//  MMAttlistItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//。展示出来的一层 如款式

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAttlistItemModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, copy) NSString *choose;
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
