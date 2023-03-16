//
//  MMOrderDetailAddressView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMOrderDetailAddressView.h"

@interface MMOrderDetailAddressView ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UILabel *addressLa;
@end

@implementation MMOrderDetailAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 17, 11, 14)];
    iconImage.image = [UIImage imageNamed:@"location_icon_black"];
    [self addSubview:iconImage];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:15 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *phoneLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:15 numberOfLines:0];
    phoneLa.preferredMaxLayoutWidth = 150;
    [phoneLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:phoneLa];
    self.phoneLa = phoneLa;
    
    [phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(12);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *addressLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 80;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:addressLa];
    self.addressLa = addressLa;
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(45);
            make.width.mas_equalTo(WIDTH - 80);
    }];
    
    UIButton *editBt = [[UIButton alloc]init];
    [editBt setImage:[UIImage imageNamed:@"edit_address_iocn"] forState:(UIControlStateNormal)];
    [editBt addTarget:self action:@selector(seleAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:editBt];
    
    [editBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(17);
            make.width.height.mas_equalTo(15);
    }];
}

-(void)setMainModel:(MMOrderDetailInfoModel *)mainModel{
    _mainModel = mainModel;
    self.nameLa.text = _mainModel.Consignee;
    self.phoneLa.text = _mainModel.MobilePhone;
    self.addressLa.text = _mainModel.Address;
}

-(void)setModel:(MMAddressModel *)model{
    _model = model;
    self.nameLa.text = _model.Consignee;
    self.phoneLa.text = _model.MobilePhone;
    self.addressLa.text = _model.Address;
}

-(void)seleAddress{
    self.selectAddressBlock(@"1");
}
@end
