//
//  MMSelectBrandCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/9.
//

#import <UIKit/UIKit.h>
#import "MMBrandModel.h"
#import "MMSortModel.h"
#import "MMCollageSortAndBrandModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMSelectBrandCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *seleImage;//选中image
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) MMBrandModel *model;
@property (nonatomic, strong) MMSortModel *model1;
@property (nonatomic, strong) MMCollageSortAndBrandModel *model2;
@property (nonatomic, copy) void(^returnDataBlock)(NSString *ID,NSString *issele);


@end

NS_ASSUME_NONNULL_END
