//
//  MMDMOrderDetailAddressView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import "MMDMOrderDetailAddressView.h"

@interface MMDMOrderDetailAddressView ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UILabel *addressLa;
@end

@implementation MMDMOrderDetailAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
//    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 18, 43, 6, 12)];
//    iconImage.image = [UIImage imageNamed:@"location_icon_black"];
//    [self addSubview:iconImage];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(14);
    }];
    

    
    UILabel *addressLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 64;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:addressLa];
    self.addressLa = addressLa;
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(48);
            make.width.mas_equalTo(WIDTH - 64);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 99.5, WIDTH - 24, 0.5)];
    line.backgroundColor = lineColor2;
    [self addSubview:line];
    
    UIButton *editBt = [[UIButton alloc]init];
    [editBt setImage:[UIImage imageNamed:@"right_icon_black"] forState:(UIControlStateNormal)];
    [editBt addTarget:self action:@selector(seleAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:editBt];
    editBt.hidden = YES;
    
    [editBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(43);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
    }];
}

-(void)setModel:(MMDMOrderDetailModel *)model{
    _model = model;
    self.nameLa.text = [NSString stringWithFormat:@"%@  %@",_model.Consignee,_model.MobilePhone];
    self.addressLa.text = _model.Address;
}

-(void)setModel1:(MMDMChooseLogisticsModel *)model1{
    _model1 = model1;
    self.nameLa.text = [NSString stringWithFormat:@"%@  %@",_model1.Consignee,_model1.MobilePhone];
    self.addressLa.text = _model1.Address;
}




-(void)seleAddress{
//    self.selectAddressBlock(@"1");
}

@end
