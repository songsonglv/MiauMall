//
//  MMHotListItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHotListItemModel : NSObject
@property (nonatomic, copy) NSString *Shipping48;
@property (nonatomic, copy) NSString *SortName;
@property (nonatomic, copy) NSString *demotype;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *list;//热销商品数组

@end

NS_ASSUME_NONNULL_END
