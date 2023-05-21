//
//  MMTabClassifyCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import "MMTabClassifyCell.h"

@interface MMTabClassifyCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HGCategoryViewDelegate>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tabArr;//分类数组
@property (nonatomic, assign) CGFloat tabHei;//默认44
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *bageColor;
@property (nonatomic, strong) HGCategoryView *categoryView;

@end

@implementation MMTabClassifyCell

-(HGCategoryView *)categoryView{
    if(!_categoryView){
        _categoryView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0,0, WIDTH, self.tabHei)];
        _categoryView.backgroundColor = self.bageColor;
        _categoryView.delegate = self;
        _categoryView.titles = self.tabArr;
        _categoryView.alignment = HGCategoryViewAlignmentCenter;
        _categoryView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _categoryView.titleNormalColor = self.textColor;
        _categoryView.titleSelectedColor = self.selectTextColor;
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
        _categoryView.vernier.backgroundColor = self.selectTextColor;
        _categoryView.itemSpacing = 24;
        _categoryView.topBorder.hidden = YES;
        _categoryView.bottomBorder.hidden = YES;
        _categoryView.vernier.height = 2.0f;
        _categoryView.vernierWidth = 18;
    }
    return _categoryView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)tabArr{
    if(!_tabArr){
        _tabArr = [NSMutableArray array];
    }
    return _tabArr;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionHeadersPinToVisibleBounds = YES;
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
   // layout.headerReferenceSize = CGSizeMake(0,706 + 55);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 100) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    _mainCollectionView.bounces = NO;
   
    [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _mainCollectionView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.tabHei = 44;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.mainCollectionView];
}

#pragma mark - uicollectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, self.tabHei + 2);
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = UIColor.clearColor;
        reusableview = headV;
        [headV addSubview:self.categoryView];
        
    }
    return reusableview;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(self.dataArr.count > 0){
        cell.model1 = self.dataArr[indexPath.item];
        cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
    //        weakself.goodsId = indexStr;
    //        [weakself GetProductBuyTest:indexStr];
        };
    }
    
    return cell;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    self.textColor = [UIColor colorWithWzxString:_model.fontColor];
    self.selectTextColor = [UIColor colorWithWzxString:_model.havedian];
    self.bageColor = [UIColor colorWithWzxString:_model.otherColor];
}

-(void)setContArr:(NSArray *)contArr{
    _contArr = contArr;
    MMHomePageContModel *model = _contArr[0];
    
    self.dataArr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.prolist];
    NSInteger num = self.dataArr.count/2;
    num = self.dataArr.count%2 > 0 ? num + 1 : num;
    CGFloat hei = num * ((WIDTH - 30)/2 + 153) + 46;
    CGFloat hei1 = HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin;
    if(hei > hei1){
        self.mainCollectionView.height = hei1;
        self.mainCollectionView.scrollEnabled = YES;
    }else{
        self.mainCollectionView.height = hei;
        self.mainCollectionView.scrollEnabled = NO;
    }
   
    [self.tabArr removeAllObjects];
    for (MMHomePageContModel *model in _contArr) {
        [self.tabArr addObject:model.subtitle];
    }
    [self.mainCollectionView reloadData];
}


-(void)categoryViewDidSelectedItemAtIndex:(NSInteger)index{
    [self.dataArr removeAllObjects];
    MMHomePageContModel *model = self.contArr[index];
    self.dataArr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.prolist];
    [self.mainCollectionView reloadData];
}


#pragma mark -- uiscrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSLog(@"consize.hei= %.f",scrollView.contentSize.height);
    NSLog(@"%.f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y >= scrollView.contentSize.height){
        
    }
}

@end
