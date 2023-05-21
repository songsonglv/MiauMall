//
//  MMSortDataModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSortDataModel : NSObject
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *imguk;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ukname;
@end

NS_ASSUME_NONNULL_END
