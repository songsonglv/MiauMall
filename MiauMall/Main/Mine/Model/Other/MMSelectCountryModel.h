//
//  MMSelectCountryModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectCountryModel : NSObject
@property (nonatomic, copy) NSString *BrandDescription;
@property (nonatomic, copy) NSString *BrandKeyWord;
@property (nonatomic, copy) NSString *BrandTitle;
@property (nonatomic, copy) NSString *CartNum;
@property (nonatomic, copy) NSString *ChinaTips;
@property (nonatomic, copy) NSString *HomeDescription;
@property (nonatomic, copy) NSString *HomeKeyWord;
@property (nonatomic, copy) NSString *HomeTitle;
@property (nonatomic, copy) NSString *NoReadyCount;
@property (nonatomic, copy) NSString *PCTitle;
@property (nonatomic, copy) NSString *SearchDescription;
@property (nonatomic, copy) NSString *SearchKeyWord;
@property (nonatomic, copy) NSString *SearchTitle;
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
