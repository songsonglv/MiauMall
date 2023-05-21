//
//  MMGoodsClassifyTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/8.
//

#import "MMGoodsClassifyTopView.h"
#import "MMGoodsSortCell.h"
@class MMSortModel;

@interface MMGoodsClassifyTopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL fistTimeUpdateVernierLocation;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSArray *sortArr;


@end

@implementation MMGoodsClassifyTopView
-(NSMutableArray *)titles{
    if(!_titles){
        _titles = [NSMutableArray array];
    }
    return _titles;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        _fistTimeUpdateVernierLocation = YES;
        [self creatUI];
    }
    return self;
}

-(void)setClassifyArr:(NSArray *)classifyArr{
    _classifyArr = classifyArr;
    
    for (MMSortModel *model in _classifyArr) {
        [self.titles addObject:model.Name];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 解决self显示出来后vernierLocation没有更新的问题
    if (self.fistTimeUpdateVernierLocation) {
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [self setSelectedIndex:self.selectedIndex];
        self.fistTimeUpdateVernierLocation = NO;
    }
}

-(void)creatUI{
    [self addSubview:self.collectionView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 87.5, WIDTH - 10, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0x505050);
    line.alpha = 0.1;
    [self addSubview:line];
}

#pragma mark - Setters
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    MMGoodsSortCell *lastSelectedCell = [self getCell:self.selectedIndex];
    lastSelectedCell.selected = NO;
    
    if (selectedIndex > self.titles.count - 1) {
        _selectedIndex = self.titles.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    if (self.titles.count > 0) {
        [self layoutAndScrollToSelectedItem];
    }
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:!self.fistTimeUpdateVernierLocation];
    
    MMGoodsSortCell *selectedCell = [self getCell:self.selectedIndex];
    selectedCell.selected = YES;
}

-(MMGoodsSortCell *)getCell:(NSUInteger)index {
   return (MMGoodsSortCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}
#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.frame = CGRectMake(0, 0, WIDTH, 87.5);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.contentInset = UIEdgeInsetsZero;
        [_collectionView registerClass:[MMGoodsSortCell class] forCellWithReuseIdentifier:NSStringFromClass([MMGoodsSortCell class])];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80,88);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MMGoodsSortCell class]) forIndexPath:indexPath];
    cell.model = self.classifyArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MMGoodsSortCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.selected = self.selectedIndex == indexPath.item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MMSortModel *model = self.classifyArr[indexPath.item];
    // 防止快速连续点击导致连续缩放动画
    collectionView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        collectionView.userInteractionEnabled = YES;
    });
    self.tapSortBlock(model.ID);
    
    self.selectedIndex = indexPath.item;
    [self.collectionView reloadData];
}

@end
