//
//  MMDMHomeViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//  代买首页

#import "MMDMHomeViewController.h"
#import "MMTabbarController.h"
#import "MMDMHomeItemModel.h"
#import "MMDMHomeCollectionViewCell.h"
#import "MMDMConfirmPurchasePopView.h"
#import "MMDMPrecautionsViewController.h"
#import "MMTextField.h"
#import "MMClickSitePopView.h"


@interface MMDMHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegateFlowLayout,HGCategoryViewDelegate,UITextPasteDelegate>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *allArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, assign) float bannerHei;
@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) MMDMConfirmPurchasePopView *popView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) MMClickSitePopView *sitePopView;
@property (nonatomic, strong)  MMDMHomeItemModel *selectModel;
@end

@implementation MMDMHomeViewController

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(NSMutableArray *)titleArr{
    if(!_titleArr){
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(SDCycleScrollView *)cycleView{
    if(!_cycleView){
        NSMutableArray *arr = [NSMutableArray array];
        for (MMRotationPicModel *model in self.bannerArr) {
            [arr addObject:model.Picture];
        }
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, self.bannerHei) imageNamesGroup:arr];
        _cycleView.delegate = self;
    }
    return _cycleView;
}

-(HGCategoryView *)categoryView{
    if(!_categoryView){
        _categoryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cycleView.frame) + 155, WIDTH, 28)];
        _categoryView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _categoryView.delegate = self;
       
        _categoryView.titles = self.titleArr;
        _categoryView.alignment = HGCategoryViewAlignmentCenter;
        _categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
        _categoryView.vernier.backgroundColor = redColor3;
        _categoryView.itemSpacing = 36;
        _categoryView.topBorder.hidden = YES;
        _categoryView.bottomBorder.hidden = YES;
        _categoryView.vernier.height = 2.0f;
        _categoryView.vernierWidth = 22;
        _categoryView.titleNormalColor = TCUIColorFromRGB(0x030303);
        _categoryView.titleSelectedColor = redColor3;
    }
    return _categoryView;
}

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.bannerHei + 196)];
        
        [_topView addSubview:self.cycleView];
        NSArray *arr = @[@"新手必读",@"国际物流",@"费用构成"];
        NSArray *iconArr = @[@"xsbd_icon",@"direct_icon",@"fygc_icon"];
        float wid = WIDTH/arr.count;
        for (int i = 0; i < arr.count; i++) {
            CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
            float allWid = 32 + size.width;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i,CGRectGetMaxY(self.cycleView.frame), wid, 64)];
            view.backgroundColor = TCUIColorFromRGB(0xffffff);
            [_topView addSubview:view];
            
            UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake((wid - allWid)/2, 24, 16, 16)];
            iconImg.image = [UIImage imageNamed:iconArr[i]];
            [view addSubview:iconImg];
            
            UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            lab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame) + 6, 25, size.width, 13);
            [view addSubview:lab];
            
            UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 4, 27, 5, 10)];
            rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
            [view addSubview:rightIcon];
            
//            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 64)];
//            btn.tag = 100 + i;
//            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
//            [view addSubview:btn];
        }
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cycleView.frame) + 64, WIDTH - 20, 40)];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 20;
        bgView.layer.borderWidth = 0.5;
        bgView.layer.borderColor = TCUIColorFromRGB(0xa0a0a0).CGColor;
        [_topView addSubview:bgView];
        
//        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(12, 11, WIDTH - 118, 18)];
//        field.placeholder = @"请输入希望代购的商品链接";
//        field.textAlignment = NSTextAlignmentLeft;
//        field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
//        field.textColor = TCUIColorFromRGB(0x585c5f);
//        field.delegate = self;
//        field.clearButtonMode = UITextFieldViewModeWhileEditing;
//        field.returnKeyType = UIReturnKeySearch;
//        [bgView addSubview:field];
        self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(12, 11, WIDTH - 124, 18)];
        self.searchField.placeholder = @"请输入希望代购的商品链接";
        self.searchField.delegate = self;//设置代理
        
//        self.searchField.tintColor = TCUIColorFromRGB(0x585c5f);
//        self.searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchField.userInteractionEnabled = YES;
        self.searchField.pasteDelegate = self;
        self.searchField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
//        self.searchField.pasteboardTypes = @[UIPasteboardTypeString];
        self.searchField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        self.searchField.textColor = TCUIColorFromRGB(0x585c5f);
        self.searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
//        [self.searchField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
        [bgView addSubview:self.searchField];
        
        UIButton *stepBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 114, 0, 94, 40)];
        stepBt.layer.masksToBounds = YES;
        stepBt.layer.cornerRadius = 20;
        [self setView:stepBt andCorlors:@[TCUIColorFromRGB(0xf78e92),TCUIColorFromRGB(0xe62d57)]];
        [stepBt setTitle:@"下一步" forState:(UIControlStateNormal)];
        [stepBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        stepBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [stepBt addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:stepBt];
        
        NSString *tips = @"请填写商品网址，我们将在人工审核后为您购买~";
        CGSize size1 = [NSString sizeWithText:tips font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(250,MAXFLOAT)];
        UILabel *tipsLa = [UILabel publicLab:tips textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        tipsLa.frame = CGRectMake(20, CGRectGetMaxY(bgView.frame) + 14, 250, size1.height);
        [_topView addSubview:tipsLa];
        
        UIImageView *questionIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipsLa.frame) + 6, CGRectGetMaxY(bgView.frame) + 13, 13, 13)];
        questionIcon.image = [UIImage imageNamed:@"question_pink"];
        [_topView addSubview:questionIcon];
        
        [_topView addSubview:self.categoryView];
    }
    return _topView;
}


