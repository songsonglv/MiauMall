//
//  MMClassifyModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMClassifyModel : NSObject
@property (nonatomic, copy) NSString *tabid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *brand;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *ranklist;
@property (nonatomic, strong) NSArray *toplist;
@end

NS_ASSUME_NONNULL_END
