//
//  MMDMConfirmOrderAddressView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMConfirmOrderAddressView.h"

@interface MMDMConfirmOrderAddressView ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UILabel *addressLa;
@property (nonatomic, strong) UILabel *noneLa;//无数据显示

@end

@implementation MMDMConfirmOrderAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 150;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *phoneLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    phoneLa.preferredMaxLayoutWidth = 200;
    [phoneLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:phoneLa];
    
    self.phoneLa = phoneLa;
    
    [phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLa.mas_right).offset(10);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *addressLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 65;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:addressLa];
    self.addressLa = addressLa;
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(48);
            make.width.mas_equalTo(WIDTH - 65);
    }];
    
    UILabel *noneLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"selAddress"] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    noneLa.preferredMaxLayoutWidth = WIDTH - 65;
    [noneLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:noneLa];
    self.noneLa = noneLa;
    
    [noneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(weakself);
            make.width.mas_equalTo(WIDTH - 65);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(11, 99.5, WIDTH - 22, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
    [self addSubview:line];
    
    UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 18, 44, 6, 12)];
    rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
    [self addSubview:rightIcon];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    [btn addTarget:self action:@selector(clickSele) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    
    self.noneLa.hidden = NO;
    self.nameLa.hidden  = YES;
    self.phoneLa.hidden = YES;
    self.addressLa.hidden = YES;
    
}

-(void)setModel:(MMAddressModel *)model{
    _model = model;
    self.noneLa.hidden = YES;
    self.nameLa.hidden  = NO;
    self.phoneLa.hidden = NO;
    self.addressLa.hidden = NO;
    self.nameLa.text = _model.Consignee;
    self.phoneLa.text = [NSString stringWithFormat:@"%@",_model.MobilePhone];
    self.addressLa.text = [NSString stringWithFormat:@"%@%@",_model.AreaName,_model.Address];
    
}

-(void)clickSele{
    self.seleAddressBlock(@"1");
}

@end
