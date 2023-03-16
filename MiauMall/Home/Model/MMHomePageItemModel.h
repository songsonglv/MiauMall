//
//  MMHomePageItemModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//。装修对象

#import <Foundation/Foundation.h>
#import "MMHomePageContModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMHomePageItemModel : NSObject
@property (nonatomic, copy) NSString *index; //装修列表索引
@property (nonatomic, copy) NSString *name; //标题名称
@property (nonatomic, copy) NSString *name2; //副标题
@property (nonatomic, copy) NSString *havedian;
@property (nonatomic, copy) NSString *defin1;
@property (nonatomic, copy) NSString *defin2;
@property (nonatomic, copy) NSString *defin3;
@property (nonatomic, copy) NSString *defin4;
@property (nonatomic, copy) NSString *defin5;
@property (nonatomic, copy) NSString *defin6;
@property (nonatomic, copy) NSString *defin7;
@property (nonatomic, copy) NSString *defin8;
@property (nonatomic, copy) NSString *defin9;
@property (nonatomic, copy) NSString *defin10;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *fontColor;//字体颜色
@property (nonatomic, copy) NSString *otherColor;
@property (nonatomic, copy) NSString *bgImage;//背景图片
@property (nonatomic, copy) NSString *pagenum;
@property (nonatomic, copy) NSString *type;   //装修类型
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *stylebg;
@property (nonatomic, copy) NSString *margin1;//上外边距
@property (nonatomic, copy) NSString *margin2;//右外边距
@property (nonatomic, copy) NSString *margin3;//下外边距
@property (nonatomic, copy) NSString *margin4;//左外边距
@property (nonatomic, copy) NSString *padding1;//上内边距
@property (nonatomic, copy) NSString *padding2;//右内边距
@property (nonatomic, copy) NSString *padding3;//下内边距
@property (nonatomic, copy) NSString *padding4;//左内边距
@property (nonatomic, copy) NSString *classids;
@property (nonatomic, copy) NSString *classname;//样式属性
@property (nonatomic, copy) NSString *pagename;//装修仓库名
@property (nonatomic, copy) NSString *pageid;  //装修仓库id
@property (nonatomic, strong) MMHomePageContModel *cont;//内容对象

@end

NS_ASSUME_NONNULL_END
