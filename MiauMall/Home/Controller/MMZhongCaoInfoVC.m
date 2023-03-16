//
//  MMZhongCaoInfoVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//  种草详情

#import "MMZhongCaoInfoVC.h"
#import "MMZhongCaoInfoModel.h"
#import "MMZhongCaoWebItemView.h"
#import "MMZhongCaoInfoCell.h"
#import <WebKit/WebKit.h>

#import "TYCyclePagerView.h"
#import "TYCyclePagerViewCell.h"
#import "TYCyclePagerTransformLayout.h"


@interface MMZhongCaoInfoVC ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMTitleView *titleView;
@property (nonatomic, strong) MMZhongCaoInfoModel *model;
@property (nonatomic, strong) NSMutableArray *itemArr;
@property (nonatomic, strong) NSMutableArray *beforeArr;
@property (nonatomic, strong) NSMutableArray *imageHArr;//webview高度数组
@property (nonatomic, strong) NSMutableArray *heiArr;
@property (nonatomic, assign) float hei;
@end

@implementation MMZhongCaoInfoVC

-(NSMutableArray *)heiArr{
    if(!_heiArr){
        _heiArr = [NSMutableArray array];
    }
    return _heiArr;
}

-(TYCyclePagerView *)pagerView{
    if(!_pagerView){
        _pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, 46, WIDTH, 134)];
        _pagerView.backgroundColor = UIColor.clearColor;
        //pagerView.layer.borderWidth = 1;
        _pagerView.isInfiniteLoop = YES;
        _pagerView.autoScrollInterval = 3.0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        // registerClass or registerNib
        [_pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
    }
    return _mainTableView;
}

-(NSMutableArray *)itemArr{
    if(!_itemArr){
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

-(NSMutableArray *)imageHArr{
    if(!_imageHArr){
        _imageHArr = [NSMutableArray array];
    }
    return _imageHArr;
}

-(NSMutableArray *)beforeArr{
    if(!_beforeArr){
        _beforeArr = [NSMutableArray array];
    }
    return _beforeArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"种草详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"webHei" object:nil];
    [self GetZhongCaoInfo];
//    [self setUI];
    // Do any additional setup after loading the view.
}

//-(void)noti:(NSNotification *)sender{
//    MMZhongCaoInfoCell *cell = [sender object];
//
//}

-(void)GetZhongCaoInfo{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetZhongCaoInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"id"];
    }
    
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
       
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMZhongCaoInfoModel mj_objectWithKeyValues:jsonDic];
            weakself.titleView.titleLa.text = weakself.model.Name;
            NSArray *arr = [MMZhongCaoInfoItemModel mj_objectArrayWithKeyValuesArray:weakself.model.List];
            NSArray *befoArr = [MMZhongCaoBeforModel mj_objectArrayWithKeyValuesArray:weakself.model.before];
            weakself.itemArr = [NSMutableArray arrayWithArray:arr];
            weakself.beforeArr = [NSMutableArray arrayWithArray:befoArr];
            
//            dispatch_queue_t q1 = dispatch_queue_create("hei1", DISPATCH_QUEUE_CONCURRENT);
//            dispatch_async(q1, ^{
                for (MMZhongCaoInfoItemModel *model1 in arr){
                       
                    dispatch_async(dispatch_get_main_queue(), ^{
                        WKWebView *webKitView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
                        [webKitView loadHTMLString:model1.Conts baseURL:nil];
                        webKitView.navigationDelegate=weakself;
                        webKitView.scrollView.scrollEnabled=NO;
                        weakself.webView = webKitView;
                        webKitView.hidden=YES;
                        [weakself.view addSubview:webKitView];
                    });
                }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)setUI{
    [ZTProgressHUD hide];
    [self.view addSubview:self.mainTableView];
    
    if(self.beforeArr.count > 0){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
        view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:view];
        self.mainTableView.tableFooterView = view;
        
        CGSize size = [NSString sizeWithText:@"往期文章" font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UIButton *agoBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 22, size.width + 20, 14)];
        agoBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [agoBt setTitle:@"往期文章" forState:(UIControlStateNormal)];
        [agoBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
//        [agoBt addTarget:self action:@selector(clickAgo:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:agoBt];
        
        
        CGSize size1 = [NSString sizeWithText:@"更多" font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UIButton *moreBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - size1.width - 20, 24, size1.width + 20, 14)];
        moreBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        [moreBt setTitle:@"更多" forState:(UIControlStateNormal)];
        [moreBt setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [moreBt addTarget:self action:@selector(clickMore) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:moreBt];
        
        [view addSubview:self.pagerView];
        [self.pagerView reloadData];
    }
    
}

#pragma mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMZhongCaoInfoItemModel *model = self.itemArr[indexPath.row];
    NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:model.ProductList];
    float hei = arr.count > 0 ? arr.count * 126 + 26 : 0;
    NSString *hei1 = self.imageHArr[indexPath.row];
    hei += [hei1 floatValue];
    return hei;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMZhongCaoInfoCell*cell = [[MMZhongCaoInfoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.itemArr.count > 0){
        if(cell.model){
            
        }else{
            cell.model = self.itemArr[indexPath.row];
            cell.heiStr = self.imageHArr[indexPath.row];
            cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
                [weakself jumpRouters:router];
            };
        }
        
    }
    return cell;
}

#pragma mark -- wkwebviewdelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    KweakSelf(self);
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        if(!error){
            
            
                float hei = [result floatValue];
                NSString *heistr = [NSString stringWithFormat:@"%.2f",hei];
                [weakself.imageHArr addObject:heistr];
                
                if(weakself.imageHArr.count == weakself.itemArr.count){
                    [weakself setUI];
                }
        }
        
    }];
}

#pragma mark -- TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.beforeArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.model = self.beforeArr[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) * 0.9, CGRectGetHeight(pageView.frame) * 0.9);
    layout.itemSpacing = 5;
    layout.layoutType = 1;
    return layout;
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    MMZhongCaoBeforModel *model = self.beforeArr[index];
    NSString *router = [NSString stringWithFormat:@"/member/zhongcao/info?id=%@",model.ID];
    [self jumpRouters:router];
}

-(void)clickMore{
    NSString *router = [NSString stringWithFormat:@"/member/zhongcao/list?pid=%@",self.model.ParID];
    [self jumpRouters:router];
}

//路由跳转
-(void)jumpRouters:(NSString *)routers{
    if([routers isEqualToString:@""]){
    }else{
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"种草详情页面"];
}

@end
