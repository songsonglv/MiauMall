//
//  MMDMOrderDetailMoneyView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import "MMDMOrderDetailMoneyView.h"

@interface MMDMOrderDetailMoneyView ()
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UILabel *weightLa;
@property (nonatomic, strong) UILabel *dayLa;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *hlLa;
@property (nonatomic, strong) UILabel *feeLa;
@property (nonatomic, strong) UILabel *yunfeeLa;
@property (nonatomic, strong) UILabel *phoneFeeLa;
@property (nonatomic, strong) UILabel *internaFeeLa;
@end

@implementation MMDMOrderDetailMoneyView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.whiteColor;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:@"订单明细" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 20, WIDTH - 34, 15);
    [self addSubview:titleLa];
    
    NSArray *arr = @[@"订单号",@"重量",@"已存储天数",@"商品金额",@"支付时间",@"结算汇率",@"手续费",@"国内运费",@"拍照服务费",@"国际运费"];
    float hei = 45;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 33)];
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 30;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH - 150;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        if(i == 0){
            self.orderNoLa = lab1;
            CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"fzCopy"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            
            UIButton *copyBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 24 - size.width, 9, size.width + 8, 15)];
            [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
            [copyBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
            copyBt.titleLabel.font = [UIFont systemFontOfSize:12];
            copyBt.layer.masksToBounds = YES;
            copyBt.layer.cornerRadius = 2.5;
            copyBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
            copyBt.layer.borderWidth = 0.5;
            [copyBt addTarget:self action:@selector(clickCopy) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:copyBt];
            
            [lab1 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(-size.width - 24);
            }];
        }else if (i == 1){
            self.weightLa = lab1;
        }else if (i == 2){
            self.dayLa = lab1;
        }else if (i == 3){
            self.moneyLa = lab1;
        }else if (i == 4){
            self.timeLa = lab1;
        }else if (i == 5){
            self.hlLa = lab1;
        }else if (i == 6){
            self.feeLa = lab1;
        }else if (i == 7){
            self.yunfeeLa = lab1;
        }else if (i == 8){
            self.phoneFeeLa = lab1;
        }else{
            self.internaFeeLa = lab1;
        }
        
        hei += 33;
    }
}

-(void)setModel:(MMDMOrderDetailModel *)model{
    _model = model;
    self.orderNoLa.text = _model.OrderNumber;
    self.weightLa.text = _model.Weight;
    self.dayLa.text = _model.CustodyDay;
    self.moneyLa.text = _model.TotalProductMoneyShow;
    self.timeLa.text = _model.PayTime;
    self.hlLa.text = _model.RateTips;
    self.feeLa.text = _model.TotalHandingMoneyShow;
    self.yunfeeLa.text = _model.JapanFreightShow;
    self.phoneFeeLa.text = _model.TotalPhotoMoneyShow;
    self.internaFeeLa.text = _model.FreightShow;
}

-(void)clickCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.ID;
    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
}

@end
