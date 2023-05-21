//
//  MMRealNameViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/28.
//

#import "MMRealNameViewController.h"

@interface MMRealNameViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *memberToken;
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) NSString *frontStr1;
@property (nonatomic, strong) NSString *frontStr2;
@property (nonatomic, strong) NSString *frontStr3;
@property (nonatomic, strong) NSString *backStr1;
@property (nonatomic, strong) NSString *backStr2;
@property (nonatomic, strong) NSString *backStr3;
@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) UITextField *IDField1;
@property (nonatomic, strong) UITextField *IDField2;
@property (nonatomic, strong) UITextField *IDField3;
@property (nonatomic, strong) UIButton *frontBt1;
@property (nonatomic, strong) UIButton *frontBt2;
@property (nonatomic, strong) UIButton *frontBt3;
@property (nonatomic, strong) UIButton *backBt1;
@property (nonatomic, strong) UIButton *backBt2;
@property (nonatomic, strong) UIButton *backBt3;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MMRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    KweakSelf(self);
    self.view.backgroundColor = [UIColor colorWithWzx:0 alpha:0.7];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 610, WIDTH, 610)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    topV.layer.masksToBounds = YES;
    topV.layer.cornerRadius = 17.5;
    [self.view addSubview:topV];
    self.bgView = topV;
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 32, 18, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"realnameAuth"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 36, WIDTH, 15);
    [self.bgView addSubview:titleLa];
    
    
    if(self.orderModel.list3.count > 0){
        self.index = 3;
    }else if (self.orderModel.list2.count > 0){
        self.index = 2;
    }else{
        self.index = 1;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 20, WIDTH, 540)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(WIDTH, 325 * self.index + 214);
    [self.bgView addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    for (int i = 0; i < self.index; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 325 * i, WIDTH, 325)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [scrollView addSubview:view];
        
        UILabel *lab1 = [UILabel publicLab:[NSString stringWithFormat:@"%@%d",[UserDefaultLocationDic valueForKey:@"ipackage"],i + 1] textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(0, 5, WIDTH, 14);
        [view addSubview:lab1];
        
        UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"idNumber"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab2.frame = CGRectMake(20, 25, 76, 13);
        [view addSubview:lab2];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(96, 23, WIDTH - 106, 17)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"inpitId"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb8b9b9)}];
        field.delegate = self;
        field.returnKeyType = UIReturnKeySearch;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        field.textColor = TCUIColorFromRGB(0x383838);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        [view addSubview:field];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 60, WIDTH - 40, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xd6d6d6);
        [view addSubview:line];
        
        UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"zmPhoto"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab3.frame = CGRectMake(20, CGRectGetMaxY(line.frame) + 22, WIDTH - 40, 13);
        [view addSubview:lab3];
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lab3.frame) + 20, 68, 68)];
        [btn1 setImage:[UIImage imageNamed:@"upload_card"] forState:(UIControlStateNormal)];
        [btn1 addTarget:self action:@selector(selectPic:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn1];
        
        UILabel *lab4 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"fmPhoto"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab4.frame = CGRectMake(20, CGRectGetMaxY(btn1.frame) + 18, WIDTH - 40, 13);
        [view addSubview:lab4];
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lab4.frame) + 20, 68, 68)];
        [btn2 setImage:[UIImage imageNamed:@"upload_card"] forState:(UIControlStateNormal)];
        [btn2 addTarget:self action:@selector(selectPic:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn2];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = TCUIColorFromRGB(0xd6d6d6);
        [view addSubview:line1];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(20);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 40);
                    make.height.mas_equalTo(0.5);
        }];
        
        if(i == 0){
            self.IDField1 = field;
            self.frontBt1 = btn1;
            self.backBt1 = btn2;
        }else if (i == 1){
            self.IDField2 = field;
            self.frontBt2 = btn1;
            self.backBt2 = btn2;
        }else{
            self.IDField3 = field;
            self.frontBt3 = btn1;
            self.backBt3 = btn2;
        }
    }
    
    UIImageView *tipIcon = [[UIImageView alloc]initWithFrame:CGRectMake(18, 325 * self.index + 24, 13, 13)];
    tipIcon.image = [UIImage imageNamed:@"tip_red"];
    [scrollView addSubview:tipIcon];
    
    UILabel *tips1La = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"wsmysm"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    tips1La.frame = CGRectMake(35, 325 * self.index + 24, WIDTH - 35, 13);
    [scrollView addSubview:tips1La];
    
    NSString *str1 = [UserDefaultLocationDic valueForKey:@"gjhgzx"];
    NSString *str2 = [UserDefaultLocationDic valueForKey:@"xxjmbg"];
    
    CGSize size = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(WIDTH - 30,MAXFLOAT)];
    CGSize size1 = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(WIDTH - 30,MAXFLOAT)];
    scrollView.contentSize = CGSizeMake(WIDTH, 325 * self.index + 164 + size.height + size1.height + 10);
    UILabel *tips2La = [UILabel publicLab:str1 textColor:TCUIColorFromRGB(0x777777) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    tips2La.frame = CGRectMake(18, CGRectGetMaxY(tips1La.frame) + 16, WIDTH - 30, size.height);
    [scrollView addSubview:tips2La];
    
    UILabel *tips3La = [UILabel publicLab:str2 textColor:TCUIColorFromRGB(0x777777) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    tips3La.frame = CGRectMake(18, CGRectGetMaxY(tips2La.frame) + 10, WIDTH - 30, size1.height);
    [scrollView addSubview:tips3La];
    
    UIButton *uploadBt = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tips3La.frame) + 40, 156, 38)];
    uploadBt.backgroundColor = redColor2;
    [uploadBt setTitle:[UserDefaultLocationDic valueForKey:@"iupload"] forState:(UIControlStateNormal)];
    [uploadBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    uploadBt.layer.masksToBounds = YES;
    uploadBt.layer.cornerRadius = 19;
    uploadBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [uploadBt addTarget:self action:@selector(clickUp) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:uploadBt];
    
    UIButton *leaveBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 176, CGRectGetMaxY(tips3La.frame) + 40, 156, 38)];
    leaveBt.backgroundColor = TCUIColorFromRGB(0xe9e8e8);
    [leaveBt setTitle:[UserDefaultLocationDic valueForKey:@"ileave"] forState:(UIControlStateNormal)];
    [leaveBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    leaveBt.layer.masksToBounds = YES;
    leaveBt.layer.cornerRadius = 19;
    leaveBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [leaveBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:leaveBt];
    
    
    if([_realNameModel.IDCard isEqualToString:@""]){
        
    }else{
        self.IDField1.text = _realNameModel.IDCard;
    }
    
    if([_realNameModel.CardPositive isEqualToString:@""]){
        
    }else{
        [self.frontBt1 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardPositive] forState:(UIControlStateNormal)];
    }
    
    if([_realNameModel.CardBack isEqualToString:@""]){
        
    }else{
        [self.backBt1 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardBack] forState:(UIControlStateNormal)];
    }
    
    if([_realNameModel.IDCard2 isEqualToString:@""]){
        
    }else{
        self.IDField2.text = _realNameModel.IDCard2;
    }
    
    if([_realNameModel.CardPositive2 isEqualToString:@""]){
        
    }else{
        [self.frontBt2 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardPositive2] forState:(UIControlStateNormal)];
    }
    
    if([_realNameModel.CardBack2 isEqualToString:@""]){
        
    }else{
        [self.backBt2 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardBack2] forState:(UIControlStateNormal)];
    }
    
    if([_realNameModel.IDCard3 isEqualToString:@""]){
        
    }else{
        self.IDField3.text = _realNameModel.IDCard3;
    }
    
    if([_realNameModel.CardPositive3 isEqualToString:@""]){
        
    }else{
        [self.frontBt3 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardPositive3] forState:(UIControlStateNormal)];
    }
    
    if([_realNameModel.CardBack3 isEqualToString:@""]){
        
    }else{
        [self.backBt3 sd_setImageWithURL:[NSURL URLWithString:_realNameModel.CardBack3] forState:(UIControlStateNormal)];
    }
    // Do any additional setup after loading the view.
}

