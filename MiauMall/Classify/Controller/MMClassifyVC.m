//
//  MMClassifyVC.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/6.
//

#import "MMClassifyVC.h"
#import "MMClassifyModel.h"
#import "MMBrandBaseModel.h"
#import "MMBrandModel.h"
#import "MMSortRankListTwoModel.h"
#import "MMSortRankListItemModel.h"
#import "MMSortDataModel.h"
#import "MMClassifyLeftTableViewCell.h"
#import "MMClassifyRightTableCell.h"
#import "MMClassifyCollectionCell.h"
#import "MMGoodsListViewController.h"
#import "MMBrandCell.h"
#import "ZTLetterIndex.h"
#import "MMBrandDetailVC.h"
#import "MMGoodHotListVC.h"
#import "MMRankListViewController.h"

@interface MMClassifyVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZTLetterIndexDelegate>
{
    ZTLetterIndex  *_letterIndex;
    BOOL _isClick;
}
@property (nonatomic, strong) UITableView *leftTableView;//左边的tableview
@property (nonatomic, strong) UITableView *rightTableView;//只有选择蜜柚甄选的时候才会显示
@property (nonatomic, strong) UICollectionView *mainCollectionView;//蜜柚甄选下面的选中时显示
@property (nonatomic, strong) UITableView *brandTableView;//品牌列表
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) MMClassifyModel *model;
@property (nonatomic, strong) NSMutableArray *brandArr;//品牌数组
@property (nonatomic, strong) NSMutableArray *leftArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *classifyArr;//每个大分类下的数组
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) UIButton *classBt;
@property (nonatomic, strong) UIButton *brandBt;
@property (nonatomic, strong) UIView *buoyView;//浮标view
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) MMSortDataModel *sortModel;
@end

@implementation MMClassifyVC

-(UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 头部视图悬停
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.sectionHeadersPinToVisibleBounds = NO;
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 22;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(WIDTH - 80,96);
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 130)/3, 84);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(80,0, WIDTH - 80, self.view1.height) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMClassifyCollectionCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    }
    return _mainCollectionView;
}

-(UITableView *)leftTableView{
    if(!_leftTableView){
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, self.view1.height) style:(UITableViewStylePlain)];
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

-(UITableView *)rightTableView{
    if(!_rightTableView){
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 0, WIDTH - 80, self.view1.height) style:(UITableViewStyleGrouped)];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    return _rightTableView;
}

-(UITableView *)brandTableView{
    if(!_brandTableView){
        _brandTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.view2.height) style:(UITableViewStylePlain)];
        _brandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _brandTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _brandTableView.showsVerticalScrollIndicator = NO;
        _brandTableView.showsHorizontalScrollIndicator = NO;
        _brandTableView.delegate = self;
        _brandTableView.dataSource = self;
    }
    return _brandTableView;
}

-(NSMutableArray *)classifyArr{
    if(!_classifyArr){
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
}

-(NSMutableArray *)leftArr{
    if(!_leftArr){
        _leftArr = [NSMutableArray array];
    }
    return _leftArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)brandArr{
    if(!_brandArr){
        _brandArr = [NSMutableArray array];
    }
    return _brandArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"分类首页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.selectIndex = 0;
    _isClick = NO;
    UIView *naView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 102)];
    naView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:naView];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(12,6, WIDTH - 24, 28)];
    searchView.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    searchView.layer.cornerRadius = 14;
    searchView.layer.masksToBounds = YES;
    [naView addSubview:searchView];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 12, 12)];
    iconImage.image = [UIImage imageNamed:@"order_search_icon"];
    [searchView addSubview:iconImage];
    
    UILabel *lab = [UILabel publicLab:@"搜索" textColor:TCUIColorFromRGB(0x565656) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab.frame = CGRectMake(30, 8, WIDTH - 84, 12);
    [searchView addSubview:lab];
    
    UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 24, 28)];
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [searchView addSubview:searchBt];
    
    NSArray *arr = @[@"分类",@"品牌馆"];
    CGFloat wid = WIDTH/2;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, CGRectGetMaxY(searchView.frame) + 18, wid, 16)];
        [btn setTitleColor:TCUIColorFromRGB(0x10131f) forState:(UIControlStateNormal)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [naView addSubview:btn];
        
        if(i == 0){
            self.selectBt = btn;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
            self.classBt = btn;
            
            UIView *buoyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame) + 40, 22, 2)];
            buoyView.centerX = btn.centerX;
            buoyView.backgroundColor = TCUIColorFromRGB(0x282932);
            [naView addSubview:buoyView];
            self.buoyView = buoyView;
        }else{
            self.brandBt = btn;
        }
    }
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(naView.frame), WIDTH, HEIGHT - CGRectGetMaxY(naView.frame) - TabbarSafeBottomMargin)];
    view1.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view1];
    self.view1 = view1;
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(naView.frame), WIDTH, HEIGHT - CGRectGetMaxY(naView.frame) - TabbarSafeBottomMargin)];
    view2.hidden = YES;
    view2.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:view2];
    self.view2 = view2;
