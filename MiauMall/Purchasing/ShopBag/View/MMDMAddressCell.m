//
//  MMDMAddressCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import "MMDMAddressCell.h"

@interface MMDMAddressCell ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *addressLa;

@end

@implementation MMDMAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI{
    UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = WIDTH - 70;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:lab1];
    self.nameLa = lab1;
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(WIDTH - 70);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 35, 20, 15, 15)];
    [btn setImage:[UIImage imageNamed:@"edit_dm_icon"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickEdit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    UILabel *lab2 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = WIDTH - 70;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:lab2];
    self.addressLa = lab2;
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(lab1.mas_bottom).offset(14);
            make.width.mas_equalTo(WIDTH - 70);
    }];
}

-(void)setModel:(MMAddressModel *)model{
    _model = model;
    self.nameLa.text = [NSString stringWithFormat:@"%@%  @",_model.Consignee,_model.MobilePhone];
    self.addressLa.text = [NSString stringWithFormat:@"%@%@",_model.AreaName,_model.Address];
}

-(void)clickEdit{
    self.editAddressBlock(self.model);
}

@end
