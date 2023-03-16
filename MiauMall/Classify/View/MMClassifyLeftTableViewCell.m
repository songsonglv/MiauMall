//
//  MMClassifyLeftTableViewCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import "MMClassifyLeftTableViewCell.h"
@interface MMClassifyLeftTableViewCell ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UIView *bView;
@end

@implementation MMClassifyLeftTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 4, 16)];
    bView.backgroundColor = TCUIColorFromRGB(0x000000);
    [self.contentView addSubview:bView];
    bView.hidden = YES;
    self.bView = bView;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 76;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(4);
            make.centerY.mas_equalTo(weakself.contentView);
            make.height.mas_equalTo(15);
    }];
    self.nameLa = lab;
}

-(void)setModel:(MMSortRankListItemModel *)model{
    _model = model;
    self.nameLa.text = _model.Name;
}

-(void)setIsSelect:(NSString *)isSelect{
    _isSelect = isSelect;
    if([_isSelect isEqualToString:@"1"]){
        self.bView.hidden = NO;
        self.contentView.backgroundColor = TCUIColorFromRGB(0xf6f6f6);
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
    }else{
        self.bView.hidden = YES;
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
}



@end
