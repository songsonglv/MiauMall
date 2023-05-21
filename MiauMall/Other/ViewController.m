//
//  ViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "ViewController.h"
#import "MMTabbarController.h"
#import "MiauMall-Swift.h"

@interface ViewController (){
    
    
}
@property (nonatomic, strong) NSString *webRegCode;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *cry;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *isFirst;
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *skipBt;//跳过按钮
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *isGo;

@end

@implementation ViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(SDCycleScrollView *)cycle{
    if(!_cycle){
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    return _cycle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.webRegCode = [self.userDefaults valueForKey:@"webRegCode"];
    self.deviceToken = [self.userDefaults valueForKey:@"deviceToken"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.isFirst = [self.userDefaults valueForKey:@"First"];
    
    
    
    [kNotificationCenter addObserver:self selector:@selector(connectNetwork) name:@"networkConnect" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(connectNetwork) name:@"networkConnect1" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(connectNetwork) name:@"networkConnect2" object:nil];
    
   
    
    
    // Do any additional setup after loading the view.
}

-(void)connectNetwork{
    if(self.webRegCode){

    }else{
        [self DownloadStatistics];
    }
    [self setUI];
    
    [ZTProgressHUD showLoadingWithMessage:@""];
}

-(void)DownloadStatistics{
    KweakSelf(self);
    //手机系统版本
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@&version=%@&type=query",baseurl,@"DownloadStatistics",phoneVersion];
//    NSDictionary *param = @{@"version":@"ios",@"type":@"query"};
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *webRegCode = [NSString stringWithFormat:@"%@",jsonDic[@"webRegCode"]];
        [weakself.userDefaults setValue:webRegCode forKey:@"webRegCode"];
        [weakself.userDefaults synchronize];
        [weakself SaveSource];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)SaveSource{
    NSString *webRegCode = [self.userDefaults valueForKey:@"webRegCode"];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@&SourceCode=%@&SSID=query",baseurl,@"SaveSource",webRegCode,self.deviceToken];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetAppGuide{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAppGuide"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *lang;
    if([self.lang isEqualToString:@"0"]){
        lang = @"zh_CN";
    }else if ([self.lang isEqualToString:@"1"]){
        lang = @"en";
    }else if ([self.lang isEqualToString:@"2"]){
        lang = @"ja_JP";
    }else if ([self.lang isEqualToString:@"3"]){
        lang = @"zh_TW";
    }
    [param setValue:lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD hide];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"list"];
            for (NSDictionary *dic in arr) {
                [weakself.dataArr addObject:dic[@"Picture"]];
            }
            weakself.cycle.imageURLStringsGroup = weakself.dataArr;
            weakself.timeCount = 5;
            weakself.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    self.timeCount--;
    if (self.timeCount == 0) {
        [self.skipBt setTitle:@"跳过" forState:UIControlStateNormal];
        //停止定时器
        [self.timer invalidate];
        if([self.isGo isEqualToString:@"1"]){
            
        }else{
            [self jump];
        }
       
    }else{
        NSString *str = [NSString stringWithFormat:@"%lus 跳过", (long)self.timeCount];
        [self.skipBt setTitle:str forState:UIControlStateNormal];
    }
}

-(void)setUI{
    KweakSelf(self);
    [self.view addSubview:self.cycle];
    
    [self GetAppGuide];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 100, StatusBarHeight + 10, 80, 20)];
    [btn setBackgroundColor:[UIColor colorWithWzx:0x000000 alpha:0.4]];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"5s 跳过" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(jump) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    self.skipBt = btn;
    
    
    
}

-(void)jump{
    self.isGo = @"1";
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMTabbarController *rootVC = [[MMTabbarController alloc]init];
    window.rootViewController = rootVC;
    rootVC.modalPresentationStyle = 0;
    [self presentViewController:rootVC animated:YES completion:nil];
}


@end
