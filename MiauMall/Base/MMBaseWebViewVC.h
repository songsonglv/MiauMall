//
//  MMBaseWebViewVC.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import "MMBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMBaseWebViewVC : MMBaseViewController
@property (nonatomic, strong) MMTitleView*naView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *titleStr;//标题
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *loadUrlStr;
@end

NS_ASSUME_NONNULL_END
