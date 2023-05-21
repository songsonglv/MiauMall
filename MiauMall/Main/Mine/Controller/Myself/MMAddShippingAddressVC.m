//
//  MMAddShippingAddressVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//  添加收货地址

#import "MMAddShippingAddressVC.h"

@interface MMAddShippingAddressVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *wxField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *cityField;
@property (nonatomic, strong) UITextField *countryField;
@property (nonatomic, strong) NSString *isDefault;
@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableArray *dataArr3;
@property (nonatomic, strong) BRAddressPickerView *addresPickerView;
@property (nonatomic, strong) NSString *AreaIds;
@end

@implementation MMAddShippingAddressVC

-(NSMutableArray *)dataArr1{
    if(!_dataArr1){
        _dataArr1 = [NSMutableArray array];
    }
    return _dataArr1;
}

-(NSMutableArray *)dataArr2{
    if(!_dataArr2){
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

-(NSMutableArray *)dataArr3{
    if(!_dataArr3){
        _dataArr3 = [NSMutableArray array];
    }
    return _dataArr3;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"添加收货地址页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.isDefault = @"0";
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"addNewAddress"];
    if(self.model){
        titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"upaddress"];
    }
    titleView.line.hidden = NO;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [self requestTreeAddress];
    
    // Do any additional setup after loading the view.
}

-(void)requestTreeAddress{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetTreeAddress"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"AreaNameData"];
           // [MMAreaItemModel mj_objectArrayWithKeyValuesArray:jsonDic[@"AreaNameData"]];
            weakself.dataArr1 = [NSMutableArray arrayWithArray:arr];
            
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.contentSize = CGSizeMake(WIDTH, 735);
    [self.view addSubview:scrollView];
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"iconsignee"],[UserDefaultLocationDic valueForKey:@"phoneNum"],[UserDefaultLocationDic valueForKey:@"iemail"],[UserDefaultLocationDic valueForKey:@"wxhao"],[UserDefaultLocationDic valueForKey:@"postCode"],[UserDefaultLocationDic valueForKey:@"speAddress"],[UserDefaultLocationDic valueForKey:@"douShi"],[UserDefaultLocationDic valueForKey:@"gjzm"]];
    NSArray *placeArr = @[[UserDefaultLocationDic valueForKey:@"mustRealName"],[UserDefaultLocationDic valueForKey:@"inputPhone"],[UserDefaultLocationDic valueForKey:@"inputEmail"],[UserDefaultLocationDic valueForKey:@"WxAccount"],[UserDefaultLocationDic valueForKey:@"inputPostCode"],[UserDefaultLocationDic valueForKey:@"inputAddress"],[UserDefaultLocationDic valueForKey:@"inputDuShi"],[UserDefaultLocationDic valueForKey:@"pleaseSelect"]];
   
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,64 * i, WIDTH, 64)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [scrollView addSubview:view];
        
        UILabel *starLa = [UILabel publicLab:@"*" textColor:TCUIColorFromRGB(0xd64f3e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        starLa.frame = CGRectMake(26, 30, 7, 7);
        [view addSubview:starLa];
        
        CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
//        lab.frame = CGRectMake(37, view, <#CGFloat width#>, <#CGFloat height#>)
        lab.preferredMaxLayoutWidth = 180;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(37);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(16);
        }];
        
        
        
        UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH - 240, 21, 220, 22)];
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeArr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x8a8a8a)}];
        field1.delegate = self;
        field1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        field1.textColor = textBlackColor2;
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentRight;
        [view addSubview:field1];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 63.5, WIDTH - 28, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [view addSubview:line];
        
        if(i == 0){
            self.nameField = field1;
        }else if (i == 1){
            self.phoneField = field1;
        }else if (i == 2){
            self.emailField = field1;
        }else if (i == 3){
            self.wxField = field1;
            starLa.hidden = YES;
        }else if (i == 4){
            self.codeField = field1;
        }else if (i == 5){
            self.addressField = field1;
        }else if (i == 6){
            self.cityField = field1;
        }else{
            self.countryField = field1;
            field1.enabled = NO;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, WIDTH - 120, 64)];
            [btn setBackgroundColor:UIColor.clearColor];
            [btn addTarget:self action:@selector(seleCountry) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }
    }
    
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(26, StatusBarHeight + 544, 15, 15)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    seleBt.selected = NO;
    [seleBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clcikSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:seleBt];
    
    UILabel *defaLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"setDef"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    defaLa.frame = CGRectMake(48, StatusBarHeight + 544, 120, 14);
    [scrollView addSubview:defaLa];
    
    UIButton *deleteBt = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(defaLa.frame) + 58, (WIDTH - 40)/2, 44)];
    [deleteBt setBackgroundColor:TCUIColorFromRGB(0x1d1d1d)];
    [deleteBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
    [deleteBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    deleteBt.layer.masksToBounds = YES;
    deleteBt.layer.cornerRadius = 22;
    deleteBt.hidden = YES;
    deleteBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [deleteBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:deleteBt];
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(defaLa.frame) + 58, WIDTH - 36, 44)];
    [saveBt setBackgroundColor:TCUIColorFromRGB(0xd64f3e)];
    [saveBt setTitle:[UserDefaultLocationDic valueForKey:@"isave"] forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 22;
    saveBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:saveBt];
    if(self.model){
        deleteBt.hidden = NO;
        saveBt.frame = CGRectMake(CGRectGetMaxX(deleteBt.frame) + 10, CGRectGetMaxY(defaLa.frame) + 58, (WIDTH - 40)/2, 44);
        self.nameField.text = self.model.Consignee;
        self.phoneField.text = self.model.MobilePhone;
        self.emailField.text = self.model.Email;
        self.wxField.text = self.model.WeiXinCode;
        self.codeField.text = self.model.PostalCode;
        self.addressField.text = self.model.Address;
        self.cityField.text = self.model.CityName;
        self.countryField.text = self.model.AreaName;
        self.AreaIds = self.model.AreaIds;
        self.isDefault = self.model.IsDefault;
    }
}


