//
//  MMContactUsViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import "MMContactUsViewController.h"

@interface MMContactUsViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *phoneStr;
@end

@implementation MMContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
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
    titleView.titleLa.text = @"联系电话";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    [self GetMobilePhone];

    // Do any additional setup after loading the view.
}

-(void)GetMobilePhone{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMobilePhone"];
    NSDictionary *param = @{@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            self.phoneStr = jsonDic[@"MobilePhone"];
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    NSString *str = [NSString stringWithFormat:@"尊敬的MiauMall用户:\n 您的订单若出现任何需要与您沟通确定的问题，我们会通过Skype电联或短信联系您，我们的Skype号码为:%@。\n 可拨打时间: 8:30AM-19:30PM (北京时间)\n 我们的客服邮箱地址为: service@miau.co.jp 我们将在24小时内尽快给您答复。",self.phoneStr];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, StatusBarHeight + 74, WIDTH - 40, 250)];
    textView.backgroundColor = UIColor.clearColor;
    textView.textColor = TCUIColorFromRGB(0x030303);
    textView.font = [UIFont systemFontOfSize:13];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.userInteractionEnabled = NO;
    textView.text = str;
    [self.view addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;// 字体的行间距

        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    UILabel *lab = [UILabel publicLab:@"MiauMall客服部" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab.frame = CGRectMake(20, CGRectGetMaxY(textView.frame) , WIDTH - 40, 14);
    [self.view addSubview:lab];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
