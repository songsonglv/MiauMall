//
//  MMDMShippingCalculatorVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/16.
//

#import "MMDMShippingCalculatorVC.h"
#import "BRStringPickerView.h"



@interface MMDMShippingCalculatorVC ()<UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITextField *weightField;
@property (nonatomic, strong) UITextField *companyField;
@property (nonatomic, strong) UITextField *lengthField;
@property (nonatomic, strong) UITextField *widthField;
@property (nonatomic, strong) UITextField *heightField;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) NSMutableArray *companyArr;
@property (nonatomic, strong) NSString *LogisticRule;
@property (nonatomic, strong) UIButton *jisuanBt;

@end

@implementation MMDMShippingCalculatorVC

-(WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jisuanBt.frame), WIDTH, 100)];
        _webView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

-(NSMutableArray *)companyArr{
    if(!_companyArr){
        _companyArr = [NSMutableArray array];
    }
    return _companyArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"运费计算器"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"运费计算器";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    //GetLogisticCompany
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetLogisticCompany"];
    
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.companyArr = [NSMutableArray arrayWithArray:jsonDic[@"LogisticCompanys"]];
            weakself.LogisticRule = [NSString stringWithFormat:jsonDic[@"LogisticRule"]];
            NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
           
            NSString *str = [NSString stringWithFormat:@"%@%@",weakself.LogisticRule,s];
            [weakself.webView loadHTMLString:str baseURL:nil];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - StatusBarHeight - 54)];
    view1.backgroundColor = UIColor.clearColor;
    [scrollView addSubview:view1];
    self.contentV = view1;
    self.scrollView.contentSize = CGSizeMake(WIDTH, view1.height);
    float hei = 0;
    NSArray *arr = @[@"订单重量(kg)",@"选择物流公司",@"包裹尺寸(cm)"];
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 95)];
        [view1 addSubview:view];
        
        hei += 95;
        
        UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        titleLa.frame = CGRectMake(20, 25, WIDTH - 40, 16);
        [view addSubview:titleLa];
        
        [titleLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"*").textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Medium" size:14]);
            confer.text(arr[i]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:14]);
        }];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(13, 52, WIDTH - 26, 43)];
        view2.backgroundColor = TCUIColorFromRGB(0xffffff);
        view2.layer.masksToBounds = YES;
        view2.layer.cornerRadius = 5;
        view2.layer.borderColor = TCUIColorFromRGB(0xdadada).CGColor;
        view2.layer.borderWidth = 0.5;
        [view addSubview:view2];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(13, 0, WIDTH - 52, 43)];
        field.backgroundColor = TCUIColorFromRGB(0xffffff);
        field.delegate = self;
        field.textColor = TCUIColorFromRGB(0x383838);
        field.font = [UIFont systemFontOfSize:14];
        [view2 addSubview:field];
        
        if(i == 0){
            field.placeholder = @"请填写包裹重量，单位为kg";
            field.keyboardType = UIKeyboardTypeDecimalPad;
            self.weightField = field;
        }else if (i == 1){
            field.placeholder = @"请选择物流公司";
            self.companyField = field;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(13, 52, WIDTH - 26, 43)];
            [btn addTarget:self action:@selector(chooseCompany) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }else{
            field.hidden = YES;
            float wid = (WIDTH - 74)/3;
            
            UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(13, 52, wid, 43)];
            view4.backgroundColor = TCUIColorFromRGB(0xffffff);
            view4.layer.masksToBounds = YES;
            view4.layer.cornerRadius = 5;
            view4.layer.borderColor = TCUIColorFromRGB(0xdadada).CGColor;
            view4.layer.borderWidth = 0.5;
            [view addSubview:view4];
            
            UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(13, 0, wid - 26, 43)];
//            field1.backgroundColor = TCUIColorFromRGB(0xffffff);
            field1.delegate = self;
            field1.textColor = TCUIColorFromRGB(0x383838);
            field1.font = [UIFont systemFontOfSize:14];
            field1.keyboardType = UIKeyboardTypeDecimalPad;
            field1.placeholder = @"长";
            [view4 addSubview:field1];
            self.lengthField = field1;
            
            UILabel *xLa1 = [UILabel publicLab:@"x" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            xLa1.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
            xLa1.frame = CGRectMake(13 + wid, 52, 24, 43);
            [view addSubview:xLa1];
            
            UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(wid + 37, 52, wid, 43)];
            view5.backgroundColor = TCUIColorFromRGB(0xffffff);
            view5.layer.masksToBounds = YES;
            view5.layer.cornerRadius = 5;
            view5.layer.borderColor = TCUIColorFromRGB(0xdadada).CGColor;
            view5.layer.borderWidth = 0.5;
            [view addSubview:view5];
            
            UITextField *field2 = [[UITextField alloc]initWithFrame:CGRectMake(13, 0, wid - 26, 43)];
