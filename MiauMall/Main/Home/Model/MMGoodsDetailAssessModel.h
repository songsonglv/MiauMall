//
//  MMGoodsDetailAssessModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//  商品详情页面展示的评价信息

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsDetailAssessModel : NSObject
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *IsRec;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *IsReport;
@property (nonatomic, copy) NSString *HeadImg;
@property (nonatomic, copy) NSString *IsShield;
@property (nonatomic, strong) NSArray *Albums;
@property (nonatomic, copy) NSString *ReplyConts;
@property (nonatomic, strong) NSArray *Tags;//里面是tagsmodel
@property (nonatomic, copy) NSString *Level;
@end

NS_ASSUME_NONNULL_END
