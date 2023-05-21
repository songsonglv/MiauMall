//
//  MMSearchResultVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/24.
//

#import "MMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSearchResultVC : MMBaseViewController
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSString *pageNum;//结果的页数 1 显示推荐商品 其他 只展示搜索结果不展示推荐商品
@property (nonatomic, strong) NSString *keyWord;//搜索关键字
@end

NS_ASSUME_NONNULL_END
