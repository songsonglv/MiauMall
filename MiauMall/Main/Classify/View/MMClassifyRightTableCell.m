//
//  MMClassifyRightTableCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import "MMClassifyRightTableCell.h"
@interface MMClassifyRightTableCell ()
@property (nonatomic, strong) UIImageView *pic;
@end

@implementation MMClassifyRightTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 15, WIDTH - 110, 70)];
    image.image = [UIImage imageNamed:@"zhanweic"];
    [self.contentView addSubview:image];
    self.pic = image;
}

-(void)setModel:(MMSortRankListTwoModel *)model{
    _model = model;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
}

@end