-(void)clcikSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.isDefault = @"1";
    }else{
        self.isDefault = @"0";
    }
}



-(void)seleCountry{
    KweakSelf(self);
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.wxField resignFirstResponder];
    [self.codeField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.cityField resignFirstResponder];
    
    if([self.cry isEqualToString:@"9"]){
        [BRAddressPickerView showAddressPickerWithMode:(BRAddressPickerModeArea) dataSource:self.dataArr1 selectIndexs:nil isAutoSelect:NO resultBlock:^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            weakself.AreaIds = [NSString stringWithFormat:@"%@,%@,%@",province.code,city.code,area.code];
            weakself.countryField.text = [NSString stringWithFormat:@"%@ %@ %@",province.name,city.name,area.name];
        }];
    }else{
        [BRAddressPickerView showAddressPickerWithMode:(BRAddressPickerModeCity) dataSource:self.dataArr1 selectIndexs:nil isAutoSelect:NO resultBlock:^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            weakself.AreaIds = [NSString stringWithFormat:@"%@,%@",province.code,city.code];
            weakself.countryField.text = [NSString stringWithFormat:@"%@ %@",province.name,city.name];
        }];
    }
}

#pragma mark -- 保存地址
-(void)clickSave{
    if(self.nameField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputName"]];
    }else if (self.phoneField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputCorPhone"]];
    }else if (self.emailField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputCorEmail"]];
    }else if (self.codeField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputCorCode"]];
    }else if (self.addressField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputAddress"]];
    }else if (self.cityField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputDuShi"]];
    }else if (self.countryField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"xuzgjzm"]];
    }else{
        [self saveAddressData];
    }
}

-(void)saveAddressData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AddressAddSubmit"];
    if(self.model){
        url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AddressEditSubmit"];
    }
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.nameField.text forKey:@"Consignee"];
    [param setValue:self.phoneField.text forKey:@"MobilePhone"];
    [param setValue:self.emailField.text forKey:@"Email"];
    if(self.wxField.text.length > 0){
        [param setValue:self.wxField.text forKey:@"WeiXinCode"];
    }
    [param setValue:self.codeField.text forKey:@"PostalCode"];
    [param setValue:self.addressField.text forKey:@"Address"];
    [param setValue:self.countryField.text forKey:@"AreaName"];
    [param setValue:self.cityField.text forKey:@"CityName"];
    [param setValue:self.AreaIds forKey:@"AreaIds"];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.isDefault forKey:@"IsDefault"];
    if(self.model){
        [param setValue:self.model.ID forKey:@"ID"];
        [param setValue:@"458" forKey:@"ColumnID"];
    }
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addAddressSuccess" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickDelete{
    KweakSelf(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                           message:[UserDefaultLocationDic valueForKey:@"SureToDelete"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
            [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"icancel"]
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                [action setValue:redColor2 forKey:@"titleTextColor"];
    
            }]];
    
            [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                [action setValue:selectColor forKey:@"titleTextColor"];
                [weakself clickDele:weakself.model.ID];
            }]];
    
    
    
            [self presentViewController:alert animated:true completion:nil];
}

-(void)clickDele:(NSString *)addressID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"AddressDel"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:addressID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        if([code isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addAddressSuccess" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
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
    [TalkingDataSDK onPageEnd:@"添加收货地址页面"];
}

@end
