//
//  MMZhongCaoInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMZhongCaoInfoModel : NSObject
@property (nonatomic, copy) NSString *Explains;
@property (nonatomic, strong) NSArray *List;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, strong) NSArray *before;
@property (nonatomic, strong) NSArray *like;
@end

NS_ASSUME_NONNULL_END
