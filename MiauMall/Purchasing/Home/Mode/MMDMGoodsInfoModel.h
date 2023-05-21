//
//  MMDMGoodsInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMGoodsInfoModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *param;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *storename;
@property (nonatomic, strong) NSMutableArray *axis;//所有规格的层级数组
@end

NS_ASSUME_NONNULL_END
