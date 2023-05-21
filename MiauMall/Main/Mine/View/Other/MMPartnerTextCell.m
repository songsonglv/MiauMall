//
//  MMPartnerTextCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMPartnerTextCell.h"

@interface MMPartnerTextCell ()
@property (nonatomic, strong) UILabel *contentLa;
@end

@implementation MMPartnerTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
 
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UILabel *contentLa = [UILabel publicLab:@"" textColor:textBlackColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:14 numberOfLines:0];
    contentLa.preferredMaxLayoutWidth = WIDTH - 60;
    [contentLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:contentLa];
    
    [contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(2);
            make.width.mas_equalTo(WIDTH - 60);
    }];
    self.contentLa = contentLa;
}

-(void)setContextStr:(MMTextModel *)contextStr{
    _contextStr = contextStr;
    self.contentLa.text = _contextStr.content;
}


@end
