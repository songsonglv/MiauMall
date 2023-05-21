//
//  MMSelectCouponPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//  选择优惠券

#import "MMSelectCouponPopView.h"
#import "MMCouponCell.h"
#import "MMCouponInfoModel.h"

@interface MMSelectCouponPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *noBt;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *isSelect;//是否使用优惠券 默认0
@end

@implementation MMSelectCouponPopView

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140, WIDTH, 320) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.isSelect = @"0";
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
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHide)];
        [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 603, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 583, WIDTH, 583)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
 
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"icoupon"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.preferredMaxLayoutWidth = 200;
    [titleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:titleLa];
    
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(16);
    }];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 16, 16)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(18, 50, 16, 16)];
    [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    btn.selected = YES;
    [btn setEnlargeEdgeWithTop:10 right:30 bottom:10 left:10];
    [btn addTarget:self action:@selector(clickNo) forControlEvents:(UIControlEventTouchUpInside)];
    self.noBt = btn;
    [self.contentView addSubview:btn];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"noCoupon"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 180;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.top.mas_equalTo(50);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = WIDTH - 40;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(110);
            make.height.mas_equalTo(14);
    }];
    
    [self.contentView addSubview:self.mainTableView];
    
    UILabel *tipLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"noteCouponsOrDiscountCode"] textColor:TCUIColorFromRGB(0xa5844d) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    tipLa.frame = CGRectMake(0, 470, WIDTH, 11);
    [self.contentView addSubview:tipLa];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(tipLa.frame) + 20, WIDTH - 36, 36)];
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:sureBt];
}

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    self.numLa.text = [NSString stringWithFormat:@"%@(%ld)",[UserDefaultLocationDic valueForKey:@"canUseCoupons"],_arr.count];
    [self.mainTableView reloadData];
}

#pragma mark -- uitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMCouponCell*cell = [[MMCouponCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.arr.count > 0) {
        MMCouponInfoModel *model = self.arr[indexPath.row];
        cell.model = model;
        cell.goHomeBlock = ^(NSString * _Nonnull str) {
            weakself.noBt.selected = NO;
            weakself.isSelect = @"1";
            weakself.selectCouponBlock(model.ID, weakself.isSelect);
            [weakself hideView];
        };
    }
    return cell;
}

-(void)clickNo{
    self.noBt.selected = YES;
    self.isSelect = @"0";
}

-(void)clickSure{
    self.tapSureBlock(self.isSelect);
    [self hideView];
}

-(void)tapHide{
    [self hideView];
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