//    [self setUI];
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetClassPage"];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [ZTProgressHUD showLoadingWithMessage:@"加载中..."];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.model = [MMClassifyModel mj_objectWithKeyValues:jsonDic];
            NSArray *brandArr = [MMBrandBaseModel mj_objectArrayWithKeyValuesArray:jsonDic[@"brand"]];
            weakself.brandArr = [NSMutableArray arrayWithArray:brandArr];
            NSArray *leftArr = [MMSortRankListItemModel mj_objectArrayWithKeyValuesArray:jsonDic[@"ranklist"]];
            NSDictionary *dic = @{@"Name":@"蜜柚甄选"};
            MMSortRankListItemModel *model = [MMSortRankListItemModel mj_objectWithKeyValues:dic];
            weakself.leftArr = [NSMutableArray arrayWithArray:leftArr];
            [weakself.leftArr insertObject:model atIndex:0];
            NSArray *arr = [MMSortDataModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [ZTProgressHUD hide];
    [self.view1 addSubview:self.leftTableView];
    [self.view1 addSubview:self.rightTableView];
    self.mainCollectionView.hidden = YES;
    [self.view1 addSubview:self.mainCollectionView];
    [self.view2 addSubview:self.brandTableView];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MMBrandBaseModel *model in self.brandArr) {
        [arr addObject:model.Name];
    }
    _letterIndex = [[ZTLetterIndex alloc] initWithFrame:CGRectMake(WIDTH-30, 50, 20, 16*self.brandArr.count + 30)];
    _letterIndex.dataArray = arr; //在其他用于展示的属性赋值之后赋值
    _letterIndex.delegate = self;
    [self.view2 addSubview:_letterIndex];
}

-(void)clickSearch{
    [ZTProgressHUD showMessage:@"进搜索页面"];
}

-(void)clickBt:(UIButton *)sender{
    KweakSelf(self);
    self.selectBt.titleLabel.font = [UIFont systemFontOfSize:16];
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
    self.selectBt = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        weakself.buoyView.centerX = sender.centerX;
    }];
    
    if(sender.tag == 100){
        self.view1.hidden = NO;
        self.view2.hidden = YES;
    }else{
        self.view1.hidden = YES;
        self.view2.hidden = NO;
    }
}

#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.leftTableView){
        return 1;
    }else if (tableView == self.rightTableView){
        return self.leftArr.count - 1;
    }else if (tableView == self.brandTableView){
        return self.brandArr.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.leftTableView){
        return self.leftArr.count;
    }else if (tableView == self.rightTableView){
        MMSortRankListItemModel *model = self.leftArr[section + 1];
        return model.ranklist.count;
    }else if (tableView == self.brandTableView){
        MMBrandBaseModel *model = self.brandArr[section];
        return model.List.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.leftTableView){
        return 50;
    }else if (tableView == self.rightTableView){
        return 85;
    }else if (tableView == self.brandTableView){
        return 78;
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.rightTableView){
        return 36;
    }else if (tableView == self.brandTableView){
        return 36;
    }else{
        return 0.01;
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView == self.rightTableView){
        MMSortRankListItemModel *model = self.leftArr[section + 1];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 80, 36)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 180;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.top.mas_equalTo(19);
                    make.height.mas_equalTo(14);
        }];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
        iconImage.frame = CGRectMake(WIDTH - 105, 23, 5, 10);
        [view addSubview:iconImage];
        
        UILabel *lab1 = [UILabel publicLab:@"更多" textColor:TCUIColorFromRGB(0x919191) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 80;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.top.mas_equalTo(20);
                    make.height.mas_equalTo(12);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 110, 36)];
        btn.tag = [model.ID integerValue];
        [btn addTarget:self action:@selector(clickMore:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        return view;
    }else if (tableView == self.brandTableView){
        MMBrandModel *model = self.brandArr[section];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 36)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 105;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.top.mas_equalTo(19);
                    make.height.mas_equalTo(15);
        }];
        
        return view;
    }
    else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

