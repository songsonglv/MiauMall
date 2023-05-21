//
//  MMWishListViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//  心愿单

#import "MMWishListViewController.h"
#import "MMWishTopView.h"
#import "MMWishListModel.h"
#import "MMWishListCell.h"
#import "MMCustomerServiceVC.h"

@interface MMWishListViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITextField *goodsNameField;
@property (nonatomic, strong) UITextView *desView;
@property (nonatomic, strong) UILabel *textLa;//textView里面的占位label 提示下文字

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@property (nonatomic, strong) NSString *bgImageUrl;//背景图片url
@property (nonatomic, strong) UIImageView *bgImage;//背景图片
@property (nonatomic, strong) UITableView *mainTableView;//我的心愿单
@property (nonatomic, strong) UITableView *wishSquareTableView;//心愿广场
@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) MMWishTopView *changeView;
@property (nonatomic, strong) UIButton *imageBt;

@property (nonatomic, strong) NSString *type;//0 展示我的心愿 1展示心愿墙
@property (nonatomic, assign) NSInteger page0;//我的心愿页码
@property (nonatomic, assign) NSInteger page1;//心愿广场页码
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *bottomV;


@end

@implementation MMWishListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [TalkingDataSDK onPageBegin:@"心愿单页面"];
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 53, WIDTH - 20, HEIGHT - StatusBarHeight - 133) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.layer.masksToBounds = YES;
        _mainTableView.layer.cornerRadius = 6;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UITableView *)wishSquareTableView{
    if(!_wishSquareTableView){
        _wishSquareTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 53, WIDTH - 20, HEIGHT - StatusBarHeight - 53 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _wishSquareTableView.backgroundColor = UIColor.clearColor;
        _wishSquareTableView.layer.masksToBounds = YES;
        _wishSquareTableView.layer.cornerRadius = 6;
        _wishSquareTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _wishSquareTableView.delegate = self;
        _wishSquareTableView.dataSource = self;
        _wishSquareTableView.showsVerticalScrollIndicator = NO;
        _wishSquareTableView.showsHorizontalScrollIndicator = NO;
    }
    return _wishSquareTableView;
}

-(UIView *)view2{
    if(!_view2){
        _view2 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.changeView.frame) + 14, WIDTH - 20, 200)];
        _view2.backgroundColor = UIColor.clearColor;
        
        UIView *clearV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 160)];
        clearV.backgroundColor = UIColor.clearColor;
        [_view2 addSubview:clearV];
        
        UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 160, WIDTH - 20, 30)];
        topV.backgroundColor = TCUIColorFromRGB(0xffffff);
        topV.layer.masksToBounds = YES;
        topV.layer.cornerRadius = 14;
        [_view2 addSubview:topV];
        
        UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(0, 180, WIDTH - 20, 20)];
        conV.backgroundColor = TCUIColorFromRGB(0xffffff);
        [_view2 addSubview:conV];
    }
    return _view2;
}

