//
//  MMHomePageModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//  首页整体数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomePageModel : NSObject
@property (nonatomic, copy) NSString *keyword;//首页搜索框展示文字
@property (nonatomic, copy) NSString *BackGroundImage;
@property (nonatomic, copy) NSString *IsLoadPicture;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray *list; //装修列表 里面是装修对象 MMHomePageItemModel
@property (nonatomic, copy) NSString *newcount;
@property (nonatomic, copy) NSString *currency;//国家编号
@end

NS_ASSUME_NONNULL_END
