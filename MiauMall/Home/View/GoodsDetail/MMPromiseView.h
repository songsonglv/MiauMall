//
//  MMPromise.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/19.
//

#import <UIKit/UIKit.h>
#import "MMGoodsDetailMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPromiseView : UIView
@property (nonatomic, strong) MMGoodsDetailMainModel *mainModel;//主要信息
@property (nonatomic,copy) void (^promissTapBlock)(NSString *indexStr);//点击进入郑重承诺详情
@property (nonatomic,copy) void (^questionTapBlock)(NSString *indexStr);//点击进入疑问解答


@end

NS_ASSUME_NONNULL_END
