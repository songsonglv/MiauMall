//
//  MMHomeProListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//  商品集对象

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeProListModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *link2;
@property (nonatomic, copy) NSString *linktype;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, strong) NSArray *itemlist; //里面是商品对象 MMHomeGoodsModel
@property (nonatomic, copy) NSString *show;
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
