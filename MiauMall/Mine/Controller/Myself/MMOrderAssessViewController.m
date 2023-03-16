//
//  MMOrderAssessViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//  订单评价

#import "MMOrderAssessViewController.h"
#import "MMAssessGoodsModel.h"
#import "MMAssessTagsModel.h"
#import "MMAnonymousPopView.h"

@interface MMOrderAssessViewController ()<UITextViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMAssessGoodsModel *proInfo;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, strong) MMStarRating *startingView;//星级评价
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *Rate;//评分
@property (nonatomic, strong) NSMutableArray *seleArr;//选中的tag数组
@property (nonatomic, strong) NSString *IsNoName;//是否匿名

@property (nonatomic, strong) UIView *tuBgView;//图片文字背景view
@property (nonatomic, strong) UITextView *textView;//输入文本
@property (nonatomic, strong) UILabel *textLa;//textView里面的占位label 提示性文字
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *imageStrArr;//返回的图片地址
@property (nonatomic, strong) NSMutableArray *videoStrArr;//返回的图片地址
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) UIButton *noNameBt;
@property (nonatomic, strong) UIButton *questionBt;
@property (nonatomic, strong) UILabel *tipsLa;//提示文字
@property (nonatomic, strong) MMAnonymousPopView *popView;

@end

@implementation MMOrderAssessViewController

-(NSMutableArray *)tagsArr{
    if(!_tagsArr){
        _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"订单评价页面"];
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
    titleView.titleLa.text = @"评价";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    self.popView = [[MMAnonymousPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    [self GetPingJiaInfo];
    
    // Do any additional setup after loading the view.
}

-(void)GetPingJiaInfo{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPingJiaInfo"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"id":self.ID};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMAssessTagsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"tag"]];
            weakself.tagsArr = [NSMutableArray arrayWithArray:arr];
            weakself.proInfo = [MMAssessGoodsModel mj_objectWithKeyValues:jsonDic[@"proInfo"]];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)setUI{
    KweakSelf(self);
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 506)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 7.5;
    [self.view addSubview:bgView];
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 18, 70, 70)];
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:self.proInfo.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xf0f0f0).CGColor;
    goodsImage.layer.borderWidth = 1;
    [bgView addSubview:goodsImage];
    
    UILabel *goodsNameLa = [UILabel publicLab:self.proInfo.Name textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    goodsNameLa.frame = CGRectMake(90, 26, WIDTH - 120, 14);
    [bgView addSubview:goodsNameLa];
    
    UILabel *AttributeLa = [UILabel publicLab:self.proInfo.Attribute textColor:TCUIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,12)];
    AttributeLa.frame = CGRectMake(90, 52, size.width, 12);
    [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
    [bgView addSubview:AttributeLa];
    
    UILabel *scoreLa = [UILabel publicLab:@"商品评价" textColor:(TCUIColorFromRGB(0x383838)) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    scoreLa.frame = CGRectMake(10, 116, 60, 14);
    [bgView addSubview:scoreLa];
    
    MMStarRating *ratingView = [[MMStarRating alloc] initWithFrame:CGRectMake(76, 115, 120, 16) Count:5];  //初始化并设置frame和个数
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
    
    int count = 0;
    float btnWidth = 0;
    float viewHeight = 0;
    for (int i = 0; i < self.tagsArr.count; i++) {
        MMAssessTagsModel *model = self.tagsArr[i];
        NSString *str = [NSString stringWithFormat:@"%@",model.Name];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
        [btn setTitleColor:TCUIColorFromRGB(0x9a9a9a) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.6;
        btn.layer.borderColor = TCUIColorFromRGB(0x9a9a9a).CGColor;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:12] forKey:NSFontAttributeName];
        CGSize btnSize = [str sizeWithAttributes:dict];
        
        btn.width = btnSize.width + 17;
        btn.height = btnSize.height + 7;
        
        btnWidth += CGRectGetMaxX(btn.frame)+20;
        
        
        if (btnWidth > WIDTH) {
            count++;
            btn.x = 12;
            btnWidth = CGRectGetMaxX(btn.frame);
        }else{
            btn.x += btnWidth - btn.width;
        }
        
        btn.y += count * (btn.height+12)+144;
        viewHeight = CGRectGetMaxY(btn.frame)+12;
        
        [bgView addSubview:btn];
        
        btn.tag = 10000+i;
    }
    
    UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(10, viewHeight + 12, WIDTH - 40, 176)];
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
    
    UILabel *textLa = [UILabel publicLab:@"至少10字评论" textColor:TCUIColorFromRGB(0x848484) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    textLa.frame = CGRectMake(12, 12, 70, 11);
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
        bgView.height = CGRectGetMaxY(garyView.frame) + 114;
        weakself.tipsLa.y = CGRectGetMaxY(garyView.frame) + 20;
        weakself.noNameBt.y = CGRectGetMaxY(garyView.frame) + 58;
        weakself.questionBt.y = CGRectGetMaxY(garyView.frame) + 58;
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
    
    UILabel *tipsLa = [UILabel publicLab:@"图片+10字评论有机会被选为精选买家秀" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    tipsLa.frame = CGRectMake(20,CGRectGetMaxY(garyView.frame) + 20, WIDTH - 60, 13);
    [bgView addSubview:tipsLa];
    self.tipsLa = tipsLa;
    
    UIButton *nonameBt = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(garyView.frame) + 57, 60, 15)];
    nonameBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [nonameBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [nonameBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [nonameBt setTitle:@"匿名" forState:(UIControlStateNormal)];
    [nonameBt setTitleColor:TCUIColorFromRGB(0x231815) forState:(UIControlStateNormal)];
    [nonameBt layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:10];
    [nonameBt addTarget:self action:@selector(clickNoName:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:nonameBt];
    self.noNameBt = nonameBt;
    
    UIButton *questionBt = [[UIButton alloc]initWithFrame:CGRectMake(bgView.width - 37, CGRectGetMaxY(garyView.frame) + 57, 15, 15)];
    [questionBt setImage:[UIImage imageNamed:@"question_icon_gary"] forState:(UIControlStateNormal)];
    [questionBt addTarget:self action:@selector(clickQuestion) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:questionBt];
    self.questionBt = questionBt;
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT - 98, WIDTH - 20, 50)];
    [saveBt setBackgroundColor:redColor2];
    [saveBt setTitle:@"提交" forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    saveBt.titleLabel.font = [UIFont systemFontOfSize:16];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 6;
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveBt];
}

