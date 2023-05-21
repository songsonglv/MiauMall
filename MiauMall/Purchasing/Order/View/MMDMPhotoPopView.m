//
//  MMDMPhotoPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import "MMDMPhotoPopView.h"


@interface MMDMPhotoPopView ()<UITextFieldDelegate,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MMDMPhotoTipsModel *tipsModel;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) float hei;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contView;
@end

@implementation MMDMPhotoPopView

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMPhotoTipsModel *)tipsModel andHeight:(CGFloat )hei{
    if(self = [super initWithFrame:frame]){
        self.tipsModel = tipsModel;
        self.hei = hei;
        self.num = [self.tipsModel.PictureMin integerValue];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0,  HEIGHT + HEIGHT * 0.3, WIDTH, HEIGHT * 0.7)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
//
    
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 28, 12, 14, 14)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, WIDTH, HEIGHT * 0.7 - 100)];
    scrollView.delegate = self;
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.bgView addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *contV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    contV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [scrollView addSubview:contV];
    self.contView = contV;
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(contV.frame) + 72);
    
    UIImageView *photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 16, 21, 17)];
    photoImage.image = [UIImage imageNamed:@"dm_photo_icon"];
    [contV addSubview:photoImage];
    
    UILabel *photoLa = [UILabel publicLab:@"申请拍照" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
    photoLa.frame = CGRectMake(41, 15, 120, 18);
    [contV addSubview:photoLa];
    
    NSArray *arr = @[@"拍照手续费",@"拍照时间"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 56 + 40 * i, WIDTH, 40)];
        [contV addSubview:view];
        
//        CGSize size0 = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        lab.frame = CGRectMake(14, 0, 90, 15);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH - 104;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(104);
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(15);
        }];
        
        if(i == 0){
            lab1.text = self.tipsModel.DefaultMoney;
            self.moneyLa = lab1;
            
            CGSize size = [NSString sizeWithText:self.tipsModel.DefaultMoney font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
            
            CGSize size1 = [NSString sizeWithText:self.tipsModel.HandingFeeTips font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
            
            UILabel *lab2 = [UILabel publicLab:[NSString stringWithFormat:@"%@",self.tipsModel.HandingFeeTips] textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
            if(size.width + size1.width >= WIDTH - 116){
                lab2.frame = CGRectMake(104, 20, size1.width, 14);
            }else{
                lab2.frame = CGRectMake(104 + size.width + 12, 0.5, size1.width, 14);
            }
            [view addSubview:lab2];
        }else{
            lab1.text = self.tipsModel.PhotoTimeTips;
        }
    }
    
    UILabel *lab = [UILabel publicLab:@"拍照数量" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    lab.frame = CGRectMake(14, 153, 90, 15);
    [contV addSubview:lab];
    
    UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(104, 140, 128, 42)];
    garyView.backgroundColor = TCUIColorFromRGB(0xf8f8f8);
    garyView.layer.masksToBounds = YES;
    garyView.layer.cornerRadius = 21;
    [contV addSubview:garyView];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(42, 0, 44, 42)];
    field.backgroundColor = UIColor.clearColor;
    field.delegate = self;
    field.text = self.tipsModel.PictureMin;
    field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
    field.textColor = TCUIColorFromRGB(0x10131f);
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
    [garyView addSubview:field];
    self.numField = field;
    
    UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    [subBt setBackgroundColor:TCUIColorFromRGB(0xf4f4f4)];
    subBt.layer.masksToBounds = YES;
    subBt.layer.cornerRadius = 21;
    subBt.layer.borderColor = TCUIColorFromRGB(0xf2f2f2).CGColor;
    subBt.layer.borderWidth = 0.5;
    [subBt setTitle:@"-" forState:(UIControlStateNormal)];
    [subBt setTitleColor:TCUIColorFromRGB(0xa7a7a7) forState:(UIControlStateNormal)];
    subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
    [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [garyView addSubview:subBt];
    
    UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(86, 0, 42, 42)];
    [addBt setBackgroundColor:TCUIColorFromRGB(0xf4f4f4)];
    addBt.layer.masksToBounds = YES;
    addBt.layer.cornerRadius = 21;
    addBt.layer.borderColor = TCUIColorFromRGB(0xf2f2f2).CGColor;
    addBt.layer.borderWidth = 0.5;
    [addBt setTitle:@"+" forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0x101031f) forState:(UIControlStateNormal)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [garyView addSubview:addBt];
    
    UILabel *tipsLa = [UILabel publicLab:self.tipsModel.NumberTips2 textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    tipsLa.preferredMaxLayoutWidth = WIDTH - 24;
    [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [contV addSubview:tipsLa];
    
    [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(200);
            make.right.mas_equalTo(-12);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 236, WIDTH - 20, 0.5)];
    line.backgroundColor = lineColor;
    [contV addSubview:line];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 15, WIDTH, 0)];
