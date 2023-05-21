//
//  MMDMLogisticInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMLogisticInfoView.h"

@interface MMDMLogisticInfoView ()
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UILabel *weightLa;
@property (nonatomic, strong) UILabel *dayLa;
@property (nonatomic, strong) UILabel *custodyFeeLa;//保管费
@property (nonatomic, strong) UILabel *photoLa;//拍照费
@property (nonatomic, strong) UILabel *diffPriceLa;//补差价
@property (nonatomic, strong) UILabel *logiticsLa;//物流费
@property (nonatomic, strong) UILabel *attachLa;//附加费
@end

@implementation MMDMLogisticInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"orderDetails"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 24, WIDTH - 34, 15);
    [self addSubview:titleLa];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"orderNo"],@"订单重量",@"已存储天数",@"保管费",@"拍照费",@"补差价",@"物流费",@"附加费"];
    float hei = 45;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 43)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(15, 15, 120, 13);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 200;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(12);
        }];
        
        hei += 43;
        
        if(i > 2){
            lab1.textColor = redColor3;
        }
        
        if(i == 0){
            self.orderNoLa = lab1;
        }else if (i == 1){
            self.weightLa = lab1;
        }else if(i == 2){
            self.dayLa = lab1;
        }else if(i == 3){
            self.custodyFeeLa = lab1;
        }else if(i == 4){
            self.photoLa = lab1;
        }else if(i == 5){
            self.diffPriceLa = lab1;
        }else if(i == 6){
            self.logiticsLa = lab1;
        }else if(i == 7){
            self.attachLa = lab1;
        }
    }
}

-(void)setModel:(MMDMChooseLogisticsModel *)model{
    _model = model;
    self.orderNoLa.text = _model.OrderNumber;
    self.weightLa.text = _model.Weight;
    self.dayLa.text = [NSString stringWithFormat:@"%@%@",_model.CustodyDay,[UserDefaultLocationDic valueForKey:@"idays"]];
    self.custodyFeeLa.text = _model.CustodyMoneyShow;
    self.photoLa.text = _model.TotalPhotoMoneyShow;
    self.diffPriceLa.text = _model.SupplementaryMoneyShow;
    self.logiticsLa.text = _model.FreightShow;
}

-(void)setAttachStr:(NSString *)attachStr{
    _attachStr = attachStr;
    self.attachLa.text = [NSString stringWithFormat:@"%@",_attachStr];
}

@end
