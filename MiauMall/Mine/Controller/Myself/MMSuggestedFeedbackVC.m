//
//  MMSuggestedFeedbackVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//  建议反馈

#import "MMSuggestedFeedbackVC.h"
#import "MMFeedbackTagModel.h"

@interface MMSuggestedFeedbackVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIView *fieldView;
@property (nonatomic, strong) UILabel *emailLa;
@property (nonatomic, strong) NSMutableArray *pids;
@property (nonatomic, strong) NSString *pidStr;

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
@property (nonatomic, assign) NSInteger index;
@end

@implementation MMSuggestedFeedbackVC

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

-(NSMutableArray *)tags{
    if(!_tags){
        _tags = [NSMutableArray array];
    }
    return _tags;
}

-(NSMutableArray *)pids{
    if(!_pids){
        _pids = [NSMutableArray array];
    }
    return _pids;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"意见反馈页面"];
}

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
    titleView.titleLa.text = @"建议反馈";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    [self LoadTicket];
    // Do any additional setup after loading the view.
}

-(void)LoadTicket{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoadTicket"];
    NSDictionary *param = @{@"lang":self.lang,@"cry":self.cry,@"membertoken":self.memberToken};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMFeedbackTagModel mj_objectArrayWithKeyValuesArray:jsonDic[@"parids"]];
            weakself.tags = [NSMutableArray arrayWithArray:arr];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    
    KweakSelf(self);
    
    UIView *contView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 440)];
    contView.backgroundColor = TCUIColorFromRGB(0xffffff);
    contView.layer.maskedCorners = YES;
    contView.layer.cornerRadius = 6;
    [self.view addSubview:contView];
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab.frame = CGRectMake(20, 17, WIDTH - 60, 14);
    [contView addSubview:lab];
    
    [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"请选择反馈标签").textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:14]);
        confer.text(@"（至少选择1个）").textColor(TCUIColorFromRGB(0xd64f3e)).font([UIFont fontWithName:@"PingFangSC-Mdeium" size:12]);
    }];
    
    int count = 0; //行数
    float btnWidth = 0;
    float viewHeight = 0;
    for (int i = 0; i < self.tags.count; i++) {
        MMFeedbackTagModel *model = self.tags[i];
        NSString *str = [NSString stringWithFormat:@"%@",model.Name];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize btnSize = [str sizeWithAttributes:dict];
        
        btn.width = btnSize.width + 24;
        btn.height = btnSize.height + 14;
        
        
        btnWidth += CGRectGetMaxX(btn.frame)+24;
        
        
        
        if (btnWidth > WIDTH) {
            count++;
            btn.x = 24;
            btnWidth = CGRectGetMaxX(btn.frame);
        }else{
            btn.x += btnWidth - btn.width;
        }
        
      
        
        btn.y += count * (btn.height+17)+52;
        viewHeight = CGRectGetMaxY(btn.frame)+17;
        
        [contView addSubview:btn];
        
        btn.tag = 10000+i;
    }
    
    UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(10, viewHeight, WIDTH - 40, 202)];
    garyView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    garyView.layer.masksToBounds = YES;
    garyView.layer.cornerRadius = 7.5;
    [contView addSubview:garyView];
    self.tuBgView = contView;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(7, 3, WIDTH - 44, 50)];
    textView.delegate = self;
    textView.textColor = TCUIColorFromRGB(0x3c3c3c);
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    textView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
    [garyView addSubview:textView];
    self.textView = textView;
    
    UILabel *textLa = [UILabel publicLab:@"没有搜到想要的?搜索次序混乱?不满意的都告诉我们" textColor:TCUIColorFromRGB(0x848484) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    CGSize size = [NSString sizeWithText:textLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(WIDTH - 64,MAXFLOAT)];
    textLa.frame = CGRectMake(12, 12, WIDTH - 64, size.height);
    [garyView addSubview:textLa];
    self.textLa = textLa;
    
    UILabel *lab1 = [UILabel publicLab:@"500字内" textColor:TCUIColorFromRGB(0xb9b9b9) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab1.frame = CGRectMake(12, 46, WIDTH - 64, 11);
    [garyView addSubview:lab1];
    
    
    
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(0,92,328, 104) andIsEnter:@"assess"];//商品评价
    mediaView.isVideo = NO;
    mediaView.isfeed = YES;
    mediaView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    [garyView addSubview:mediaView];
    
    //随时获取新高度
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        mediaView.height = mediaHeight;
        garyView.height = mediaHeight + 110;
        contView.height = CGRectGetMaxY(garyView.frame) + 88;
        weakself.fieldView.y = CGRectGetMaxY(garyView.frame) + 22;
        weakself.emailLa.y = 16;
        weakself.emailField.y = 11;
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
    
    UIView *fieldView = [[UIView alloc]initWithFrame:CGRectMake(10,  CGRectGetMaxY(garyView.frame) + 22, WIDTH - 40, 44)];
    fieldView.backgroundColor = TCUIColorFromRGB(0xffffff);
    fieldView.layer.masksToBounds = YES;
    fieldView.layer.cornerRadius = 7.5;
    fieldView.layer.borderColor = TCUIColorFromRGB(0xcacaca).CGColor;
    fieldView.layer.borderWidth = 0.5;
    [contView addSubview:fieldView];
    self.fieldView = fieldView;
    
    
    
    UILabel *lab2 = [UILabel publicLab:@"电子邮箱" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    lab2.frame = CGRectMake(10, 16, 100, 13);
    [fieldView addSubview:lab2];
    self.emailLa = lab2;
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 11, WIDTH - 152, 23)];
    field.textColor = TCUIColorFromRGB(0x383838);
    field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    field.layer.masksToBounds = YES;
    field.layer.cornerRadius = 7.5;
    [fieldView addSubview:field];
    self.emailField = field;
    
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

-(void)btnClick:(UIButton *)sender{
    MMFeedbackTagModel *model = self.tags[sender.tag - 10000];
    sender.selected = !sender.selected;
    if(sender.selected){
        [sender setBackgroundColor:redColor2];
        [self.pids addObject:model.ID];
    }else{
        [sender setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
        [self.pids removeObject:model.ID];
    }
    self.pidStr = [self.pids componentsJoinedByString:@","];
    NSLog(@"%@",self.pids);
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
            weakself.index = weakself.imageStrArr.count;
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSave{
    KweakSelf(self);
    if(self.pids.count == 0){
        [ZTProgressHUD showMessage:@"请至少选择一个标签"];
    }else if(self.textView.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入投诉内容"];
    }else if (self.emailField.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入电子邮箱"];
    }else if(self.index != self.imageArr.count){
        [ZTProgressHUD showMessage:@"图片正在上传，请稍后提交"];
    }else{
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"PostTicket"];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        if(self.imageStrArr.count > 0){
            NSString *Albums = [self.imageStrArr componentsJoinedByString:@","];
            [param setValue:Albums forKey:@"Albums"];
        }
        
        [param setValue:self.memberToken forKey:@"membertoken"];
        [param setValue:self.emailField.text forKey:@"Email"];
        [param setValue:self.textView.text forKey:@"Conts"];
        [param setValue:self.pidStr forKey:@"pids"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            if([code isEqualToString:@"1"]){
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
    [TalkingDataSDK onPageEnd:@"意见反馈页面"];
}

@end
