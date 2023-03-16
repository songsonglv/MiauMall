//
//  MMClauseCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import "MMClauseCell.h"

@interface MMClauseCell ()
@property (nonatomic, strong) UILabel *nameLa;
@end

@implementation MMClauseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    titleLa.preferredMaxLayoutWidth = WIDTH - 55;
    [titleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:titleLa];
    self.nameLa = titleLa;
    
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(28);
            make.centerY.mas_equalTo(weakself.contentView);
            make.width.mas_equalTo(WIDTH - 55);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"right_icon_black"];
    [self.contentView addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(weakself.contentView);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(10);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 59.5, WIDTH - 36, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMClauseListModel *)model{
    _model = model;
    self.nameLa.text = _model.Name;
}

@end