-(UIView *)view1{
    KweakSelf(self);
    if(!_view1){
        _view1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.changeView.frame) + 14, WIDTH - 20, 544)];
        _view1.backgroundColor = UIColor.clearColor;
        
        UIView *clearV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 160)];
        clearV.backgroundColor = UIColor.clearColor;
        [_view1 addSubview:clearV];
        
        UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 160, WIDTH - 20, 55)];
        topV.backgroundColor = TCUIColorFromRGB(0xffffff);
        topV.layer.masksToBounds = YES;
        topV.layer.cornerRadius = 14;
        [_view1 addSubview:topV];
        
        UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(0, 180, WIDTH - 20, 364)];
        conV.backgroundColor = TCUIColorFromRGB(0xffffff);
        [_view1 addSubview:conV];
        
        UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"upProPic"] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(12, 1, WIDTH - 44, 14);
        [conV addSubview:lab1];
        
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(12,30, 95, 81) andIsEnter:@"wish"];
        mediaView.isfeed = YES;
        mediaView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [conV addSubview:mediaView];
        
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
        
        UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"proName"] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab2.frame = CGRectMake(12, 120, WIDTH - 44, 14);
        [conV addSubview:lab2];
        
        UIView *teV = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab2.frame) + 16, WIDTH - 44, 37)];
        teV.layer.masksToBounds = YES;
        teV.layer.cornerRadius = 7.5;
        teV.layer.borderColor = TCUIColorFromRGB(0xc7c7c7).CGColor;
        teV.layer.borderWidth = 0.5;
        [conV addSubview:teV];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, teV.width - 10, 27)];
        field.placeholder = [UserDefaultLocationDic valueForKey:@"pleProName"];
        field.textColor = TCUIColorFromRGB(0x3c3c3c);
        field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        field.delegate = self;
        [teV addSubview:field];
        self.goodsNameField = field;
        
        UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"proDesc"] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab3.frame = CGRectMake(12, CGRectGetMaxY(teV.frame) + 21, WIDTH - 44, 14);
        [conV addSubview:lab3];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab3.frame) + 20, WIDTH - 44, 86)];
        textView.delegate = self;
        textView.textColor = TCUIColorFromRGB(0x3c3c3c);
        textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        textView.backgroundColor = TCUIColorFromRGB(0xffffff);
        textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 7.5;
        textView.layer.borderColor = TCUIColorFromRGB(0xc5c5c5).CGColor;
        textView.layer.borderWidth = 0.5;
        [conV addSubview:textView];
        self.desView = textView;
        
        UILabel *textLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"proDescPlace"] textColor:TCUIColorFromRGB(0xc5c5c5) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        textLa.frame = CGRectMake(10, 6, WIDTH - 64, 20);
        [textLa sizeToFit];
        [textView addSubview:textLa];
        self.textLa = textLa;
        if(textView.text.length > 0){
            textLa.hidden = YES;
        }
        
        UILabel *lab4 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"wdxy"] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        lab4.frame = CGRectMake(12, CGRectGetMaxY(textView.frame) + 20, 90, 14);
        [conV addSubview:lab4];
    }
    return _view1;
}

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(10, HEIGHT - 80, WIDTH - 20, 80)];
        _bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        UIButton *uploadBt = [[UIButton alloc]initWithFrame:CGRectMake(12, 10, WIDTH - 44, 46)];
        [uploadBt setBackgroundColor:TCUIColorFromRGB(0x160b55)];
        [uploadBt setTitle:[UserDefaultLocationDic valueForKey:@"tjwdxy"] forState:(UIControlStateNormal)];
        [uploadBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        uploadBt.layer.masksToBounds = YES;
        uploadBt.layer.cornerRadius = 7.5;
        uploadBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [uploadBt addTarget:self action:@selector(clickUpload) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomV addSubview:uploadBt];
    }
    return _bottomV;
}

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

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


- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.page0 = 1;
    self.page1 = 1;
    self.type = @"0";
    [self setUI];
    dispatch_queue_t q = dispatch_queue_create("request", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q, ^{
        [weakself requestBackImage];
//        [weakself requestMyWishData];
    });
   
    
    // Do any additional setup after loading the view.
}



