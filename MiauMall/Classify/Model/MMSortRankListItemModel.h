//
//  MMSortRankListItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSortRankListItemModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, strong) NSArray *ranklist;
@end

NS_ASSUME_NONNULL_END
