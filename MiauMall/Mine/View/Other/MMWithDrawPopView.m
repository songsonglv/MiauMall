//
//  MMWithDrawPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMWithDrawPopView.h"
#import "MMSelectWithDrawAccountCell.h"

@interface MMWithDrawPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation MMWithDrawPopView

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 72, WIDTH, 350) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArr{
    if (self = [super initWithFrame:frame]) {
        self.dataArr = dataArr;
        [self creatUI];
    }
    return self;
}

-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 580, WIDTH, 580)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:@"选择提现账户" textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(50, 28, WIDTH - 100, 18);
    [self.bgView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]init];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    [closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(32);
            make.width.height.mas_equalTo(15);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 72, WIDTH - 20, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [self.bgView addSubview:line];
    
    [self.bgView addSubview:self.mainTableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(42, 17, 26, 20)];
    iconImage.image = [UIImage imageNamed:@"card_icon_black"];
    [view addSubview:iconImage];
    
    UILabel *lab = [UILabel publicLab:@"使用新卡提现" textColor:TCUIColorFromRGB(0x8e8e8e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    lab.frame = CGRectMake(100, 22, 100, 16);
    [view addSubview:lab];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 48, 22, 8, 16)];
    rightImage.image = [UIImage imageNamed:@"right_icon_gary"];
    [view addSubview:rightImage];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, WIDTH - 20, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdedede);
    [view addSubview:line];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMSelectWithDrawAccountCell *cell = [[MMSelectWithDrawAccountCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    
    if(self.selectedIndexPath == indexPath){
        cell.selectImage.image = [UIImage imageNamed:@"select_yes"];
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"select_no"];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMPartnerAccountModel *model = self.dataArr[indexPath.row];
    _selectedIndexPath = indexPath;
    [self.mainTableView reloadData];
    [self hideView];
    self.clickJump(model, _selectedIndexPath);
}

-(void)clickBtn{
    self.addCountBlock(@"1");
    [self hideView];
}

-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}
@end
