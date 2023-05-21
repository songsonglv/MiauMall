//
//  MMIntegralDetailCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import "MMIntegralDetailCell.h"
@interface MMIntegralDetailCell ()
@property (nonatomic, strong) UILabel *contLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *numLa;
@end

@implementation MMIntegralDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH - 100;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab];
    self.contLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(16);
                        make.top.mas_equalTo(20);
                        make.height.mas_equalTo(15);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = WIDTH - 100;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(16);
                        make.top.mas_equalTo(lab.mas_bottom).offset(12);
                        make.height.mas_equalTo(12);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xfe4a30) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:15];
    numLa.preferredMaxLayoutWidth = 200;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-18);
                        make.top.mas_equalTo(31);
                        make.height.mas_equalTo(15);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 77.5, WIDTH - 32, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [self.contentView addSubview:line];
}

-(void)setModel:(MMPointsDetailsModel *)model{
    _model = model;
    self.contLa.text = _model.Name;
    self.timeLa.text = _model.AddTime;
    self.numLa.text = [NSString stringWithFormat:@"%@%@",_model.Plus,_model.Amounts];
}

@end
