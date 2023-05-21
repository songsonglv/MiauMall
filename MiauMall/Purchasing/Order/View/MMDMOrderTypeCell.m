//
//  MMDMOrderTypeCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/9.
//

#import "MMDMOrderTypeCell.h"

@implementation MMDMOrderTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = UIColor.clearColor;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 10, 108, 13);
    [self.contentView addSubview:titleLa];
    self.titleLa = titleLa;
}

-(void)setModel:(MMDMOrderTypeModel *)model{
    _model = model;
    self.titleLa.text = _model.name;
}



@end
