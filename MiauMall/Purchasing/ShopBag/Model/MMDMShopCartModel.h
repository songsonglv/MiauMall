//
//  MMDMShopCartModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMShopCartModel : NSObject
@property (nonatomic, strong) NSMutableArray *Distributions;//看着像服务列表
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *NormalTips;
@property (nonatomic, copy) NSString *RateTips;
@property (nonatomic, copy) NSString *Num1;
@property (nonatomic, copy) NSString *_total;
@property (nonatomic, copy) NSString *_totalhanding;
@property (nonatomic, copy) NSString *_totalhandingshow;
@property (nonatomic, copy) NSString *_totalproduct;
@property (nonatomic, copy) NSString *_totalproductshow;
@property (nonatomic, copy) NSString *_totalshow;
@property (nonatomic, copy) NSString *_totalsure;
@property (nonatomic, copy) NSString *_totalsureshow;
@property (nonatomic, copy) NSString *_totalsignshow;
@property (nonatomic, strong) NSMutableArray *item; // 不分组的商品列表
@property (nonatomic, strong) NSMutableArray *newitem; //分组的商品列表 不同的站点为一组
@end

NS_ASSUME_NONNULL_END
