//
//  MMEvalutePolitelyViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/20.
//  好评有礼页面 App Store

#import "MMEvalutePolitelyViewController.h"
#import "MMRotationPicModel.h"

@interface MMEvalutePolitelyViewController ()<SDCycleScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *bgImageUrl;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) float bannerHei;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *imageStrArr;//返回的图片地址
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) ACSelectMediaView *mediaView;
@end

@implementation MMEvalutePolitelyViewController

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(NSMutableArray *)imageStrArr{
    if(!_imageStrArr){
        _imageStrArr = [NSMutableArray array];
    }
    return _imageStrArr;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(SDCycleScrollView *)cycle{
    if (!_cycle) {
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44,WIDTH,190)];
        _cycle.backgroundColor = TCUIColorFromRGB(0xffffff);
        _cycle.delegate = self;
        _cycle.layer.masksToBounds = YES;
        _cycle.placeholderImage = [UIImage imageNamed:@"zhanweic"];
//        _cycle.layer.cornerRadius = 8;
        _cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycle.showPageControl = NO;

    }
    return _cycle;
}

-(WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycle.frame) + 168, WIDTH, HEIGHT - CGRectGetMaxY(self.cycle.frame) - 168)];
        _webView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled = NO;
        [_webView loadHTMLString:self.dataDic[@"RuleConts"] baseURL:nil];
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"好评有礼页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 44)];
    titleView.titleLa.text = @"评价APP可得奖励";
    [titleView.returnBt addTarget:self action:@selector(returnBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self httpData];
    // Do any additional setup after loading the view.
}

-(void)httpData{
    KweakSelf(self);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求装修数据
        [weakself requestData];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求装修数据
        [weakself GetPicture];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
   
}

-(void)GetPicture{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    NSDictionary *param = @{@"id":@"12",@"lang":self.lang,@"cry":self.cry};
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        weakself.bannerArr = [NSMutableArray arrayWithArray:arr];
        dispatch_queue_t q1 = dispatch_queue_create("hei1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q1, ^{
            //banner高度
            MMRotationPicModel *model = arr[0];
            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
            weakself.bannerHei = size.height/size.width*WIDTH;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakself.cycle.height = weakself.bannerHei;
////                weakself.webView.y = CGRectGetMaxY(weakself.cycle.frame) + 168;
//            });
            
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}



-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"EvaluatePolitelyInit"];
    
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",jsonDic);
        weakself.dataDic = jsonDic;
        [weakself.webView loadHTMLString:jsonDic[@"RulePrecautions"] baseURL:nil];
//        [weakself.webView loadHTMLString:jsonDic[@"RuleConts"] baseURL:nil];
        
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}



-(void)setUI{
    KweakSelf(self);
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MMRotationPicModel *model in self.bannerArr) {
        [arr addObject:model.Picture];
    }
    self.cycle.imageURLStringsGroup = arr;
    [self.view addSubview:self.cycle];
    
//    [self.webView loadHTMLString:self.dataDic[@"RuleConts"] baseURL:nil];
    [self.view addSubview:self.webView];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"schpjt"] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab.frame = CGRectMake(20, CGRectGetMaxY(self.cycle.frame) + 30, WIDTH - 49, 15);
    [self.view addSubview:lab];
    
    
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab.frame) + 25,WIDTH, 76) andIsEnter:@"hpjt"];//商品评价
    mediaView.isVideo = NO;
    mediaView.isfeed = YES;
    mediaView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    [self.view addSubview:mediaView];
    
    //随时获取新高度
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        mediaView.height = mediaHeight;
    }];
    
    //随时获取选取的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        NSLog(@"%@",list);
        [weakself.imageArr removeAllObjects];
        for (ACMediaModel*model in list) {
            UIImage *image = model.image;
            if([weakself.imageArr containsObject:image]){
                    
            }else{
                [weakself.imageArr addObject:image];
            }
        }
        dispatch_queue_t q = dispatch_queue_create("upload", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q, ^{
            for (int i = 0; i < weakself.imageArr.count; i++) {
                UIImage *image = weakself.imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [weakself requestImage:imageData];
            }
        });
    }];
    
    UIButton *leftBt = [[UIButton alloc]initWithFrame:CGRectMake(12, HEIGHT - 80, (WIDTH - 36)/2, 46)];
    [leftBt setTitle:[UserDefaultLocationDic valueForKey:@"submitApply"] forState:(UIControlStateNormal)];
    [leftBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    leftBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [leftBt setBackgroundColor:TCUIColorFromRGB(0xfe5f08)];
    leftBt.layer.masksToBounds = YES;
    leftBt.layer.cornerRadius = 23;
    [leftBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBt];
    
    UIButton *rightBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBt.frame) + 12, HEIGHT - 80, (WIDTH - 36)/2, 46)];
    [rightBt setTitle:[UserDefaultLocationDic valueForKey:@"goReview"] forState:(UIControlStateNormal)];
    [rightBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    rightBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [rightBt setBackgroundColor:TCUIColorFromRGB(0x000000)];
    rightBt.layer.masksToBounds = YES;
    rightBt.layer.cornerRadius = 23;
    [rightBt addTarget:self action:@selector(goAppStore) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightBt];
}

-(void)goAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/us/app/miaumall-%E6%97%A5%E6%9C%AC%E7%9B%B4%E9%82%AE%E5%A5%BD%E5%B9%B3%E5%8F%B0/id1562454331"]];
}

//上传图片
-(void)requestImage:(NSData *)imageData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl,@"MemPicUpload"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:imageData forKey:@"file"];
    [ZTNetworking FormImageDataPostRequestUrl:url RequestPatams:param RequestData:imageData ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [weakself.imageStrArr addObject:key];
            if(weakself.imageStrArr.count == weakself.imageArr.count){
                [ZTProgressHUD showMessage:@"图片上传完成"];
            }
//            weakself.index = weakself.imageStrArr.count;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSave{
    
    if(self.imageStrArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleaseUpPic"]];
    }else{
        KweakSelf(self);
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"EvaluatePolitelyTicket"];
        
        if(self.imageStrArr.count > 0){
            NSString *Albums = [self.imageStrArr componentsJoinedByString:@","];
            [param setValue:Albums forKey:@"Picture"];
        }
        
        [param setValue:self.memberToken forKey:@"membertoken"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [weakself.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

#pragma mark -- sdcycledelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.bannerArr[index];
    [self RouteJump:model.LinkUrl];
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [TalkingDataSDK onPageEnd:@"好评有礼页面"];
}

@end
