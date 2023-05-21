//
//  MMMemberInfoViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//  个人信息

#import "MMMemberInfoViewController.h"
#import "MMMineMainDataModel.h"

@interface MMMemberInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *ID;//用户userID
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMMineMainDataModel *model;
@property (nonatomic, strong) UIButton *headBt;
@property (nonatomic, strong) UILabel *codeLa;
@property (nonatomic, strong) UITextField *nameField;//昵称输入框
@property (nonatomic, strong) BRDatePickerView *picekView;
@property (nonatomic, strong) UIButton *manBt;
@property (nonatomic, strong) UIButton *womanBt;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) NSString *sexStr;//性别
@property (nonatomic, strong) UILabel *birthdayLa;

@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSString *imageStr;//返回的图片地址


@end

@implementation MMMemberInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [TalkingDataSDK onPageBegin:@"个人信息页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"gerData"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberHome2"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMMineMainDataModel mj_objectWithKeyValues:jsonDic];
            weakself.imageStr = weakself.model.memberInfo.Picture;
            weakself.sexStr = weakself.model.memberInfo.Sex;
            
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage: jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, 508)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    [self.view addSubview:bgView];
    
    UIButton *headBt = [[UIButton alloc]init];
    headBt.layer.masksToBounds = YES;
    headBt.layer.cornerRadius = 56;
    [headBt sd_setImageWithURL:[NSURL URLWithString:self.model.memberInfo.Picture] forState:(UIControlStateNormal)];
    [headBt addTarget:self action:@selector(clickHead) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:headBt];
    self.headBt = headBt;
    
    [headBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.top.mas_equalTo(30);
            make.width.height.mas_equalTo(112);
    }];
    
    UILabel *tipsLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"profilePhoto"] textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    tipsLa.frame = CGRectMake(0, 164, WIDTH - 20, 15);
    [bgView addSubview:tipsLa];
    
    UILabel *lab1 = [UILabel publicLab:@"ID" textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    lab1.frame = CGRectMake(18, CGRectGetMaxY(tipsLa.frame) + 50, 80, 15);
    [bgView addSubview:lab1];
    
    UILabel *codeLa = [UILabel publicLab:self.model.memberInfo.RegCode textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    codeLa.preferredMaxLayoutWidth = 250;
    [codeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgView addSubview:codeLa];
    self.codeLa = codeLa;
    
    [codeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(110);
            make.top.mas_equalTo(CGRectGetMaxY(tipsLa.frame) + 52);
            make.height.mas_equalTo(15);
    }];
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(8, 270, WIDTH - 36, 0.5)];
    line0.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [bgView addSubview:line0];
    
    UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"nickname"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    lab2.frame = CGRectMake(18, CGRectGetMaxY(tipsLa.frame) + 120, 80, 15);
    [bgView addSubview:lab2];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(110, CGRectGetMaxY(tipsLa.frame) + 114, WIDTH - 140, 23)];
    field.text = self.model.memberInfo.Name;
    field.textColor = textBlackColor3;
    field.font = [UIFont systemFontOfSize:15];
    field.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:field];
    self.nameField = field;
    
    
//    UILabel *nameLa = [UILabel publicLab:self.model.memberInfo.Name textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
//    nameLa.preferredMaxLayoutWidth = 250;
//    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//    [bgView addSubview:nameLa];
//    self.nameLa = nameLa;
//
//    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(110);
//            make.top.mas_equalTo(CGRectGetMaxY(tipsLa.frame) + 118);
//            make.height.mas_equalTo(15);
//    }];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, 339, WIDTH - 36, 0.5)];
    line1.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [bgView addSubview:line1];
    
    UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"igender"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    lab3.frame = CGRectMake(18, CGRectGetMaxY(tipsLa.frame) + 185, 80, 15);
    [bgView addSubview:lab3];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"imale"],[UserDefaultLocationDic valueForKey:@"ifemale"]];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(110 + 120 * i, CGRectGetMaxY(tipsLa.frame) + 184, 70, 15)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x231815) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleLeft) imageTitleSpace:10];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickSex:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:btn];
        
        if(i == 0){
            self.manBt = btn;
            if([self.model.memberInfo.Sex isEqualToString:@"1"]){
                btn.selected = YES;
                self.selectBt = btn;
            }
        }else{
            self.womanBt = btn;
            if([self.model.memberInfo.Sex isEqualToString:@"2"]){
                btn.selected = YES;
                self.selectBt = btn;
            }
        }
    }
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, 407, WIDTH - 36, 0.5)];
    line2.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [bgView addSubview:line2];
    
    UILabel *lab4 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"ibirthday"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    lab4.frame = CGRectMake(18, CGRectGetMaxY(tipsLa.frame) + 256, 120, 15);
    [bgView addSubview:lab4];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
    [bgView addSubview:rightIcon];
    
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(CGRectGetMaxY(line2.frame) + 29);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *birthDayLa = [UILabel publicLab:self.model.memberInfo.Birth textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    birthDayLa.preferredMaxLayoutWidth = 200;
    [birthDayLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgView addSubview:birthDayLa];
    self.birthdayLa = birthDayLa;
    
    [birthDayLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightIcon.mas_left).offset(-10);
            make.top.mas_equalTo(CGRectGetMaxY(line2.frame) + 24);
            make.height.mas_equalTo(15);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), WIDTH - 20, 70)];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(selectBirthDay) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:btn];
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bgView.frame) + 24, WIDTH - 20, 50)];
    [saveBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [saveBt setTitle:[UserDefaultLocationDic valueForKey:@"isave"] forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0x231815) forState:(UIControlStateNormal)];
    saveBt.titleLabel.font = [UIFont systemFontOfSize:15];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 6;
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveBt];
}

