//
//  MMDMHomeItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMHomeItemModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Link;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *ClassID;
@property (nonatomic, copy) NSString *IsRecommend;
@end

NS_ASSUME_NONNULL_END