-(void)requestBackImage{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPicture"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"148" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.bgImageUrl = [NSString stringWithFormat:@"%@",jsonDic[@"Picture"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.bgImage sd_setImageWithURL:[NSURL URLWithString:weakself.bgImageUrl]];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestMyWishData{
    KweakSelf(self);
    self.page0 = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberWishs"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [weakself.dataArr1 removeAllObjects];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMWishListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr1 = [NSMutableArray arrayWithArray:arr];
            [weakself.mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestWishData{
    KweakSelf(self);
    self.page1 = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetWishs"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [weakself.dataArr2 removeAllObjects];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMWishListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr2 = [NSMutableArray arrayWithArray:arr];
            [weakself.wishSquareTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setuprefresh{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.page0++;
        [self requestLoadMoreMyWishDataPage:(long)self.page0];
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainTableView.mj_footer = footer;
}

-(void)setuprefresh1{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.page1++;
        [self requestLoadMoreWishDataPage:(long)self.page1];
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.wishSquareTableView.mj_footer = footer;
}

-(void)requestLoadMoreMyWishDataPage:(NSInteger )page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetMemberWishs"];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMWishListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.dataArr1 addObjectsFromArray:arr];
                [weakself.mainTableView.mj_footer endRefreshing];
                [weakself.mainTableView reloadData];
            }else{
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
                weakself.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestLoadMoreWishDataPage:(NSInteger )page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetWishs"];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMWishListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                [weakself.dataArr2 addObjectsFromArray:arr];
                [weakself.wishSquareTableView.mj_footer endRefreshing];
                [weakself.wishSquareTableView reloadData];
            }else{
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
                weakself.wishSquareTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)setUI{
    KweakSelf(self);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/1.17)];
    bgImage.image = [UIImage imageNamed:@"zahnweif"];
    [self.view addSubview:bgImage];
    self.bgImage = bgImage;
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(20, StatusBarHeight + 17, 8, 18)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    MMWishTopView *changeView  = [[MMWishTopView alloc]initWithFrame:CGRectMake(60, StatusBarHeight + 13, WIDTH - 120, 25)];
    changeView.typeBlcok = ^(NSString * _Nonnull type) {
        weakself.type = type;
        [weakself changeShow:type];
    };
    [self.view addSubview:changeView];
    self.changeView = changeView;
    
    [self.view addSubview:self.view1];
    self.mainTableView.tableHeaderView = self.view1;
    [self.view addSubview:self.bottomV];
//    self.mainTableView.tableFooterView = self.bottomV;
    [self.view addSubview:self.mainTableView];
    
    [self.view addSubview:self.view2];
    self.wishSquareTableView.tableHeaderView = self.view2;
    [self.view addSubview:self.wishSquareTableView];
    
    self.view2.hidden = YES;
    self.wishSquareTableView.hidden = YES;
    
    [self requestMyWishData];
    [self requestWishData];
    [self setuprefresh];
    [self setuprefresh1];
    
}

//-(void)setNoneData{
//    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"zhanweif"
//                                                                 titleStr:@""
//                                                                detailStr:@"您还没添加过好物心愿！"
//                                                              btnTitleStr:@""
//                                                            btnClickBlock:^(){
//
//        }];
//    emptyView.contentViewY = 100;
//    emptyView.subViewMargin = 9.f;
//    emptyView.detailLabFont = [UIFont systemFontOfSize:12];
//    emptyView.detailLabTextColor = TCUIColorFromRGB(0x999999);
//
//    self.mainTableView.ly_emptyView = emptyView;
//}


#pragma mark -- uitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.mainTableView){
        return self.dataArr1.count;
    }else{
        return self.dataArr2.count;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMWishListCell *cell = [[MMWishListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(tableView == self.mainTableView){
        cell.model = self.dataArr1[indexPath.row];
    }else{
        cell.model = self.dataArr2[indexPath.row];
    }
   
    cell.addWishBlock = ^(NSString * _Nonnull ID) {
        [ZTProgressHUD showMessage:ID];
        [weakself inWish:ID];
    };
    cell.goShopBlock = ^(NSString * _Nonnull indexStr) {
        MMCustomerServiceVC *customVC = [[MMCustomerServiceVC alloc]init];
        [weakself.navigationController pushViewController:customVC animated:YES];
    };
    return cell;
    
}
#pragma mark -- 点击上传图片
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
            weakself.imageUrl = key;
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

-(void)changeShow:(NSString *)type{
    if([type isEqualToString:@"0"]){
        self.view1.hidden = NO;
        self.bottomV.hidden = NO;
        self.mainTableView.hidden = NO;
        self.view2.hidden = YES;
        self.wishSquareTableView.hidden = YES;
    }else{
        self.view1.hidden = YES;
        self.bottomV.hidden = YES;
        self.mainTableView.hidden = YES;
        self.view2.hidden = NO;
        self.wishSquareTableView.hidden = NO;
    }
}

#pragma mark -- 加入我的心愿单
-(void)inWish:(NSString *)ID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"InWish"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:ID forKey:@"ID"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requestWishData];
            [weakself requestMyWishData];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickUpload{
    KweakSelf(self);
    if(!self.imageUrl){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleasePic"]];
    }else if (self.goodsNameField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleProName"]];
    }else if (self.desView.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleProDesc"]];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetWish"];
        
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        [param setValue:self.imageUrl forKey:@"Picture"];
        [param setValue:self.desView.text forKey:@"Conts"];
        [param setValue:self.goodsNameField.text forKey:@"Name"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            
            if([code isEqualToString:@"1"]){
                [weakself requestMyWishData];
                [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleaseWaitAudit"]];
                weakself.goodsNameField.text = @"";
                weakself.desView.text = @"";
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
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
    [TalkingDataSDK onPageEnd:@"心愿单页面"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
}
@end
