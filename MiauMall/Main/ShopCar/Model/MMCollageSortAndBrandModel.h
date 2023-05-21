//
//  MMCollageSortAndBrandModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMCollageSortAndBrandModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *choose;
@property (nonatomic, strong) NSArray *child;
@end

NS_ASSUME_NONNULL_END
