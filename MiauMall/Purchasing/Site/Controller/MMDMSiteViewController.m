//
//  MMDMSiteViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//

#import "MMDMSiteViewController.h"
#import "MMDMHomeItemModel.h"
#import "MMDMSitLeftCell.h"
#import "MMDMSiteRightCell.h"
#import "MMClickSitePopView.h"

@interface MMDMSiteViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *allArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) MMDMHomeItemModel *selectModel;
@property (nonatomic, strong) MMClickSitePopView *sitePopView;
@end

@implementation MMDMSiteViewController

-(UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 头部视图悬停

    //设置垂直间的最小间距
    layout.minimumLineSpacing = 24;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 0;
//    layout.headerReferenceSize = CGSizeMake(WIDTH - 90,44);
    layout.sectionInset = UIEdgeInsetsMake(24,12,0, 12);//item对象上下左右的距离
    float wid = (WIDTH - 138)/3;
    layout.itemSize=CGSizeMake(wid,wid + 24);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(90,StatusBarHeight + 54, WIDTH - 90, HEIGHT - StatusBarHeight - 54) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMDMSiteRightCell class]
        forCellWithReuseIdentifier:@"cell"];
    }
    return _mainCollectionView;
}

-(UITableView *)leftTableView{
    if(!_leftTableView){
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, 90, HEIGHT - StatusBarHeight - 54) style:(UITableViewStylePlain)];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.scrollEnabled = NO;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
    }
    return _leftTableView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买站点页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.selectIndex = 0;
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"站点";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    self.sitePopView = [[MMClickSitePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.sitePopView.clickSureBlock = ^(NSString * _Nonnull str) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakself.selectModel.Link]];
    };
    
    [self GetSiteClassList];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.mainCollectionView];
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
           
            [weakself setUI];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}


#pragma mark -- uitableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDMSitLeftCell*cell = [[MMDMSitLeftCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.titleArr.count > 0) {
        cell.name = self.titleArr[indexPath.row];
    }
    if(self.selectIndex == indexPath.row){
        cell.isSelect = @"1";
    }else{
        cell.isSelect = @"0";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    [self.leftTableView reloadData];
    
    self.dataArr = [NSMutableArray arrayWithArray:self.allArr[indexPath.row]];
    [self.mainCollectionView reloadData];
}


#pragma mark -- uicollectionviewdelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    MMDMHomeItemModel *model =
    MMDMSiteRightCell *cell =
    (MMDMSiteRightCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMDMHomeItemModel *model = self.dataArr[indexPath.item];
    self.selectModel = model;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sitePopView];
    [self.sitePopView showView];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.Link]];
}

-(void)clickReturn{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代买站点页面"];
}

@end