-(void)clickNoName:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.IsNoName = @"1";
    }else{
        self.IsNoName = @"0";
    }
}

-(void)clickQuestion{
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [self.popView showView];
}

-(void)btnClick:(UIButton *)sender{
    MMAssessTagsModel *model = self.tagsArr[sender.tag - 10000];
    sender.selected = !sender.selected;
    if(sender.selected){
        [sender setBackgroundColor:redColor2];
        sender.layer.borderColor = UIColor.clearColor.CGColor;
        [self.seleArr addObject:model.ID];
    }else{
        [sender setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        sender.layer.borderColor = TCUIColorFromRGB(0x9a9a9a).CGColor;
        [self.seleArr removeObject:model.ID];
    }
    self.tags = [self.seleArr componentsJoinedByString:@","];
    NSLog(@"%@",self.tags);
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
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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

#pragma mark -- 提交评价
-(void)clickSave{
    KweakSelf(self);
    if([self.Rate isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"请为商品打分"];
    }else if (self.textView.text.length == 0){
        [ZTProgressHUD showMessage:@"请填写商品评价"];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"TickPingJia"];
        
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        
        NSString *Albums = [self.imageStrArr componentsJoinedByString:@","];
        if(self.tags){
            [param setValue:self.tags forKey:@"tags"];
        }
        [param setValue:Albums forKey:@"Albums"];
        [param setValue:self.Rate forKey:@"Rate"];
        [param setValue:self.ID forKey:@"id"];
        [param setValue:self.textView.text forKey:@"Conts"];
        [param setValue:self.IsNoName forKey:@"IsNoName"];//订单ID 待确认
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
                 
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"assessSuccess" object:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
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
    [TalkingDataSDK onPageEnd:@"订单评价页面"];
}

@end
