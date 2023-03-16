//
//  MMShareOrderViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//  晒单页面

#import "MMShareOrderViewController.h"
#import "MMSunningRulesVC.h"
#import "MMShareOrderPopView.h"

@interface MMShareOrderViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycle1;
@property (nonatomic, strong) SDCycleScrollView *cycle2;

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) MMShareOrderPopView *popView;
@property (nonatomic, assign) float hei;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *dataArr1;//第一个banner的数组
@property (nonatomic, strong) NSMutableArray *dataArr2;//第二个banner的数组
@property (nonatomic, strong) NSMutableArray *orderArr;//已经收货30天的订单列表

@property (nonatomic, strong) NSString *isAgree;//是否同意 0 1 默认0

@property (nonatomic, strong) NSString *tips;//提示文字
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *imageStrArr;//返回的图片地址
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UILabel *tipsLa;
@property (nonatomic, strong) UIButton *seleBt;
@property (nonatomic, strong) UILabel *agreeLa;
@property (nonatomic, strong) UIButton *saveBt;

@end

@implementation MMShareOrderViewController

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

-(NSMutableArray *)orderArr{
    if(!_orderArr){
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"晒单页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.isAgree = @"0";
    self.view.backgroundColor = TCUIColorFromRGB(0xf4f6fa);
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"晒单";
    titleView.line.hidden = NO;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self requestHttpData];
    [self requestShareOrderList];
    [self GetPicture];
   
    // Do any additional setup after loading the view.
}

-(void)requestHttpData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求商品详情主要数据
           [weakself requestData1];
       });
       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //请求次要数据
           [weakself requestData2];
       });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求次要数据
        [weakself requestTipText];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself setUI];
    });
}

-(void)setUI{
    [ZTProgressHUD hide];

    KweakSelf(self);
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 0; i < self.dataArr1.count; i++) {
        MMRotationPicModel *model = self.dataArr1[i];
        [arr1 addObject:model.Picture];
    }
    for (int i = 0; i < self.dataArr2.count; i++) {
        MMRotationPicModel *model = self.dataArr2[i];
        [arr2 addObject:model.Picture];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 52);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.mainScrollView = scrollView;
    self.cycle1 = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 190)];
    self.cycle1.delegate = self;
    self.cycle1.imageURLStringsGroup = arr1;
    [scrollView addSubview:self.cycle1];
   
    self.cycle2 = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cycle1.frame) + 12, WIDTH - 20, 164)];
    self.cycle2.backgroundColor = TCUIColorFromRGB(0xf4f6fa);
    self.cycle2.delegate = self;
    self.cycle2.imageURLStringsGroup = arr2;
    [scrollView addSubview:self.cycle2];
    
    UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cycle2.frame) + 12, WIDTH - 10, 398)];
    conV.backgroundColor = TCUIColorFromRGB(0xffffff);
    conV.layer.masksToBounds = YES;
    conV.layer.cornerRadius = 10;
    [scrollView addSubview:conV];
    self.contentView = conV;
    
    UILabel *lab1 = [UILabel publicLab:@"添加图片" textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(6, 16, 70, 16);
    [conV addSubview:lab1];
    
    UILabel *tipsLa = [UILabel publicLab:@"最多可添加6张照片" textColor:TCUIColorFromRGB(0xc5c5c5) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    tipsLa.frame = CGRectMake(6, CGRectGetMaxY(lab1.frame) + 8, 110, 12);
    [conV addSubview:tipsLa];
    CGFloat wid = (conV.width - 44)/3;
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(0,75, WIDTH - 20, wid) andIsEnter:@"comment"];
    mediaView.isfeed = YES;
    mediaView.backgroundColor = TCUIColorFromRGB(0xfafafa);
    [conV addSubview:mediaView];
    //随时获取新高度
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        mediaView.height = mediaHeight;
        conV.height = mediaHeight + 297;
        weakself.bottomV.y = CGRectGetMaxY(mediaView.frame) + 28;
        weakself.tipsLa.y = CGRectGetMaxY(conV.frame) + 20;
        weakself.seleBt.y = CGRectGetMaxY(weakself.tipsLa.frame) + 14;
        weakself.agreeLa.y = CGRectGetMaxY(weakself.tipsLa.frame) + 14;
        weakself.saveBt.y = CGRectGetMaxY(weakself.agreeLa.frame) + 22;
        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(weakself.saveBt.frame) + 20);
    }];
    
    //随时获取选取的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        NSLog(@"%@",list);
        [weakself.imageArr removeAllObjects];
        for (ACMediaModel*model in list) {
            UIImage *image = model.image;
            [weakself.imageArr addObject:image];
        }
        
        for (int i = 0; i < weakself.imageArr.count; i++) {
            UIImage *image = weakself.imageArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [weakself requestImage:imageData];
        }
    }];
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mediaView.frame) + 28, WIDTH, 197)];
    bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [conV addSubview:bottomV];
    self.bottomV = bottomV;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, WIDTH - 45, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xebebeb);
    [bottomV addSubview:line];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(line.frame) + 30, 17, 17)];
    iconImage.image = [UIImage imageNamed:@"link_icon"];
    [bottomV addSubview:iconImage];
    
    UILabel *lab2 = [UILabel publicLab:@"选择此晒单对应的订单" textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab2.frame = CGRectMake(36, CGRectGetMaxY(line.frame) + 30, 170, 16);
    [bottomV addSubview:lab2];
    
    UILabel *lab3 = [UILabel publicLab:@"请选择对应订单商品" textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    lab3.frame = CGRectMake(conV.width - 112, CGRectGetMaxY(line.frame) + 36, 90, 10);
    [bottomV addSubview:lab3];
    
    UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(conV.width - 19, CGRectGetMaxY(line.frame) + 36, 4, 8)];
    rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
    [bottomV addSubview:rightIcon];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 30, WIDTH - 20, 16)];
    btn1.backgroundColor = UIColor.clearColor;
    [btn1 addTarget:self action:@selector(seleOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:btn1];
    
    UILabel *lab4 = [UILabel publicLab:@"仅显示确认收货后30天内的订单" textColor:TCUIColorFromRGB(0xbcbcbc) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab4.frame = CGRectMake(16, CGRectGetMaxY(lab2.frame) + 12, 190, 12);
    [bottomV addSubview:lab4];
    
    UILabel *lab5 = [UILabel publicLab:@"选择此晒单对应的订单" textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab5.frame = CGRectMake(16, CGRectGetMaxY(lab4.frame) + 26, 180, 16);
    [bottomV addSubview:lab5];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(lab4.frame) + 26, 180, 16)];
    btn.backgroundColor = UIColor.clearColor;
    [btn addTarget:self action:@selector(showPic) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomV addSubview:btn];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(lab5.frame) + 16, WIDTH - 52, 44)];
    field.textColor = TCUIColorFromRGB(0xbcbcbc);
    field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    field.layer.masksToBounds = YES;
    field.layer.cornerRadius = 7.5;
    field.layer.borderColor = TCUIColorFromRGB(0xbcbcbc).CGColor;
    field.layer.borderWidth = 0.5;
    [bottomV addSubview:field];
    
    UILabel *textLa = [UILabel publicLab:self.tips textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    textLa.frame = CGRectMake(16, CGRectGetMaxY(conV.frame) + 20, WIDTH - 27, 30);
    [textLa sizeToFit];
    [scrollView addSubview:textLa];
    self.tipsLa = textLa;
    
    
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(textLa.frame) + 14, 12, 12)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    seleBt.selected = NO;
    [seleBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clcikSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:seleBt];
    self.seleBt = seleBt;
    
    UILabel *agreeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x585454) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    agreeLa.frame = CGRectMake(33, CGRectGetMaxY(textLa.frame) + 14, 200, 12);
    [agreeLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"我已了解同意").font([UIFont fontWithName:@"PingFangSC-Regula" size:11]).textColor(TCUIColorFromRGB(0x585454));
        confer.text(@"《MailMall晒单领好礼》").font([UIFont fontWithName:@"PingFangSC-Regular" size:11]).textColor(TCUIColorFromRGB(0xe44822)).tapActionByLable(@"1");
    }];
    self.agreeLa = agreeLa;
    
    [scrollView addSubview:agreeLa];
    
    [agreeLa rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        if([tapActionId isEqualToString:@"1"]){
            [weakself goRules];
        }
    }];
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(agreeLa.frame) + 22, WIDTH - 30, 40)];
    [saveBt setBackgroundColor:TCUIColorFromRGB(0xe44822)];
    [saveBt setTitle:@"提交审核" forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 20;
    saveBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:saveBt];
    self.saveBt = saveBt;
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(saveBt.frame) + 30);
}