//用于设置右侧索引表的内容数组，要求是字符串
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    if(tableView == self.brandTableView){
//
//        return arr;
//    }else{
//        return nil;
//    }
//
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    if(tableView == self.leftTableView){
        MMClassifyLeftTableViewCell*cell = [[MMClassifyLeftTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.leftArr.count > 0) {
            cell.model = self.leftArr[indexPath.row];
        }
        if(self.selectIndex == indexPath.row){
            cell.isSelect = @"1";
        }else{
            cell.isSelect = @"0";
        }
        return cell;
    }else if (tableView == self.brandTableView){
        MMBrandCell*cell = [[MMBrandCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"brand"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MMBrandBaseModel *model = self.brandArr[indexPath.section];
        NSArray *arr = [MMBrandModel mj_objectArrayWithKeyValuesArray:model.List];
        if (arr.count > 0) {
            cell.model = arr[indexPath.row];
        }
        return cell;
    }
    else{
        MMClassifyRightTableCell*cell = [[MMClassifyRightTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"right"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MMSortRankListItemModel *model = self.leftArr[indexPath.section + 1];
        NSArray *arr = [MMSortRankListTwoModel mj_objectArrayWithKeyValuesArray:model.ranklist];
        if (arr.count > 0) {
            cell.model = arr[indexPath.row];
        }
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.leftTableView){
        self.selectIndex = indexPath.row;
        [self.leftTableView reloadData];
        
        if(indexPath.row == 0){
            self.rightTableView.hidden = NO;
            self.mainCollectionView.hidden = YES;
        }else{
            [self.classifyArr removeAllObjects];
            MMSortDataModel *model = self.dataArr[indexPath.row - 1];
            self.sortModel = model;
            NSArray *arr = [MMSortDataModel mj_objectArrayWithKeyValuesArray:model.child];
            self.classifyArr = [NSMutableArray arrayWithArray:arr];
            self.rightTableView.hidden = YES;
            self.mainCollectionView.hidden = NO;
            [self.mainCollectionView reloadData];
        }
    }else if (tableView == self.rightTableView){
        MMSortRankListItemModel *model = self.leftArr[indexPath.section + 1];
        NSArray *arr = [MMSortRankListTwoModel mj_objectArrayWithKeyValuesArray:model.ranklist];
        MMSortRankListTwoModel *model1 = arr[indexPath.row];
        MMGoodHotListVC *hotVC = [[MMGoodHotListVC alloc]init];
        hotVC.ID = model1.ID;
        [self.navigationController pushViewController:hotVC animated:YES];
    }else if (tableView == self.brandTableView){
        MMBrandBaseModel *model = self.brandArr[indexPath.section];
        NSArray *arr = [MMBrandModel mj_objectArrayWithKeyValuesArray:model.List];
        MMBrandModel *model1 = arr[indexPath.row];
        MMBrandDetailVC *detailVC = [[MMBrandDetailVC alloc]init];
        detailVC.ID = model1.ID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -- uicollectionViewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classifyArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
        reusableview = headV;
        for (UIView *view in headV.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0, WIDTH - 110, 70)];
        [image sd_setImageWithURL:[NSURL URLWithString:self.sortModel.img] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
        [headV addSubview:image];
        
        UILabel *lab = [UILabel publicLab:self.sortModel.name textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 180;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [headV addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(16);
                    make.top.mas_equalTo(82);
                    make.height.mas_equalTo(14);
        }];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
        iconImage.frame = CGRectMake(WIDTH - 105, 85, 5, 10);
        [headV addSubview:iconImage];
        
        UILabel *lab1 = [UILabel publicLab:@"查看全部" textColor:TCUIColorFromRGB(0x919191) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 80;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [headV addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-28);
                    make.top.mas_equalTo(84);
                    make.height.mas_equalTo(12);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 80, 96)];
        [btn addTarget:self action:@selector(clickAll) forControlEvents:(UIControlEventTouchUpInside)];
        [headV addSubview:btn];
        
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMClassifyCollectionCell *cell =
    (MMClassifyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.classifyArr[indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMSortDataModel *model = self.classifyArr[indexPath.item];
    MMGoodsListViewController *listVC = [[MMGoodsListViewController alloc]init];
    listVC.pid = self.sortModel.ID;
    listVC.pids = model.ID;
    [self.navigationController pushViewController:listVC animated:YES];
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 130)/3, 84);
    
}

#pragma mark - ZTLetterIndexDelegate
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView didSelectedItemWithIndex:(NSInteger)index
{
    _isClick = YES;
    MMBrandBaseModel *model = self.brandArr[index];
    NSArray *arr = [MMBrandModel mj_objectArrayWithKeyValuesArray:model.List];
    if(arr.count == 0){
        [self.brandTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index - 1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.brandTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
        


    
    
}

#pragma mark -- 点击事件

//点击蜜柚甄选更多
-(void)clickMore:(UIButton *)sender{
    NSString *ID = [NSString stringWithFormat:@"%ld",sender.tag];
    MMRankListViewController *listVC = [[MMRankListViewController alloc]init];
    listVC.ID = ID;
    [self.navigationController pushViewController:listVC animated:YES];
}

//点击除蜜柚甄选之外的全部
-(void)clickAll{
    [self jumpRouters:self.sortModel.link];
}

#pragma mark -- 路由跳转
-(void)jumpRouters:(NSString *)routers{
    if([routers isEqualToString:@""]){
    }else{
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"分类首页"];
}
@end
