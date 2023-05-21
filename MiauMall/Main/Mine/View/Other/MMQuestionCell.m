//
//  MMQuestionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import "MMQuestionCell.h"
@interface MMQuestionCell ()
@property (nonatomic, strong) UILabel *nameLa;
@end

@implementation MMQuestionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    titleLa.preferredMaxLayoutWidth = WIDTH - 36;
    [titleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:titleLa];
    self.nameLa = titleLa;
    
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(weakself.contentView);
            make.width.mas_equalTo(WIDTH - 55);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"right_icon_gary"];
    [self.contentView addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(weakself.contentView);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(10);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 39.5, WIDTH - 36, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMQuestionSecondModel *)model{
    _model = model;
    self.nameLa.text = _model.Name;
}
@end
