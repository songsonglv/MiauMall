//
//  MMXingTuiViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMXingTuiViewController.h"

@interface MMXingTuiViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSMutableArray *heiArr;
@end

@implementation MMXingTuiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"星推官页面"];
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
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"starPushMan"];
    titleView.line.hidden = NO;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self GetRotationPictures];
    // Do any additional setup after loading the view.
}

-(void)GetRotationPictures{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    
    [param setValue:@"8" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *heiA = [NSMutableArray array];
            dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                for (MMRotationPicModel *model in arr) {
                    [arr1 addObject:model.Picture];
                    CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
                    CGFloat hei = WIDTH*(size1.height/size1.width);
                    NSString *heis = [NSString stringWithFormat:@"%f",hei];
                    [heiA addObject:heis];
                }
                weakself.heiArr = [NSMutableArray arrayWithArray:heiA];
                weakself.picArr = [NSMutableArray arrayWithArray:arr1];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself setUI];
                });
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 52);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    CGFloat hei = 0;
    for (int i = 0; i < self.picArr.count; i++) {
        NSString *urlStr = self.picArr[i];
        NSString *heiStr = self.heiArr[i];
        float hei1 = [heiStr floatValue];
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, hei1)];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [scrollView addSubview:bgImage];
        hei += hei1;
    }

    scrollView.contentSize = CGSizeMake(WIDTH, hei);
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"星推官页面"];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