//    webView.backgroundColor = redColor1;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.opaque = NO;
    webView.scrollView.scrollEnabled = NO;
    NSString *s = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></head>";
   //*{font-size:10px}.tatle{font-size:15px}
    NSString *str = [NSString stringWithFormat:@"%@%@",self.tipsModel.Precautions,s];
    [webView loadHTMLString:str baseURL:nil];
//    if (@available(iOS 15.0, *)) {
//        [webView loadSimulatedRequest:nil responseHTMLString:self.tipsModel.Precautions];
//    } else {
//        // Fallback on earlier versions
//    }
    [contV addSubview:webView];
    self.webView = webView;
    
    contV.height = CGRectGetMaxY(self.webView.frame);
    
//    self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.webView.frame) + 72);
    
    float wid = (WIDTH - 42)/2;
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(14, HEIGHT * 0.7 - 70, wid, 40)];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xbfbfbf)];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 20;
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"icancel"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0xfdfdfd) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:cancleBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(28 + wid, HEIGHT * 0.7 - 70, wid, 40)];
    [sureBt setBackgroundColor:redColor3];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 20;
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"confirmSubmit"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xfdfdfd) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    KweakSelf(self);
    //执行js代码动态计算高度
//    [webView evaluateJavaScript:@"Math.max(document.documentElement.scrollHeight, document.body.scrollHeight, document.documentElement.clientHeight);" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        CGFloat height = [result floatValue];
//        CGRect frame = webView.frame;
//        frame.size.height = height;
//        webView.frame = frame;
//        weakself.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(webView.frame) + 72);
//    }];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        weakself.webView.height = webView.frame.size.height;
        weakself.contView.height = CGRectGetMaxY(weakself.webView.frame);
        weakself.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(weakself.contView.frame) + 72);
    }];
}


#pragma mark -- fielddelegate
-(void)alueChange:(UITextField *)field{
    NSInteger num = [field.text integerValue];
    NSInteger maxNum = [self.tipsModel.PictureMax integerValue];//最大值
    NSInteger minNum = [self.tipsModel.PictureMin integerValue];//最小值
    if(num >maxNum){
        num = maxNum;
    }else if(num < minNum){
        num = minNum;
    }
    self.num = num;
    
    self.numField.text = [NSString stringWithFormat:@"%ld",self.num];
    NSArray *temp = [self.tipsModel.DefaultMoney componentsSeparatedByString:@" "];
    NSInteger price = [self.tipsModel.PictureStandard integerValue];
    self.moneyLa.text = [NSString stringWithFormat:@"%@ %ld",temp[0],self.num * price];
    
}

-(void)hideView1{
    
}

-(void)clickSub{
    NSInteger min = [self.tipsModel.PictureMin integerValue];
    if(self.num == min){
//        [ZTProgressHUD showMessage:@"最少需要拍摄3张照片"];
    }else{
        self.num--;
        self.numField.text = [NSString stringWithFormat:@"%ld",self.num];
        NSArray *temp = [self.tipsModel.DefaultMoney componentsSeparatedByString:@" "];
        NSInteger price = [self.tipsModel.PictureStandard integerValue];
        self.moneyLa.text = [NSString stringWithFormat:@"%@ %ld",temp[0],self.num * price];
    }
}

-(void)clickAdd{
    NSInteger max = [self.tipsModel.PictureMax integerValue];
    if(self.num == max){
//        [ZTProgressHUD showMessage:@"最多可以拍摄10张照片"];
    }else{
        self.num++;
        self.numField.text = [NSString stringWithFormat:@"%ld",self.num];
        NSArray *temp = [self.tipsModel.DefaultMoney componentsSeparatedByString:@" "];
        NSInteger price = [self.tipsModel.PictureStandard integerValue];
        self.moneyLa.text = [NSString stringWithFormat:@"%@ %ld",temp[0],self.num * price];
    }
}

-(void)clickSure{
    self.returnSureBlock(self.num);
    [self hideView];
}





-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
