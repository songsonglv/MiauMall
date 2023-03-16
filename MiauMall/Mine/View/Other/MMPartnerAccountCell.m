//
//  MMPartnerAccountCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import "MMPartnerAccountCell.h"
@interface MMPartnerAccountCell ()
@property (nonatomic, strong) UIImageView *accountImage;
@property (nonatomic, strong) UILabel *typeLa;
@property (nonatomic, strong) UILabel *nameLa;
@end

@implementation MMPartnerAccountCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 113)];
    bgImage.image = [UIImage imageNamed:@"cell_card_bg"];
//    bgImage.backgroundColor = UIColor.redColor;
    bgImage.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImage];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"ali_pay_icon"];
    [bgImage addSubview:headImage];
    self.accountImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(26);
            make.width.height.mas_equalTo(60);
    }];
    
    UILabel *typeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x494645) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    typeLa.preferredMaxLayoutWidth = 100;
    [typeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:typeLa];
    
    [typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(33);
            make.height.mas_equalTo(16);
    }];
    self.typeLa = typeLa;
    
    UIButton *editBt = [[UIButton alloc]init];
    [editBt setImage:[UIImage imageNamed:@"edit_account_icon"] forState:(UIControlStateNormal)];
    [editBt addTarget:self action:@selector(clickEd) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:editBt];
    
    [editBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(typeLa.mas_right).offset(6);
            make.top.mas_equalTo(35);
            make.width.height.mas_equalTo(13);
    }];
    
    UIButton *deleteBt = [[UIButton alloc]init];
    [deleteBt setImage:[UIImage imageNamed:@"delete_account_icon"] forState:(UIControlStateNormal)];
    [deleteBt addTarget:self action:@selector(clickDele) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImage addSubview:deleteBt];
    
    [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(13);
            make.width.height.mas_equalTo(13);
    }];
    
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x5a5a5a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 200;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgImage addSubview:nameLa];
    
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(102);
            make.bottom.mas_equalTo(-34);
            make.height.mas_equalTo(14);
    }];
}

-(void)setModel:(MMPartnerAccountModel *)model{
    _model = model;
    if([_model.Type isEqualToString:@"0"]){
        self.accountImage.image = [UIImage imageNamed:@"ali_pay_icon"];
        self.typeLa.text = @"支付宝账户";
    }else if ([_model.Type isEqualToString:@"1"]){
        self.accountImage.image = [UIImage imageNamed:@"wx_pay_icon"];
        self.typeLa.text = @"微信账户";
    }else if([_model.Type isEqualToString:@"2"]){
        self.accountImage.image = [UIImage imageNamed:@"paypal_pay_icon"];
        self.typeLa.text = @"银行卡账户";
    }
    self.nameLa.text = _model.AccountNo;
}

-(void)clickDele{
    self.clickDelete(self.model.ID);
}

-(void)clickEd{
    self.clickEdit(self.model.ID);
}
@end