-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout = layout;

        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 12;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 12;
    layout.headerReferenceSize = CGSizeMake(WIDTH,self.bannerHei + 196);
    layout.sectionInset = UIEdgeInsetsMake(12,12,0, 12);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 64)/4, (WIDTH - 64)/4 + 28);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 50, WIDTH, HEIGHT - StatusBarHeight - 50) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.whiteColor;
    
    [_mainCollectionView registerClass:[MMDMHomeCollectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader1"];
        }
    return _mainCollectionView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买首页"];
    
    // 获取剪切板内容
    NSString *pasteboardString = [[UIPasteboard generalPasteboard] string];
    if(self.searchField){
        self.searchField.text = pasteboardString;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(12, StatusBarHeight + 13, 8, 16)];
    [returnBt setImage:[UIImage imageNamed:@"icon_back_black"] forState:(UIControlStateNormal)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [returnBt addTarget:self action:@selector(clickHome) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    UILabel *titleLa = [UILabel publicLab:@"日淘代买" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(CGRectGetMaxX(returnBt.frame) + 10, StatusBarHeight + 12, 200, 18);
    [self.view addSubview:titleLa];
    
    self.popView = [[MMDMConfirmPurchasePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.popView.clickSureBlock = ^(NSString * _Nonnull str) {
        [weakself jumpGoodsInfo];
    };
    
    self.sitePopView = [[MMClickSitePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.sitePopView.clickSureBlock = ^(NSString * _Nonnull str) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakself.selectModel.Link]];
    };
    
    [self httpRequest];
    // Do any additional setup after loading the view.
}


-(void)httpRequest{
    [ZTProgressHUD showLoadingWithMessage:@""];
    [self GetPicture];
    [self GetSiteClassList];
}

-(void)GetSiteClassList{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s%@?type=%@&lang=%@&cry=%@",baseurl1,@"GetSiteClassList",@"home",self.lang,self.cry];
    if(self.memberToken){
        url = [NSString stringWithFormat:@"%@&memberToken=%@",url,self.memberToken];
    }
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.titleArr = jsonDic[@"Names"];
            for (NSArray *arr in jsonDic[@"PurchasingSiteClassList"]) {
                NSArray *arr1 = [MMDMHomeItemModel mj_objectArrayWithKeyValuesArray:arr];
                [weakself.allArr addObject:arr1];
            }
            
            weakself.dataArr = weakself.allArr[0];
           
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)GetPicture{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    NSDictionary *param = @{@"id":@"5",@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);

        NSArray *arr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        weakself.bannerArr = [NSMutableArray arrayWithArray:arr];
        dispatch_queue_t q1 = dispatch_queue_create("hei1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q1, ^{
            //banner高度
            MMRotationPicModel *model = arr[0];
            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
            weakself.bannerHei = size.height/size.width*WIDTH;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZTProgressHUD hide];
                [weakself setUI];
            });
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];
}

-(void)setUI{
    [self.view addSubview:self.mainCollectionView];
}


#pragma mark -- uitextfielddelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    // 返回YES表示允许文本变化
//    return YES;
//}



#pragma mark -- uicollectionviewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
     

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader1" forIndexPath:indexPath];
        headV.backgroundColor = TCUIColorFromRGB(0xffffff);
        reusableview = headV;
        
        [headV addSubview:self.topView];
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMDMHomeCollectionViewCell *cell =
    (MMDMHomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMDMHomeItemModel *model = self.dataArr[indexPath.item];
    self.selectModel = model;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sitePopView];
    [self.sitePopView showView];
//    [ZTProgressHUD showMessage:model.Link];
    
}

-(void)clickSearch{
    if(self.searchField.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入希望代买的商品链接"];
    }else{
        self.popView.linkUrl = self.searchField.text;
        [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
        [self.popView showView];
        
    }
}
     
-(void)clickBt:(UIButton *)sender{
    [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",sender.tag - 100]];
}

     
     

-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    self.dataArr = self.allArr[index];
    [self.mainCollectionView reloadData];
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.bannerArr[index];
    [self RouteJump:model.LinkUrl];
}


//路由跳转
-(void)RouteJump:(NSString *)routers{
    NSLog(@"跳转route为%@",routers);
    MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)jumpGoodsInfo{
    MMDMPrecautionsViewController *goodsInfoVC = [[MMDMPrecautionsViewController alloc]init];
    
    goodsInfoVC.linkUrl = self.searchField.text;
    @"https://zozo.jp/shop/tedbaker/goods/73336163/?did=120405072&rid=6060";
    //@"https://jp.mercari.com/item/m42029438265";
    //@"https://www.suruga-ya.jp/product/detail/701107976";
    // @"https://jp.mercari.com/item/m42029438265";
    //@"https://zozo.jp/shop/tedbaker/goods/73336163/?did=120405072&rid=6060";
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}
   
-(void)clickHome{
     
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMTabbarController *rootVC = [[MMTabbarController alloc]init];
    window.rootViewController = rootVC;
    rootVC.modalPresentationStyle = 0;
    [self presentViewController:rootVC animated:YES completion:nil];
        
}

//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买首页"];
    [ZTProgressHUD hide];
}
@end
