//
//  MMDMSitLeftCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import "MMDMSitLeftCell.h"

@interface MMDMSitLeftCell ()
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UIView *bView;
@end

@implementation MMDMSitLeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 90)];
    bView.backgroundColor = TCUIColorFromRGB(0xe83d68);
    [self.contentView addSubview:bView];
    bView.hidden = YES;
    self.bView = bView;
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 58;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(weakself.contentView);
            make.width.mas_equalTo(58);
    }];
    self.nameLa = lab;
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLa.text = _name;
}


-(void)setIsSelect:(NSString *)isSelect{
    _isSelect = isSelect;
    if([_isSelect isEqualToString:@"1"]){
        self.bView.hidden = NO;
        self.contentView.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    }else{
        self.bView.hidden = YES;
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
}

@end
