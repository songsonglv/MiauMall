//
//  MMBaseWebViewVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import "MMBaseWebViewVC.h"
#import "MMComplaintCustomerServiceVC.h"
#import "MMPaySuccessVC.h"

@interface MMBaseWebViewVC ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation MMBaseWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    self.naView = titleView;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, WIDTH, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 44)];
    self.webView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}



// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用");
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    NSLog(@"页面加载完成之后调用");
    [ZTProgressHUD hide];
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后再执行");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"在收到响应后，决定是否跳转");
    NSLog(@"%@",navigationResponse);
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"在发送请求之前，决定是否跳转");
    //这句是必须加上的，不然会异常
    decisionHandler(WKNavigationActionPolicyAllow);
    NSURL *requestURL = navigationAction.request.URL;
    NSLog(@"-----%@",requestURL.absoluteString);
    NSString *urlStr = requestURL.absoluteString;
    self.loadUrlStr = urlStr;
    if([urlStr isEqualToString:@"http://tousu.miaumall.net/"]){
        if([self.naView.titleLa.text isEqualToString:[UserDefaultLocationDic valueForKey:@"customerService"]]){
            MMComplaintCustomerServiceVC *complainCustomVC = [[MMComplaintCustomerServiceVC alloc]init];
            complainCustomVC.loadUrlStr = urlStr;
            [self.navigationController pushViewController:complainCustomVC animated:YES];
        }
        
    }else if ([urlStr containsString:@"http://miaumall.com/orderCheck?id="]){
        MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
        successVC.ID = self.orderID;
        if([self.isEnter isEqualToString:@"1"]){
            successVC.isEnter = self.isEnter;
        }
        [self.navigationController pushViewController:successVC animated:YES];
        [TalkingDataSDK onEvent:@"iOS原生-paypal支付成功" parameters:nil];
    }else if ([urlStr containsString:@"https://www.app.miau2020.com/Payment/StripeCardPaySuccessReturnUrl"]){
        MMPaySuccessVC *successVC = [[MMPaySuccessVC alloc]init];
        successVC.ID = self.orderID;
        if([self.isEnter isEqualToString:@"1"]){
            successVC.isEnter = self.isEnter;
        }
        [self.navigationController pushViewController:successVC animated:YES];
        [TalkingDataSDK onEvent:@"iOS原生-信用卡支付成功" parameters:nil];
    }else{
        [self RouteJump:urlStr];
    }
//    if ([urlStr containsString:@"sparetime-wap:"]){
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"sparetime-wap:" withString:@"antrebate-wap:"];
//    }
//    if ([urlStr containsString:@"antrebate-wap:"]) {
//        [self closePage];

//        self.resultBlock(result, dic[@"query"][@"msg"]);
//    }
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)returnBack{
    if([self.isEnter1 isEqualToString:@"1"]){
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

@end