-(void)clickSave{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AddShareOrder"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *Albums;
    for (NSString *str in self.imageStrArr) {
        if([Albums isEqualToString:@""]){
            Albums = str;
        }else{
            Albums = [NSString stringWithFormat:@"%@,%@",Albums,str];
        }
    }
    [param setValue:Albums forKey:@"Albums"];
    [param setValue:@"1111" forKey:@"URL"];//拷贝来的link
    [param setValue:@"" forKey:@"OID"];//订单ID 待确认
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)clcikSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.isAgree = @"1";
    }else{
        self.isAgree = @"0";
    }
}

-(void)goRules{
    MMSunningRulesVC *rulesVC = [[MMSunningRulesVC alloc]init];
    [self.navigationController pushViewController:rulesVC animated:YES];
}

-(void)showPic{
    self.popView = [[MMShareOrderPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andUrl:self.imageUrl andHei:self.hei];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)seleOrder{
    if(self.orderArr.count > 0){
        
    }else{
        [ZTProgressHUD showMessage:@"您还没有订单"];
    }
}

-(void)requestData1{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"5" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr1 = [NSMutableArray arrayWithArray:arr];
        }
        dispatch_semaphore_signal(sema);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requestData2{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"6" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr2 = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requestShareOrderList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"ShareOrderList"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if(code){
            NSArray *arr = jsonDic[@"list"];
            weakself.orderArr = [NSMutableArray arrayWithArray:arr];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestTipText{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetShareOrderTips"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *tips = [NSString stringWithFormat:@"%@",jsonDic[@"ShareOrderTips"]];
            weakself.tips = tips;
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetPicture{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPicture"];
    
    [param setValue:@"147" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.imageUrl = [NSString stringWithFormat:@"%@",jsonDic[@"Picture"]];
            dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:weakself.imageUrl]];
                float hei = (WIDTH - 48)*(size1.height/size1.width);
                weakself.hei = hei;
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

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
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- sdcycledelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(cycleScrollView == self.cycle1){
        MMRotationPicModel *model = self.dataArr1[index];
        [self RouteJump:model.LinkUrl];
        
    }else{
        MMRotationPicModel *model = self.dataArr2[index];
        [self RouteJump:model.LinkUrl];
    }
}

-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"晒单页面"];
}

@end
