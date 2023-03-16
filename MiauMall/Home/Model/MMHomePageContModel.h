//
//  MMHomePageContModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomePageContModel : NSObject
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *protype;
@property (nonatomic, copy) NSString *proclass;
@property (nonatomic, copy) NSString *proscreen;
@property (nonatomic, copy) NSString *proonline;
@property (nonatomic, copy) NSString *prointe;
@property (nonatomic, copy) NSString *probargain;
@property (nonatomic, copy) NSString *productids;
@property (nonatomic, copy) NSString *havedian;
@property (nonatomic, copy) NSString *defin3;
@property (nonatomic, copy) NSString *defin4;
@property (nonatomic, copy) NSString *defin5;
@property (nonatomic, copy) NSString *defin6;
@property (nonatomic, copy) NSString *defin7;
@property (nonatomic, copy) NSString *defin8;
@property (nonatomic, copy) NSString *defin9;
@property (nonatomic, copy) NSString *defin10;
@property (nonatomic, copy) NSString *pagenum;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *link2;
@property (nonatomic, copy) NSString *linktype;
@property (nonatomic, copy) NSString *rownum;
@property (nonatomic, copy) NSString *liwidth;
@property (nonatomic, copy) NSString *imgtitle;
@property (nonatomic, copy) NSString *tabid;

//图片数组 MMHomeImageModel
@property (nonatomic, strong) NSArray *imglist;//图片对象
@property (nonatomic, strong) NSArray *imggrouplist;//图片对象
@property (nonatomic, strong) NSArray *threeimggrouplist;//图片对象
//文字数组 MMHomeTextModel
@property (nonatomic, strong) NSArray *textlist;
//商品数组 MMHomeLimitGoodsModel
@property (nonatomic, strong) NSArray *prolist;
//progroup MMHomeProGroupModel
@property (nonatomic, strong) NSArray *progroup;
//热销榜单数组
@property (nonatomic, strong) NSArray *hotlist;



@end

NS_ASSUME_NONNULL_END
