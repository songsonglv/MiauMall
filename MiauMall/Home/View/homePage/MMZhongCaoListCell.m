//
//  MMZhongCaoListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//

#import "MMZhongCaoListCell.h"
@interface MMZhongCaoListCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *ExplainsLa;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UIView *conV;
@end

@implementation MMZhongCaoListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIView *conV = [[UIView alloc]init];
    conV.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
    [self.contentView addSubview:conV];
    self.conV = conV;
    
    [conV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-14);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [conV addSubview:bgImage];
    self.bgImage = bgImage;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-76);
    }];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 52;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(bgImage.mas_bottom).offset(20);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *exLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x797979) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    exLa.preferredMaxLayoutWidth = WIDTH - 50;
    [exLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [conV addSubview:exLa];
    self.ExplainsLa = exLa;
    
    [exLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(bgImage.mas_bottom).offset(44);
            make.height.mas_equalTo(16);
    }];
    
}


-(void)setModel:(MMZhongCaoListModel *)model{
    _model = model;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.nameLa.text = _model.Name;
    self.ExplainsLa.text = _model.Explains;
}


@end
