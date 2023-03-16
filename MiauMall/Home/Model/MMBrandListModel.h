//
//  MMBrandListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBrandListModel : NSObject
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Shipping48;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *demotype;
@property (nonatomic, copy) NSString *endpage;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
