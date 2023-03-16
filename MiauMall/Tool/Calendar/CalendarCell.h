//
//  CalendarCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import <UIKit/UIKit.h>
#import "MonthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) MonthModel *monthModel;
@end

NS_ASSUME_NONNULL_END
