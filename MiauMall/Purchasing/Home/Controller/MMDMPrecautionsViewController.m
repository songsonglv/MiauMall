//
//  MMDMPrecautionsViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//  代买注意事项页面

#import "MMDMPrecautionsViewController.h"
#import "MMDMLinlkAnalysisResultModel.h"
#import "MMDMGoodsInfoViewController.h"

@interface MMDMPrecautionsViewController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMDMLinlkAnalysisResultModel *model;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *sureBt;
@end

@implementation MMDMPrecautionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"代买注意事项";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    
//    self.linkUrl = [self.linkUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *url = [NSString stringWithFormat:@"%s%@?producturl=%@&lang=%@&cry=%@",baseurl1,@"GetPurchasingInfo",self.linkUrl,self.lang,self.cry];
    
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetPurchasingInfo"];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@""];
    self.linkUrl = [self.linkUrl stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    NSDictionary *param = @{@"producturl":self.linkUrl,@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    
    [ZTProgressHUD showLoadingWithMessage:@""];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD hide];
        NSLog(@"%@",jsonDic);
        MMDMLinlkAnalysisResultModel *model = [MMDMLinlkAnalysisResultModel mj_objectWithKeyValues:jsonDic];
        weakself.model = model;
        [weakself setUI];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    [self.view addSubview:scrollView];
    self.mainScrollView = scrollView;
    
    CGSize size = [NSString sizeWithText:self.model.HeadRedWarn font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(WIDTH - 24,13)];
    
    UILabel *headReLa = [UILabel publicLab:self.model.HeadRedWarn textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    headReLa.frame = CGRectMake(12, 40, WIDTH - 24, size.height);
    [scrollView addSubview:headReLa];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(headReLa.frame) + 24, 68, 68)];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 6;
    headImage.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
    headImage.layer.borderWidth = 0.5;
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.SitePicture] placeholderImage:[UIImage imageNamed:@"dm_site_zhanwei"]];
    [scrollView addSubview:headImage];
    
    NSString *siteName = self.model.SiteName.length > 0 ? self.model.SiteName : @"获取网站链接失败";
    UILabel *siteLa = [UILabel publicLab:siteName textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    siteLa.frame = CGRectMake(94, CGRectGetMaxY(headReLa.frame) + 40, WIDTH - 110, 18);
    [scrollView addSubview:siteLa];
    
    NSString *shortName = self.model.SiteDetail.length > 0 ? self.model.SiteDetail : @"请手动填写相关产品信息";
    
    UILabel *shortNameLa = [UILabel publicLab:shortName textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    shortNameLa.frame = CGRectMake(94, CGRectGetMaxY(siteLa.frame) + 7, WIDTH - 110, 13);
    [scrollView addSubview:shortNameLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(headImage.frame) + 30, WIDTH - 24, 1)];
    line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
    [scrollView addSubview:line];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), WIDTH, 100)];
    webView.backgroundColor = TCUIColorFromRGB(0xffffff);
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.opaque = NO;
    webView.scrollView.scrollEnabled = NO;
    NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
   
    NSString *str = [NSString stringWithFormat:@"%@%@",self.model.AttentionConts,s];
    [webView loadHTMLString:str baseURL:nil];
    [scrollView addSubview:webView];
   
    //WKWebView
//    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(webView.frame) + 60, WIDTH - 24, 46)];
    [btn setBackgroundColor:redColor3];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 23;
    [btn setTitle:@"我已阅读并同意" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:btn];
    self.sureBt = btn;
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(btn.frame) + 26);
}


#pragma mark -- 监听webview高度变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        self.webView.height =  self.webView.scrollView.contentSize.height;
//        self.sureBt.y = CGRectGetMaxY(self.webView.frame) + 60;
//        self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.webView.frame) + 132);
//    }
//
//}

/**  < 法2 >  */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //document.body.offsetHeight
    //document.body.scrollHeight
    //document.body.clientHeight
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        self.webView.height = webView.frame.size.height;
        self.sureBt.y = CGRectGetMaxY(self.webView.frame) + 60;
        self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.webView.frame) + 132);
    }];
 
    
//    CGRect webFrame = self.wkWebView.frame;
//    CGFloat contentHeight = webView.scrollView.contentSize.height;
//    webFrame.size.height = contentHeight;
//    webView.frame = webFrame;
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)clickSure{
    MMDMGoodsInfoViewController *goodsVC = [[MMDMGoodsInfoViewController alloc]init];
    goodsVC.model = self.model;
    goodsVC.linkUrl = self.linkUrl;
    [self.navigationController pushViewController:goodsVC animated:YES];
}


-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [ZTProgressHUD hide];
}


@end
