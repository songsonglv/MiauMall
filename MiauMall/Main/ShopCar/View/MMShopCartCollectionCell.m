//
//  MMShopCartCollectionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/14.
//

#import "MMShopCartCollectionCell.h"
#import "MMShopCartGoodsCell.h"

@interface MMShopCartCollectionCell ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
//下面两个数组不要了
//@property (nonatomic, strong) NSMutableArray *arr1;//普通商品数组
//@property (nonatomic, strong) NSMutableArray *arr2;//任选商品 数组
@property (nonatomic, strong) NSMutableArray *allArr;//二维数组 里面是多个数组 表示多section
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) NSMutableArray *picArr;
@end

@implementation MMShopCartCollectionCell

-(SDCycleScrollView *)cycle{
    if(!_cycle){
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(5, 10, WIDTH - 10, self.picHei)];
        _cycle.backgroundColor = UIColor.clearColor;
        _cycle.delegate = self;
    }
    return _cycle;
}

-(NSMutableArray *)picArr{
    if(!_picArr){
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 20 + self.picHei, WIDTH - 10, self.height - 20 - self.picHei) style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
        _mainTableView.layer.masksToBounds = YES;
        _mainTableView.layer.cornerRadius = 7.5;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}
-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    self.backgroundColor = UIColor.clearColor;
    //TCUIColorFromRGB(0xf2f2f2);
    [self setupUI];
}
    return self;
}


-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.allArr removeAllObjects];
    for (int i = 0; i < _dataArr.count; i++) {
        NSArray *arr = _dataArr[i];
        NSArray *arr1 = [MMShopCarGoodsModel mj_objectArrayWithKeyValuesArray:arr];
        [self.allArr addObject:arr1];
    }
    
    [self.mainTableView reloadData];
}

-(void)setPicArr1:(NSArray *)picArr1{
    _picArr1 = picArr1;
    [self.picArr removeAllObjects];
    for (MMRotationPicModel *model in _picArr1) {
        [self.picArr addObject:model.Picture];
    }
    _cycle.imageURLStringsGroup = self.picArr;
}

-(void)setupUI{
    [self addSubview:self.cycle];
    [self addSubview:self.mainTableView];
    
    [self setNoneData];
    
}

-(void)setNoneData{
    KweakSelf(self);
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"cart_none_icon"
                                                                 titleStr:@""
                                                                detailStr:@"您的购物车还没有添加商品呦-"
                                                              btnTitleStr:[UserDefaultLocationDic valueForKey:@"lookAgain"]
                                                            btnClickBlock:^(){
        weakself.tapHomeBlock(@"1");
        }];
    emptyView.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    emptyView.contentViewY = 70;
    emptyView.subViewMargin = 16.f;
    emptyView.detailLabFont = [UIFont systemFontOfSize:11];
    emptyView.detailLabTextColor = TCUIColorFromRGB(0x999999);
    emptyView.actionBtnMargin = 18;
    emptyView.actionBtnWidth = 84;
    emptyView.actionBtnFont = [UIFont systemFontOfSize:13];
    emptyView.actionBtnHeight = 26.f;
    emptyView.actionBtnBorderColor = TCUIColorFromRGB(0x999999);
    emptyView.actionBtnCornerRadius = 13;
    emptyView.actionBtnTitleColor = TCUIColorFromRGB(0x383838);
    emptyView.actionBtnBackGroundColor = TCUIColorFromRGB(0xffffff);
    self.mainTableView.ly_emptyView = emptyView;
}

-(void)setPicHei:(float)picHei{
    _picHei = picHei;
    self.cycle.height = _picHei;
    self.mainTableView.y = CGRectGetMaxY(self.cycle.frame) + 10;
    self.mainTableView.height = self.hei - self.picHei - 20;
    
}

-(void)setFreefreightStrHead:(NSString *)freefreightStrHead{
    _freefreightStrHead = freefreightStrHead;
}

-(void)setNoDiscountTips:(NSString *)NoDiscountTips{
    _NoDiscountTips = NoDiscountTips;
}