#pragma mark -- 时间选择器
-(void)selectBirthDay{
    KweakSelf(self);
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMD;
    datePickerView.title = [UserDefaultLocationDic valueForKey:@"ibirthday"];
    datePickerView.selectValue = self.model.memberInfo.Birth;
//    datePickerView.selectDate = [NSDate br_setYear:2023 month:01 day:30];
    datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"选择的值：%@", selectValue);
        weakself.birthdayLa.text = selectValue;
    };
    // 设置自定义样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
    customStyle.pickerTextColor = TCUIColorFromRGB(0x231815);
    customStyle.separatorColor = [UIColor grayColor];
    customStyle.doneTextColor = selectColor;
    datePickerView.pickerStyle = customStyle;

    // 3.显示
    [datePickerView show];
}
#pragma mark -- 选择性别
-(void)clickSex:(UIButton *)sender{
    if(![self.selectBt isEqual:sender]){
        sender.selected = YES;
        self.selectBt.selected = NO;
        self.selectBt = sender;
    }
    if(self.manBt.selected == YES){
        self.sexStr = @"1";
    }else{
        self.sexStr = @"2";
    }
}

-(void)clickHead{
    NSString *takePhotoTitle = @"拍照";
    takePhotoTitle = @"相机";
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushImagePickerController];
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"] style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark -- 选择图片
-(void)takePhoto{
   //拍照
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
       __block UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
       //ipc.modalPresentationStyle = 0;
       ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
       ipc.delegate = self;
       ipc.allowsEditing = YES;
       [self presentViewController:ipc animated:YES completion:^{
           ipc = nil;
       }];
   }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
   //相册
            __block UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //设置选择后的图片可被编辑，即可以选定任意的范围
            picker.allowsEditing = YES;
            picker.delegate = self;
            //    去除毛玻璃效果
            
            picker.navigationBar.translucent=NO;
            
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    //        if (@available(iOS 11, *)) {
    //            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //
    //        }
            picker.modalPresentationStyle = 0;
            [self presentViewController:picker animated:YES completion:^{
                picker = nil;
            }];
}

//picker.delegate代理方法  选择完图片后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    KweakSelf(self);
        //image保存的是info里面被编辑过的图片
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        
        //放入全局队列中保存头像
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //将头像写入沙盒
            self.imageData = UIImageJPEGRepresentation(image, 0.5);
            self.path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"newHeade.png"];
            NSLog(@"当前的路径 %@", self.path);
            [self.imageData writeToFile:self.path atomically:NO];
            //上传服务器
            [self requestImage:self.imageData];
//            dispatch_async(dispatch_get_main_queue(), ^{//回到主队列中更新界面
//                UIImage *image = [[UIImage alloc]initWithContentsOfFile:self.path];
//                [weakself.headBt setImage:image forState:(UIControlStateNormal)];
//
//            });
        });
        
        //点击choose后跳转到前一页
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)requestImage:(NSData *)imageData{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl,@"MemPicUpload"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:imageData forKey:@"file"];
    [ZTNetworking FormImageDataPostRequestUrl:url RequestPatams:param RequestData:imageData ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD hide];
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            weakself.imageStr = key;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.headBt sd_setImageWithURL:[NSURL URLWithString:weakself.imageStr] forState:(UIControlStateNormal)];
            });
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSave{
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"UpdatePersonal"];
    NSDictionary *param = @{@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry,@"Name":self.nameField.text,@"Birth":self.birthdayLa.text,@"Email":self.model.memberInfo.Email,@"IDCard":self.model.memberInfo.IDCard,@"CardPositive":self.model.memberInfo.CardPositive,@"CardBack":self.model.memberInfo.CardBack,@"Sex":self.sexStr,@"RealName":self.model.memberInfo.RealName,@"Picture":self.imageStr,@"PostalCode":self.model.memberInfo.PostalCode,@"AreaIds":self.model.memberInfo.AreaIds,@"AreaName":self.model.memberInfo.AreaName,@"Address":self.model.memberInfo.Address};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"个人信息页面"];
}
@end
