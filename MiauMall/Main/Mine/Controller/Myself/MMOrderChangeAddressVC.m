//
//  MMOrderChangeAddressVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//  修改订单中的收货地址

#import "MMOrderChangeAddressVC.h"
#import "MMAddShippingAddressVC.h"
#import "MMAddShippingAddressVC.h"

@interface MMOrderChangeAddressVC ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *selectBt;
@end

@implementation MMOrderChangeAddressVC



-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"改变地址页面"];
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
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 52)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"upaddress"];
    titleView.line.hidden = NO;
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:titleView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addAddressSuccess" object:nil];
    
    [self requestData];
    [self setUI];
    
    // Do any additional setup after loading the view.
}

-(void)setUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 52, WIDTH, HEIGHT - StatusBarHeight - 52)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 52);
    [self.view addSubview:scrollView];

    self.scrollView = scrollView;
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 125)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    topV.layer.masksToBounds = YES;
    topV.layer.cornerRadius = 7.5;
    [scrollView addSubview:topV];
    
    UILabel *lab = [UILabel publicLab:@"原地址" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    lab.frame = CGRectMake(14, 14, 60, 15);
    [topV addSubview:lab];
    
    UILabel *nameLa = [UILabel publicLab:self.model.Consignee textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topV addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(42);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *phoneLa = [UILabel publicLab:self.model.MobilePhone textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    phoneLa.preferredMaxLayoutWidth = 150;
    [phoneLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [topV addSubview:phoneLa];
    
    [phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(20);
            make.top.mas_equalTo(42);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *addressLa = [UILabel publicLab:self.model.Address textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 66;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [topV addSubview:addressLa];
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(phoneLa.mas_bottom).offset(14);
            make.width.mas_equalTo(WIDTH - 66);
    }];
    
    if(self.addressModel){
        nameLa.text = self.addressModel.Consignee;
        phoneLa.text = self.addressModel.MobilePhone;
        addressLa.text = self.addressModel.Address;
    }
    
}

-(void)refreshData{
    [self requestData];
}

-(void)creatList{
    UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(10, 148, WIDTH - 20, 104 * self.dataArr.count + 68)];
    listView.backgroundColor = TCUIColorFromRGB(0xffffff);
    listView.layer.masksToBounds = YES;
    listView.layer.cornerRadius = 7.5;
    [self.scrollView addSubview:listView];
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(listView.frame));
    if(CGRectGetMaxY(listView.frame) + 148 < HEIGHT - StatusBarHeight - 52){
        self.scrollView.height = CGRectGetMaxY(listView.frame) + 148;
    }
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"chooseAddress"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    lab.frame = CGRectMake(14, 18, 125, 15);
    [listView addSubview:lab];
    
    UIButton *addBt = [[UIButton alloc]init];
    [addBt setTitle:[NSString stringWithFormat:@"+ %@",[UserDefaultLocationDic valueForKey:@"addAddress"]] forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    addBt.layer.masksToBounds = YES;
    addBt.layer.cornerRadius = 5;
    addBt.layer.borderColor = TCUIColorFromRGB(0x242424).CGColor;
    addBt.layer.borderWidth = 0.5;
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [listView addSubview:addBt];
    
    [addBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(9);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
    }];
    
    UILabel *subLa = [UILabel publicLab:@"近期使用的地址" textColor:TCUIColorFromRGB(0xa8a8a8) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    subLa.frame = CGRectMake(14, CGRectGetMaxY(lab.frame) + 20, 110, 15);
    [listView addSubview:subLa];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        MMAddressModel *model = self.dataArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subLa.frame) + 104 * i, WIDTH - 20, 104)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [listView addSubview:view];
        
        UILabel *nameLa = [UILabel publicLab:model.Consignee textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:14 numberOfLines:0];
        nameLa.preferredMaxLayoutWidth = 200;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.top.mas_equalTo(20);
                make.height.mas_equalTo(14);
        }];
        
        UILabel *phoneLa = [UILabel publicLab:model.MobilePhone textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        phoneLa.preferredMaxLayoutWidth = 150;
        [phoneLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:phoneLa];
        
        [phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLa.mas_right).offset(20);
                make.top.mas_equalTo(20);
                make.height.mas_equalTo(14);
        }];
        
        UILabel *addressLa = [UILabel publicLab:model.Address textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        addressLa.preferredMaxLayoutWidth = WIDTH - 66;
        [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:addressLa];
        
        [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(13);
                make.top.mas_equalTo(phoneLa.mas_bottom).offset(14);
                make.width.mas_equalTo(WIDTH - 66);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-9);
                    make.top.mas_equalTo(45);
                    make.width.height.mas_equalTo(17);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 103.5, WIDTH - 44, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [view addSubview:line];
        
        if(i == self.dataArr.count - 1){
            line.hidden = YES;
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    MMAddressModel *model = self.dataArr[sender.tag - 100];
    
    //请求接口 修改订单的收货地址
    [self editAddress:model];
    
    if(!self.selectBt){
        sender.selected = YES;
        self.selectBt = sender;
    }else{
        if(sender != self.selectBt){
            self.selectBt.selected = !self.selectBt.selected;
            sender.selected = !sender.selected;
            self.selectBt = sender;
        }
    }
}

-(void)editAddress:(MMAddressModel *)model{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderAddressEdit"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"code"];
    if(self.model){
        [param setValue:self.model.ID forKey:@"id"];
    }else{
        [param setValue:self.addressModel.ID forKey:@"id"];
    }
    [param setValue:model.MobilePhone forKey:@"MobilePhone"];
    [param setValue:model.IDCard forKey:@"IDCard"];
    [param setValue:model.CityName forKey:@"CityName"];
    [param setValue:model.AreaName forKey:@"AreaName"];
    [param setValue:model.PostalCode forKey:@"PostalCode"];
    [param setValue:model.Email forKey:@"Email"];
    [param setValue:model.Address forKey:@"Address"];
    [param setValue:model.WeiXinCode forKey:@"WeiXinCode"];
    [param setValue:model.Consignee forKey:@"Consignee"];
    [param setValue:model.Remark forKey:@"Remark"];
    [param setValue:model.StateName forKey:@"StateName"];
    [param setValue:model.Address forKey:@"AreaAddress"];//本身地址列表里面没有这个字段
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            if([weakself.isEnder isEqualToString:@"1"]){
                weakself.selectAddressBlock(model);
            }
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickAdd{
    MMAddShippingAddressVC *addVC = [[MMAddShippingAddressVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)requestData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAddressList"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *addressArr = [MMAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:addressArr];
            [weakself creatList];
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
    [TalkingDataSDK onPageEnd:@"改变地址页面"];
}

@end
