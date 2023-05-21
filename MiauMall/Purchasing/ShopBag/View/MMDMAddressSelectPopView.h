//
//  MMDMAddressSelectPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "MMAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMDMAddressSelectPopView : UIView
@property (nonatomic, strong) NSArray *addressArr;

@property (nonatomic, copy) void(^returnAddressBlock)(MMAddressModel *model);
@property (nonatomic, copy) void(^editAddressBlock)(MMAddressModel *model);
@property (nonatomic, copy) void(^addAddressBlock)(NSString *str);


-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
