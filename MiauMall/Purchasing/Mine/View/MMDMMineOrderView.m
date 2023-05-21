//
//  MMDMMineOrderView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/16.
//

#import "MMDMMineOrderView.h"
#import "MMReadyPayOrderModel.h"

@interface MMDMMineOrderView ()
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) MMReadyPayOrderModel *seleModel;
@end

@implementation MMDMMineOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        [self creatUI1];
    }
    return self;
}

-(NSMutableArray *)arr{
    if(!_arr){
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(void)creatUI1{
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"myOrder"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab1.frame = CGRectMake(10, 15, 120, 14);
    [self addSubview:lab1];
    
    CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"viewAllOrders"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *lookAllBt = [[UIButton alloc]init];
    [lookAllBt setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
    lookAllBt.tag = 200;
    [lookAllBt addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    [lookAllBt setEnlargeEdgeWithTop:10 right:5 bottom:10 left:200];
    [self addSubview:lookAllBt];
    
    [lookAllBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    NSArray *arr = @[@"审核",@"物流",@"支付",@"售后",@"全部"];
    NSArray *iconArr = @[@"mm_dm_shenhe",@"mm_dm_wuliu",@"mm_dm_zhifu",@"mm_dm_sh",@"mm_dm_all"];
    float wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 50, wid, 50)];
        [btn setImage:[UIImage imageNamed:iconArr[i]] forState:(UIControlStateNormal)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        btn.tag = 201 + i;
        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:12];
        [btn addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
    }
}

-(void)creatUI{
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"myOrder"] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab1.frame = CGRectMake(10, 15, 120, 14);
    [self addSubview:lab1];
    
    CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"viewAllOrders"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *lookAllBt = [[UIButton alloc]init];
    [lookAllBt setImage:[UIImage imageNamed:@"right_icon_gary"] forState:(UIControlStateNormal)];
    lookAllBt.tag = 200;
    [lookAllBt addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    [lookAllBt setEnlargeEdgeWithTop:10 right:5 bottom:10 left:200];
    [self addSubview:lookAllBt];
    
    [lookAllBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    NSArray *arr = @[@"审核",@"物流",@"支付",@"售后",@"全部"];
    NSArray *iconArr = @[@"mm_dm_shenhe",@"mm_dm_wuliu",@"mm_dm_zhifu",@"mm_dm_sh",@"mm_dm_all"];
    float wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 50, wid, 50)];

        [self addSubview:view];

        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 25)/2, 0, 25, 25)];
        imageV.image = [UIImage imageNamed:iconArr[i]];
        [view addSubview:imageV];

        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame) + 12, wid, 13);
        [view addSubview:lab];
//
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 50)];
        btn.tag = 201 + i;
        [btn addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, 50, wid, 50)];
//        [btn setImage:[UIImage imageNamed:iconArr[i]] forState:(UIControlStateNormal)];
//        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x2a2a2a) forState:(UIControlStateNormal)];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        btn.tag = 201 + i;
//        [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleTop) imageTitleSpace:12];
//        [btn addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self addSubview:btn];
    }
    
    if(self.model.ReadyPayModels.count > 0){
        NSArray *arr = [MMReadyPayOrderModel mj_objectArrayWithKeyValuesArray:self.model.ReadyPayModels];
        self.arr = [NSMutableArray arrayWithArray:arr];
        
        MMReadyPayOrderModel *model = self.arr[0];
        self.seleModel = model;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8, 112, WIDTH - 36, 40)];
        view.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [self addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:goodsImage];
        
        UILabel *lab1 = [UILabel publicLab:model.ReadyPay textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab1.frame = CGRectMake(50, 5, WIDTH - 170, 13);
        [view addSubview:lab1];
        
        UILabel *tipsLa = [UILabel publicLab:model.Tips textColor:TCUIColorFromRGB(0x575757) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        tipsLa.frame = CGRectMake(50, 23, WIDTH - 170, 12);
        [view addSubview:tipsLa];
        
        UIButton *goBt = [[UIButton alloc]init];
        [goBt setTitle:model.GoPay forState:(UIControlStateNormal)];
        [goBt setTitleColor:TCUIColorFromRGB(0xe8436b) forState:(UIControlStateNormal)];
        goBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        goBt.titleLabel.numberOfLines = 0;
        goBt.layer.masksToBounds = YES;
        goBt.layer.cornerRadius = 10;
        goBt.layer.borderColor = TCUIColorFromRGB(0xe8436b).CGColor;
        goBt.layer.borderWidth = 0.5;
        [goBt addTarget:self action:@selector(clickGo) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:goBt];
        
        [goBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-8);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(20);
        }];
        
    }
}

-(void)clickOrder:(UIButton *)sender{
    NSInteger tag = sender.tag - 200;
    if(tag > 0 && tag < 5){
        NSString *str = [NSString stringWithFormat:@"%ld",tag];
        self.clickOrderBlock(str);
    }else{
        self.clickOrderBlock(@"0");
    }
}

-(void)setModel:(MMDMMemberModel *)model{
    _model = model;
    
    for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
    [self creatUI];
}

-(void)clickGo{
    self.clickPayBlock(self.seleModel.ID);
}

@end