#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.allArr[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.allArr[indexPath.section];
    MMShopCarGoodsModel *model = arr[indexPath.row];
    if([model.columnid isEqualToString:@"794"]){
        return 234;
    }else{
        return 160;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        NSArray *arr = self.allArr[section];
        MMShopCarGoodsModel *model = arr[0];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        NSString *str = [UserDefaultLocationDic valueForKey:@"nChoose"];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        
        if([model.columnid isEqualToString:@"828"]){
            str = [UserDefaultLocationDic valueForKey:@"ppzhg"];
            size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        }else if ([model.OptionalID isEqualToString:@"0"]){
            str = [UserDefaultLocationDic valueForKey:@"selfSupport"];
            size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        }
        
        UILabel *titleLa = [UILabel publicLab:str textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
        titleLa.frame = CGRectMake(12, 10, size.width + 16, 24);
        titleLa.backgroundColor = TCUIColorFromRGB(0xe68b20);
        titleLa.layer.masksToBounds = YES;
        titleLa.layer.cornerRadius = 4;
        [view addSubview:titleLa];
        
        if([model.columnid isEqualToString:@"828"]){
            titleLa.backgroundColor = TCUIColorFromRGB(0x333333);
        }else if ([model.OptionalID isEqualToString:@"0"]){
            titleLa.backgroundColor = redColor2;
        }
        
        UILabel *lab = [UILabel publicLab:model.OptionalName textColor:TCUIColorFromRGB(0x4f4f4f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
       NSString *str1;
    if([model.OptionalID isEqualToString:@"0"]){
        str1 = self.freefreightStrHead;
        
        if([model.columnid isEqualToString:@"828"]){
            str1 = self.NoDiscountTips;
        }
    }else{
        str1 = model.OptionalName;
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
        iconImage.frame = CGRectMake(WIDTH - 17, 17, 5, 10);
        [view addSubview:iconImage];
        
        UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"goCoudan"] textColor:TCUIColorFromRGB(0x919191) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 80;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.top.mas_equalTo(16);
                    make.height.mas_equalTo(12);
        }];
        
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        btn.tag = [model.ID integerValue];
        [btn addTarget:self action:@selector(clickMore) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
    lab.text = str1;
    CGSize size1 = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
    lab.frame = CGRectMake(CGRectGetMaxX(titleLa.frame) + 10, 14, size1.width, 15);
    [view addSubview:lab];
        
        
    
 
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMShopCartGoodsCell*cell = [[MMShopCartGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.allArr[indexPath.section];
    cell.model = arr[indexPath.row];
    
    cell.tapUpdateBlock = ^(MMShopCarGoodsModel * _Nonnull model, NSString * _Nonnull num) {
        weakself.tapUpdataBlock(model, num);
    };
    
    cell.tapGoodsBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
        weakself.tapGoodsBlock(model.url1);
    };
    
    cell.tapSubBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
        [weakself tapsub:model];
    };
    cell.tapAddBlock = ^(NSString * _Nonnull num, MMShopCarGoodsModel * _Nonnull model) {
        [weakself tapAdd:model];
    };
    
    cell.tapDeleteBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
        [weakself tipsShow:model];
    };
    
    cell.tapSeleBlock = ^(MMShopCarGoodsModel * _Nonnull model, NSString * _Nonnull isBuy) {
        [weakself tapSele:model andIsBuy:isBuy];
    };
    
    cell.tapAttiBlock = ^(MMShopCarGoodsModel * _Nonnull model) {
        [weakself tapAtti:model];
    };
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *arr = self.allArr[indexPath.section];
//    MMShopCarGoodsModel *model = arr[indexPath.row];
//    self.tapGoodsBlock(model.url1);
//}


#pragma mark -- 左滑操作
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        NSArray *arr = self.allArr[indexPath.section];
        MMShopCarGoodsModel *model = arr[indexPath.row];
        weakself.tapDeleteBlock(model);
    }];
    deleteRowAction.title = [UserDefaultLocationDic valueForKey:@"idelete"];
    deleteRowAction.backgroundColor = redColor2;
    [deleteRowAction setImage:[UIImage imageNamed:@"delete_icon_white"]];
    UIContextualAction *collecRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"移入收藏" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        NSArray *arr = self.allArr[indexPath.section];
        MMShopCarGoodsModel *model = arr[indexPath.row];
        weakself.tapCollecBlock(model);
    }];
    collecRowAction.title = [UserDefaultLocationDic valueForKey:@"moveCollect"];
    collecRowAction.backgroundColor = TCUIColorFromRGB(0xf37734);
    [collecRowAction setImage:[UIImage imageNamed:@"star_icon_white"]];
    
    UIContextualAction *similarRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"差找相似" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        NSArray *arr = self.allArr[indexPath.section];
        MMShopCarGoodsModel *model = arr[indexPath.row];
        [weakself tapSimiModel:model];
    }];
    similarRowAction.title = [UserDefaultLocationDic valueForKey:@"similarGoods"];
    similarRowAction.backgroundColor = TCUIColorFromRGB(0xcca169);
    [similarRowAction setImage:[UIImage imageNamed:@"similar_icon"]];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[ deleteRowAction,collecRowAction,similarRowAction]];
    return config;
}



-(void)clickMore{
   NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"lang"];
    if([lang isEqualToString:@"0"]){
        self.tapMoreBlock(@"/pages/index/page?id=1099");
    }else{
        self.tapMoreBlock(@"/pages/index/page?id=1100");
    }
}

-(void)tapSimiModel:(MMShopCarGoodsModel *)model{
//    self.tapSimilarBlock(model);
    self.tapLikeBlock(@"1",model);
}

-(void)tapAdd:(MMShopCarGoodsModel *)model{
    self.tapAddBlock(@"1", model);
}

-(void)tapsub:(MMShopCarGoodsModel *)model{
    self.tapSubBlock(@"1", model);
}

-(void)tapSele:(MMShopCarGoodsModel *)model andIsBuy:(NSString *)isbuy{
    self.tapSeleBlock(model, isbuy);
}

-(void)tipsShow:(MMShopCarGoodsModel *)model{
    self.tapDeleteBlock(model);
}

-(void)tapAtti:(MMShopCarGoodsModel *)model{
    self.tapAttiBlock(model);
}

#pragma mark -- sdcycledelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MMRotationPicModel *model = self.picArr1[index];
//    self.tapCycleBlock(model.LinkUrl);
    self.tapPicblock(model.LinkUrl);
    
}
@end
