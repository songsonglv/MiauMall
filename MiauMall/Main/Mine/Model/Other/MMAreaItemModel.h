//
//  MMAreaItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAreaItemModel : NSObject
@property (nonatomic, copy) NSString *IsList;
@property (nonatomic, copy) NSString *IsWriteStateCity;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END
