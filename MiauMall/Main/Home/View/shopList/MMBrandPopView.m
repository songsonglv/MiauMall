//
//  MMBrandPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import "MMBrandPopView.h"
#import "MMSelectBrandCell.h"

@interface MMBrandPopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray *seleArr;

@property (nonatomic, strong) NSString *brand;

@property (nonatomic, assign) float hei;
@end

@implementation MMBrandPopView

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

-(instancetype)initWithFrame:(CGRect)frame andHei:(float)hei{
    if (self = [super initWithFrame:frame]) {
        self.hei = hei;
        [self creatUI];
    }
    return self;
}



-(void)creatUI{
    KweakSelf(self);
//    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self addGestureRecognizer:tap];
    
//    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, 20)];
//    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
//    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0,self.hei, WIDTH, 224)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self setCircular:self.contentView andCir1:(UIRectCornerBottomLeft) andCir2:(UIRectCornerBottomRight)];
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = 7.5;
    [self addSubview:self.contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
    
    [self.contentView addSubview:self.mainCollectionView];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 176, WIDTH/2, 48)];
    [btn1 setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [btn1 setTitle:[UserDefaultLocationDic valueForKey:@"ireset"] forState:(UIControlStateNormal)];
    [btn1 setTitleColor:TCUIColorFromRGB(0x7e7e7e) forState:(UIControlStateNormal)];
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn1 addTarget:self action:@selector(clickReset) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 176, WIDTH/2, 48)];
    [btn2 setBackgroundColor:TCUIColorFromRGB(0xda391d)];
    [btn2 setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [btn2 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn2 addTarget:self action:@selector(clickSele) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    
}

#pragma mark -- uicollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMSelectBrandCell *cell =
        (MMSelectBrandCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    MMBrandModel *model = self.dataArr[indexPath.item];
    cell.model = model;
    cell.returnDataBlock = ^(NSString * _Nonnull ID, NSString * _Nonnull issele) {
        if([issele isEqualToString:@"1"]){
            [weakself.seleArr addObject:ID];
        }else{
            [weakself.seleArr removeObject:ID];
        }
        NSLog(@"%@",weakself.seleArr);
    };
    return cell;
}

-(void)clickReset{
    [self.seleArr removeAllObjects];
    
    [self.mainCollectionView reloadData];
}

-(void)clickSele{
    NSString *str = @"";
    for (NSString *ID in self.seleArr) {
        for (int i = 0; i < self.dataArr.count; i++) {
            MMBrandModel *model = self.dataArr[i];
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
    [self hideView];
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.mainCollectionView reloadData];
}

-(void)hideView1{
    
}


-(void)hideView{
    self.sureHideBlock(@"1");
    [UIView animateWithDuration:0.25 animations:^{
//        self.topView.centerY =self.topView.centerY-HEIGHT;
        self.y =-HEIGHT;
        
    } completion:^(BOOL finished) {
//         [self removeFromSuperview];
    }];
}
-(void)showView{
//    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.y =0;
         
     } completion:^(BOOL fin){}];
}

///设置圆角[左上、右上角]
- (void)setCircular:(UIView *)view andCir1:(UIRectCorner)cir1 andCir2:(UIRectCorner)cir2{

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cir1 | cir2 cornerRadii:CGSizeMake(7.5,7.5)];

//创建 layer
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = view.bounds;
//赋值
maskLayer.path = maskPath.CGPath;
view.layer.mask = maskLayer;
}

@end
