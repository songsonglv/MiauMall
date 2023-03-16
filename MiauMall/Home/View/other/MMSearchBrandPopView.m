//
//  MMSearchBrandPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/24.
//

#import "MMSearchBrandPopView.h"
#import "MMSelectBrandCell.h"
#import "MMSortModel.h"

@interface MMSearchBrandPopView ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *dataArr1;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *seleArr1;
@property (nonatomic, strong) NSMutableArray *seleArr;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *brand;
@end

@implementation MMSearchBrandPopView

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 8;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 0;
   // layout.headerReferenceSize = CGSizeMake(0,706 + 55);
    layout.sectionInset = UIEdgeInsetsMake(0,0,8,0);//item对象上下左右的距离
    layout.itemSize=CGSizeMake(WIDTH/2, 22);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 176) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    _mainCollectionView.allowsMultipleSelection = YES;
    
    [_mainCollectionView registerClass:[MMSelectBrandCell class]
        forCellWithReuseIdentifier:@"cell"];
        }
    return _mainCollectionView;
}

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}
-(NSMutableArray *)seleArr1{
    if(!_seleArr1){
        _seleArr1 = [NSMutableArray array];
    }
    return _seleArr1;
}

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArr andData1:(nonnull NSArray *)dataArr1{
    if (self = [super initWithFrame:frame]) {
        self.dataArr = dataArr;
        self.dataArr1 = dataArr1;
        [self creatUI];
    }
    return self;
}



-(void)creatUI{
    KweakSelf(self);
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
//    [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, 20)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0,-HEIGHT, WIDTH, 224)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 7.5;
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.mainCollectionView];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 176, WIDTH/2, 48)];
    [btn1 setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [btn1 setTitle:@"重置" forState:(UIControlStateNormal)];
    [btn1 setTitleColor:TCUIColorFromRGB(0x7e7e7e) forState:(UIControlStateNormal)];
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn1 addTarget:self action:@selector(clickReset) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 176, WIDTH/2, 48)];
    [btn2 setBackgroundColor:TCUIColorFromRGB(0xda391d)];
    [btn2 setTitle:@"确定" forState:(UIControlStateNormal)];
    [btn2 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn2 addTarget:self action:@selector(clickSele) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    
}

#pragma mark -- uicollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([self.type isEqualToString:@"1"]){
        return self.dataArr1.count;
    }else{
        return self.dataArr.count;
    }
    
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MMSelectBrandCell *cell =
        (MMSelectBrandCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([self.type isEqualToString:@"0"]){
        MMSortModel *model = self.dataArr[indexPath.item];
        cell.model1 = self.dataArr[indexPath.item];
        if([self.seleArr containsObject:model.ID]){
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    }else{
        MMSortModel *model = self.dataArr1[indexPath.item];
        cell.model = self.dataArr1[indexPath.item];
        if([self.seleArr1 containsObject:model.ID]){
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    }
    
    return cell;
}

//选中cell时数据的相关操作
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.type isEqualToString:@"0"]){
        MMSortModel *model = self.dataArr[indexPath.item];
        if([self.seleArr containsObject:model.ID]){
            [self.seleArr removeObject:model.ID];
        }else{
            [self.seleArr addObject:model.ID];
        }
    }else{
        MMSortModel *model = self.dataArr1[indexPath.item];
        if([self.seleArr1 containsObject:model.ID]){
            [self.seleArr1 removeObject:model.ID];
        }else{
            [self.seleArr1 addObject:model.ID];
        }
    }
    
    [self.mainCollectionView reloadData];
}


-(void)clickReset{
    if([self.type isEqualToString:@"0"]){
        [self.seleArr removeAllObjects];
    }else{
        [self.seleArr1 removeAllObjects];
    }
    
    [self.mainCollectionView reloadData];
}

-(void)clickSele{
    NSString *str = @"";
    if([self.type isEqualToString:@"0"]){
        for (NSString *ID in self.seleArr) {
            for (int i = 0; i < self.dataArr.count; i++) {
                MMSortModel *model = self.dataArr[i];
                if([model.ID isEqualToString:ID]){
                    if(self.seleArr.count == 1){
                        str = model.Name;
                    }else{
                        if([str isEqualToString:@""]){
                            str = model.Name;
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,model.Name];
                        }
                        
                    }
                }
            }
        }
        self.sureSelectBlock(self.seleArr,str);
    }else{
        for (NSString *ID in self.seleArr1) {
            for (int i = 0; i < self.dataArr1.count; i++) {
                MMSortModel *model = self.dataArr1[i];
                if([model.ID isEqualToString:ID]){
                    if(self.seleArr1.count == 1){
                        str = model.Name;
                    }else{
                        if([str isEqualToString:@""]){
                            str = model.Name;
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,model.Name];
                        }
                        
                    }
                }
            }
        }
        self.sureSelectBlock(self.seleArr1,str);
    }
   
    [self hideView];
}

-(void)setType:(NSString *)type{
    _type = type;
    [self.mainCollectionView reloadData];
}

-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY-HEIGHT;
        self.contentView.centerY =self.contentView.centerY-HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY + HEIGHT;
        self.contentView.centerY =self.contentView.centerY + HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
