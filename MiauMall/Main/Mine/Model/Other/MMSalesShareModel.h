//
//  MMSalesShareModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSalesShareModel : NSObject
@property (nonatomic, copy) NSString *CodeUrl;
@property (nonatomic, copy) NSString *RegCode;
@property (nonatomic, copy) NSString *Title1;
@property (nonatomic, copy) NSString *Title2;
@property (nonatomic, copy) NSString *Title3;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray *Pictures;

@end

NS_ASSUME_NONNULL_END
