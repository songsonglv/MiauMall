//
//  MMAfterSalesAssessVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/31.
//  售后服务评价

#import "MMAfterSalesAssessVC.h"

@interface MMAfterSalesAssessVC ()<UITextViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMStarRating *startingView;//星级评价
@property (nonatomic, strong) NSString *Rate;//评分
@property (nonatomic, strong) NSString *IsNoName;//是否匿名

@property (nonatomic, strong) UIView *tuBgView;//图片文字背景view
@property (nonatomic, strong) UITextView *textView;//输入文本
@property (nonatomic, strong) UILabel *textLa;//textView里面的占位label 提示性文字
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *imageStrArr;//返回的图片地址
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIButton *noNameBt;
@end

@implementation MMAfterSalesAssessVC

- (NSMutableArray *)imageArr{
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"售后服务评价页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.Rate = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"售后服务评价";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self setUI];
}

-(void)setUI{
    KweakSelf(self);
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 304)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 7.5;
    [self.view addSubview:bgView];
    
    UILabel *scoreLa = [UILabel publicLab:@"服务评价" textColor:(TCUIColorFromRGB(0x383838)) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    scoreLa.frame = CGRectMake(10, 20, 80, 14);
    [scoreLa sizeToFit];
    [bgView addSubview:scoreLa];
    
    MMStarRating *ratingView = [[MMStarRating alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scoreLa.frame) + 10, 22, 120, 16) Count:5];  //初始化并设置frame和个数
    ratingView.spacing = 7.5f; //间距
    ratingView.touchEnabled = YES;
    ratingView.slideEnabled = YES;
    ratingView.checkedImage = [UIImage imageNamed:@"star_yes"]; //选中图片
    ratingView.uncheckedImage = [UIImage imageNamed:@"star_no"]; //未选中图片
    ratingView.type = RatingTypeWhole; //评分类型
    ratingView.exclusiveTouch = YES;
    [bgView addSubview:ratingView];
    self.startingView = ratingView;
    
    ratingView.currentScoreChangeBlock = ^(CGFloat rate) {
        weakself.Rate = [NSString stringWithFormat:@"%.f",rate];
    };
    
    UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(10, 68, WIDTH - 40, 176)];
    garyView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    garyView.layer.masksToBounds = YES;
    garyView.layer.cornerRadius = 7.5;
    [bgView addSubview:garyView];
    self.tuBgView = bgView;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(7, 3, WIDTH - 44, 50)];
    textView.delegate = self;
    textView.textColor = TCUIColorFromRGB(0x3c3c3c);
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    textView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
    [garyView addSubview:textView];
    self.textView = textView;
    
    UILabel *textLa = [UILabel publicLab:@"描述具体情况，有助于商家优化服务" textColor:TCUIColorFromRGB(0x848484) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    textLa.frame = CGRectMake(12, 12, WIDTH - 64, 11);
    [textLa sizeToFit];
    [garyView addSubview:textLa];
    self.textLa = textLa;
    
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(0,70,328, 104) andIsEnter:@"assess"];//商品评价
    mediaView.isVideo = NO;
    mediaView.isfeed = YES;
    mediaView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    [garyView addSubview:mediaView];
    
    //随时获取新高度
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        mediaView.height = mediaHeight;
        garyView.height = mediaHeight + 84;
        bgView.height = CGRectGetMaxY(garyView.frame) + 60;
        weakself.noNameBt.y = CGRectGetMaxY(garyView.frame) + 22;
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
    
    UIButton *nonameBt = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(garyView.frame) + 22, 60, 15)];
    nonameBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [nonameBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [nonameBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [nonameBt setTitle:@"匿名" forState:(UIControlStateNormal)];
    [nonameBt setTitleColor:TCUIColorFromRGB(0x231815) forState:(UIControlStateNormal)];
    [nonameBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:10];
    [nonameBt addTarget:self action:@selector(clickNoName:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:nonameBt];
    self.noNameBt = nonameBt;
    
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT - 98, WIDTH - 20, 50)];
    [saveBt setBackgroundColor:redColor2];
    [saveBt setTitle:@"提交评价" forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    saveBt.titleLabel.font = [UIFont systemFontOfSize:16];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 6;
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveBt];
}

#pragma mark -- uitextviewdelegate
//判断开始输入
-(void)textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length > 0){
        self.textLa.hidden = YES;
    }else{
        self.textLa.hidden = NO;
    }
    
}

-(void)clickNoName:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.IsNoName = @"1";
    }else{
        self.IsNoName = @"0";
    }
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
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSave{
    KweakSelf(self);
    if([self.Rate isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"请为商品打分"];
    }else if (self.textView.text.length == 0){
        [ZTProgressHUD showMessage:@"请填写商品评价"];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl1,@"TickSalesEvaluation"];
        
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        if(self.imageArr.count > 0){
            NSString *Albums = [self.imageStrArr componentsJoinedByString:@","];
            [param setValue:Albums forKey:@"albums"];
        }
        
        [param setValue:self.Rate forKey:@"level"];
        [param setValue:self.orderId forKey:@"orderID"];
        [param setValue:self.textView.text forKey:@"conts"];
        [param setValue:self.IsNoName forKey:@"anonymous"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        if(self.goodsID){
            [param setValue:self.goodsID forKey:@"itemID"];
        }
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"售后服务评价页面"];
}
@end
