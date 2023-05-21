//
//  MMOrderAfterSalesReasonModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//  售后原因

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderAfterSalesReasonModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, strong) NSArray *Child;
@property (nonatomic, copy) NSString *Summary;
@property (nonatomic, copy) NSString *JPSummary;
@property (nonatomic, copy) NSString *UKSummary;
@end

NS_ASSUME_NONNULL_END