//            field2.backgroundColor = TCUIColorFromRGB(0xffffff);
            field2.delegate = self;
            field2.keyboardType = UIKeyboardTypeDecimalPad;
            field2.textColor = TCUIColorFromRGB(0x383838);
            field2.font = [UIFont systemFontOfSize:14];
            field2.placeholder = @"宽";
            [view5 addSubview:field2];
            self.widthField = field2;
            
            UILabel *xLa2 = [UILabel publicLab:@"x" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            xLa2.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
            xLa2.frame = CGRectMake(13 + wid + 24 + wid, 52, 24, 43);
            [view addSubview:xLa2];
            
            UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(wid + 61 + wid, 52, wid, 43)];
            view6.backgroundColor = TCUIColorFromRGB(0xffffff);
            view6.layer.masksToBounds = YES;
            view6.layer.cornerRadius = 5;
            view6.layer.borderColor = TCUIColorFromRGB(0xdadada).CGColor;
            view6.layer.borderWidth = 0.5;
            [view addSubview:view6];
            
            UITextField *field3 = [[UITextField alloc]initWithFrame:CGRectMake(13, 0, wid - 26, 43)];
//            field3.backgroundColor = TCUIColorFromRGB(0xffffff);
            field3.delegate = self;
            field3.textColor = TCUIColorFromRGB(0x383838);
            field3.font = [UIFont systemFontOfSize:14];
            field3.keyboardType = UIKeyboardTypeDecimalPad;
            field3.placeholder = @"高";
            [view6 addSubview:field3];
            self.heightField = field3;
        }
    }
    
    UIButton *jisuBt = [[UIButton alloc]initWithFrame:CGRectMake(13, 325, WIDTH - 26, 43)];
    [jisuBt setBackgroundColor:redColor3];
    [jisuBt setTitle:@"开始计算" forState:(UIControlStateNormal)];
    [jisuBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    jisuBt.titleLabel.font = [UIFont systemFontOfSize:15];
    jisuBt.layer.masksToBounds = YES;
    jisuBt.layer.cornerRadius = 5;
    [jisuBt addTarget:self action:@selector(clickJiSuan) forControlEvents:(UIControlEventTouchUpInside)];
    [view1 addSubview:jisuBt];
    self.jisuanBt = jisuBt;
    
    
    [view1 addSubview:self.webView];
    view1.height = CGRectGetMaxY(self.webView.frame);
    
    [self requestData];
}

-(void)chooseCompany{
    KweakSelf(self);
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.pickerStyle.doneTextColor = selectColor;
    stringPickerView.pickerStyle.doneBtnTitle = [UserDefaultLocationDic valueForKey:@"iconfirm"];
    stringPickerView.title = nil;
    stringPickerView.dataSourceArr = self.companyArr;
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        weakself.companyField.text = resultModel.value;
    };

    [stringPickerView show];
}

-(void)clickJiSuan{
    //FreightCalculation
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"FreightCalculation"];
    
    NSDictionary *param = @{@"cry":self.cry,@"lang":self.lang,@"type":self.companyField.text,@"weight":self.weightField.text,@"goodlength":self.lengthField.text,@"goodwidth":self.widthField.text,@"goodheight":self.heightField.text};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"MoneyShow"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];

           
            
            [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                [action setValue:selectColor forKey:@"titleTextColor"];
    
            }]];
            [weakself presentViewController:alert animated:true completion:nil];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark -- wkwebviewdelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    KweakSelf(self);
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        weakself.webView.height = webView.frame.size.height  + CGRectGetMaxY(weakself.jisuanBt.frame);
        weakself.contentV.height = CGRectGetMaxY(weakself.webView.frame);
        weakself.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(weakself.contentV.frame));
    }];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"运费计算器"];
}



@end
