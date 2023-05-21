//
//  MMRaffleViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/3.
//  抽奖

#import "MMRaffleViewController.h"

@interface MMRaffleViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIButton *raffleBt;
@property (nonatomic, strong) UIImageView *raffleImg;

@end

@implementation MMRaffleViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"抽奖页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -49, WIDTH, HEIGHT + 49)];
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.contentSize = CGSizeMake(WIDTH, 1234);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1234)];
    bgImage.image = [UIImage imageNamed:@"raffle_bg"];
    bgImage.userInteractionEnabled = YES;
    [scrollView addSubview:bgImage];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 660)];
    topImage.image = [UIImage imageNamed:@"raffle_top_bg"];
    [bgImage addSubview:topImage];
    
    UIImageView *frameImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 342)/2, 230, 342, 342)];
    frameImage.image = [UIImage imageNamed:@"turntable_frame_icon"];
    frameImage.userInteractionEnabled = YES;
    [bgImage addSubview:frameImage];
    
    UIImageView *turntableImg = [[UIImageView alloc]initWithFrame:CGRectMake(34, 34, 275, 275)];
    turntableImg.image = [UIImage imageNamed:@"turntable_icon"];
    turntableImg.userInteractionEnabled = YES;
    [frameImage addSubview:turntableImg];
    
    self.raffleImg = turntableImg;
    
    UIImageView *raffleImg = [[UIImageView alloc]initWithFrame:CGRectMake(133, 133, 78, 98)];
    raffleImg.image = [UIImage imageNamed:@"raffle_bt_icon"];
    [frameImage addSubview:raffleImg];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(133, 133, 78, 98)];
    [btn addTarget:self action:@selector(GOGOGO) forControlEvents:(UIControlEventTouchUpInside)];
    [frameImage addSubview:btn];
    self.raffleBt = btn;

    
}

-(void)GOGOGO{
    NSInteger x = arc4random() %6;
    [self animationWithSelectonIndex:x];
}


#define perSection    M_PI*2/8

-(void)animationWithSelectonIndex:(NSInteger)index{
    
    [self backToStartPosition];
    self.raffleBt.enabled = NO;
    
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //先转4圈 再选区 顺时针(所以这里需要用360-对应的角度) 逆时针不需要
    layer.toValue = @((M_PI*2 - (perSection*index +perSection*0.5)) + M_PI*2*4);
    layer.duration = 4;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    layer.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    layer.delegate = self;
    
    [self.raffleImg.layer addAnimation:layer forKey:nil];
}

-(void)backToStartPosition{
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    layer.toValue = @(0);
    layer.duration = 0.001;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    [self.raffleImg.layer addAnimation:layer forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    //设置指针返回初始位置
    self.raffleBt.enabled = YES;
//    if (self.rotaryEndTurnBlock) {
//        self.rotaryEndTurnBlock();
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"抽奖页面"];
}

@end
