//
//  MMConfirmGoodsPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import "MMConfirmGoodsPopView.h"
#import "MMConfirmGoodsCell.h"
#import "MMPackageGoodsModel.h"
@interface MMConfirmGoodsPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MMConfirmGoodsPopView

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 16, WIDTH, 567) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index{
    if(self = [super initWithFrame:frame]){
        self.index = index;
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
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 603, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 583, WIDTH, 583)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
 
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"goodList"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(20, 0, 180, 15);
    [self.contentView addSubview:titleLa];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = 120;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(2);
            make.height.mas_equalTo(12);
    }];
    
    [self.contentView addSubview:self.mainTableView];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMConfirmGoodsCell*cell = [[MMConfirmGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMPackageGoodsModel *model = self.dataArr[indexPath.row];
    self.jumpRouterBlock(model.url);
}

-(void)setModel:(MMConfirmOrderModel *)model{
    _model = model;
    NSString *num = _model.PackNums[self.index];
    self.numLa.text = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"ioverall"],num,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    NSArray *arr;
    if(self.index == 0){
        arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:_model.list];
    }else if (self.index == 1){
        arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:_model.list2];
    }else{
        arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:_model.list3];
    }
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.mainTableView reloadData];
}


-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
