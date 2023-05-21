//
//  MMBaseViewController.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBaseViewController : UIViewController
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) UITabBarItem *cartabBarItem;
@property (nonatomic, strong) UITabBarItem *minetabBarItem;
@property (nonatomic, strong) NSDictionary *localTranslationDic;
@end

NS_ASSUME_NONNULL_END