-(void)selectPic:(UIButton *)sender{
    self.selectBt = sender;
    [self clickHead];
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
            if([weakself.selectBt isEqual:weakself.frontBt1]){
                weakself.frontStr1 = key;
            }else if ([weakself.selectBt isEqual:weakself.frontBt2]){
                weakself.frontStr2 = key;
            }else if ([weakself.selectBt isEqual:weakself.frontBt3]){
                weakself.frontStr3 = key;
            }else if ([weakself.selectBt isEqual:weakself.backBt1]){
                weakself.backStr1 = key;
            }else if ([weakself.selectBt isEqual:weakself.backBt2]){
                weakself.backStr2 = key;
            }else if ([weakself.selectBt isEqual:weakself.backBt3]){
                weakself.backStr3 = key;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.selectBt sd_setImageWithURL:[NSURL URLWithString:weakself.imageStr] forState:(UIControlStateNormal)];
            });
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickUp{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.memberToken forKey:@"membertoken"];
    if(self.index == 3){
        if(self.IDField1.text.length > 0 && self.IDField2.text.length > 0 && self.IDField3.text.length > 0 && self.frontStr1.length > 0 && self.frontStr2.length > 0 && self.frontStr3.length > 0 && self.backStr1.length > 0 && self.backStr2.length > 0 && self.backStr3.length > 0){
            BOOL isIDCard1 = [ZTBSUtils IsIdentityCard:self.IDField1.text];
            BOOL isIDCard2 = [ZTBSUtils IsIdentityCard:self.IDField2.text];
            BOOL isIDCard3 = [ZTBSUtils IsIdentityCard:self.IDField3.text];
            if(isIDCard1 == NO){
                [ZTProgressHUD showMessage:@"包裹1身份证号码不正确"];
            }else if (isIDCard2 == NO){
                [ZTProgressHUD showMessage:@"包裹2身份证号码不正确"];
            }else if (isIDCard3 == NO){
                [ZTProgressHUD showMessage:@"包裹3身份证号码不正确"];
            }else{
                [param setValue:self.IDField1.text forKey:@"IDCard"];
                [param setValue:self.IDField2.text forKey:@"IDCard2"];
                [param setValue:self.IDField3.text forKey:@"IDCard3"];
                [param setValue:self.frontStr1 forKey:@"CardPositive"];
                [param setValue:self.frontStr2 forKey:@"CardPositive2"];
                [param setValue:self.frontStr3 forKey:@"CardPositive3"];
                [param setValue:self.backStr1 forKey:@"CardBack"];
                [param setValue:self.backStr2 forKey:@"CardBack2"];
                [param setValue:self.backStr3 forKey:@"CardBack3"];
                [self requestParam:param];
            }
            
        }else{
            [ZTProgressHUD showMessage:@"请将所有信息填写完整再次提交"];
        }
    }else if (self.index == 2){
        if(self.IDField1.text.length > 0 && self.IDField2.text.length > 0  && self.frontStr1.length > 0 && self.frontStr2.length > 0  && self.backStr1.length > 0 && self.backStr2.length > 0 ){
            BOOL isIDCard1 = [ZTBSUtils IsIdentityCard:self.IDField1.text];
            BOOL isIDCard2 = [ZTBSUtils IsIdentityCard:self.IDField2.text];
            if(isIDCard1 == NO){
                [ZTProgressHUD showMessage:@"包裹1身份证号码不正确"];
            }else if (isIDCard2 == NO){
                [ZTProgressHUD showMessage:@"包裹2身份证号码不正确"];
            }else{
                [param setValue:self.IDField1.text forKey:@"IDCard"];
                [param setValue:self.IDField2.text forKey:@"IDCard2"];
                
                [param setValue:self.frontStr1 forKey:@"CardPositive"];
                [param setValue:self.frontStr2 forKey:@"CardPositive2"];
                
                [param setValue:self.backStr1 forKey:@"CardBack"];
                [param setValue:self.backStr2 forKey:@"CardBack2"];
                [self requestParam:param];
            }
            
        }else{
            [ZTProgressHUD showMessage:@"请将所有信息填写完整再次提交"];
        }
    }else if (self.index == 1){
        if(self.IDField1.text.length > 0   && self.frontStr1.length > 0 &&  self.backStr1.length > 0){
            BOOL isIDCard1 = [ZTBSUtils IsIdentityCard:self.IDField1.text];
            
            if(isIDCard1 == NO){
                [ZTProgressHUD showMessage:@"包裹1身份证号码不正确"];
            }else{
                [param setValue:self.IDField1.text forKey:@"IDCard"];
                
                [param setValue:self.frontStr1 forKey:@"CardPositive"];
                
                [param setValue:self.backStr1 forKey:@"CardBack"];
                
                [self requestParam:param];
                
            }
            
        }else{
            [ZTProgressHUD showMessage:@"请将所有信息填写完整再次提交"];
        }
    }
    
    
    
    
    
}

-(void)requestParam:(NSDictionary *)param{
    KweakSelf(self);
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SaveRealNameAuth"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.returnAgoBlock(@"1");
            [weakself hideView];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)hideView1{
    
}


-(void)hideView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
