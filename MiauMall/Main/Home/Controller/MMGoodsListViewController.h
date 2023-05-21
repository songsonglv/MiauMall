//
//  MMGoodsListViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import "MMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGoodsListViewController : MMBaseViewController
@property (nonatomic, strong) NSString *pid;//根据pid区分不同的品类 没有默认传0
@property (nonatomic, strong) NSString *pids;//商品分类 
@end

NS_ASSUME_NONNULL_END
