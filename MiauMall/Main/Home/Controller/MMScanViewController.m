//
//  MMScanViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/7.
//

#import "MMScanViewController.h"
#import <SGQRCode/SGQRCode.h>
#import "MMGoodsDetailMainModel.h"

@interface MMScanViewController ()<SGScanCodeDelegate,SGScanCodeSampleBufferDelegate>
{
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;
@property (nonatomic, strong) NSString *tempcart;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *cry;

@end

@implementation MMScanViewController

- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [[SGScanViewConfigure alloc] init];
        configure.cornerLocation = SGCornerLoactionInside;
        configure.cornerWidth = 1;
        configure.cornerLength = 25;
        configure.isShowBorder = YES;
        configure.scanlineStep = 2;
        configure.scanline = @"SGQRCode.bundle/scan_scanline";
        configure.autoreverses = YES;

        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(x, y, w, h) configure:configure];
        [_scanView startScanning];
    }
    return _scanView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    [self setUI];
    [self configureQRCode];
    // Do any additional setup after loading the view.
}

-(void)setUI{

    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, StatusBarAndNavigationBarHeight, 12, 24)];
    [btn setImage:[UIImage imageNamed:@"return_white_icon"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

-(void)clickBt{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureQRCode {
    scanCode = [SGScanCode scanCode];
    scanCode.preview = self.view;
    scanCode.delegate = self;
    CGFloat w = 0.7;
    CGFloat x = 0.5 * (1 - w);
    CGFloat h = (self.view.frame.size.width / self.view.frame.size.height) * w;
    CGFloat y = 0.5 * (1 - h);
    /// 扫描范围。对应辅助扫描框的frame（borderFrame）设置
    scanCode.rectOfInterest = CGRectMake(y, x, h, w);
    [scanCode startRunning];
}

- (void)start {
    [scanCode startRunning];
    [self.scanView startScanning];
}

- (void)stop {
    [scanCode stopRunning];
    [self.scanView stopScanning];
}

// SGScanCodeDelegate
- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    NSLog(@"%@",result);
    [self requestData:result];
    
    [self stop];
//    MMBaseViewController *vc = [MMRouterJump jumpToRouters:[NSString stringWithFormat:@"/pages/shop/info?code=%@",result]];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData:(NSString *)code{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBaseInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:code forKey:@"code"];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMGoodsDetailMainModel *model = [MMGoodsDetailMainModel mj_objectWithKeyValues:jsonDic];
            MMBaseViewController *vc = [MMRouterJump jumpToRouters:[NSString stringWithFormat:@"/pages/shop/info?id=%@",model.proInfo.ID]];
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

// SGScanCodeSampleBufferDelegate
- (void)scanCode:(SGScanCode *)scanCode brightness:(CGFloat)brightness {
    NSLog(@"%f",brightness);
}


@end
